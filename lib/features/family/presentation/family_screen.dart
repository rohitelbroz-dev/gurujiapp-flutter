import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/app.dart';
import 'package:guruji/features/family/bloc/family_bloc.dart';
import 'package:guruji/features/family/models/family_member.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FamilyBloc>().add(const FetchFamilyTreeEvent());
  }

  void _refreshFamilyTree() {
    context.read<FamilyBloc>().add(const FetchFamilyTreeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EA),
      appBar: AppBar(
        title: const Text('Family'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.white,
      ),
      body: BlocConsumer<FamilyBloc, FamilyState>(
        listener: (context, state) {
          if (state is FamilyFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FamilyLoading || state is FamilyInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FamilyFailure) {
            return _FamilyErrorView(
              message: state.message,
              onRetry: _refreshFamilyTree,
            );
          }

          if (state is FamilyLoadSuccess) {
            final familyTree = state.familyTree;
            return RefreshIndicator(
              color: AppTheme.primaryDark,
              onRefresh: () async => _refreshFamilyTree(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  _FamilyHeroCard(rootMember: familyTree),
                  const SizedBox(height: 16),
                  _FamilyStatsRow(rootMember: familyTree),
                  const SizedBox(height: 20),
                  Text(
                    'Family Tree',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _FamilyMemberTile(member: familyTree, level: 0, isRoot: true),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.white,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey.shade400,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Family'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              break;
            case 2:
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }
}

class _FamilyHeroCard extends StatelessWidget {
  const _FamilyHeroCard({required this.rootMember});
  final FamilyMember rootMember;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF2A900), Color(0xFFD18C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryDark.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _FamilyAvatar(member: rootMember, radius: 34),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rootMember.name.isEmpty ? 'Unknown Member' : rootMember.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  rootMember.relationLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rootMember.phone.isEmpty
                      ? 'Phone not available'
                      : rootMember.phone,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FamilyStatsRow extends StatelessWidget {
  const _FamilyStatsRow({required this.rootMember});

  final FamilyMember rootMember;

  int _countMembers(FamilyMember member) {
    var total = 1;
    for (final child in member.children) {
      total += _countMembers(child);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final totalMembers = _countMembers(rootMember);
    final childrenCount = rootMember.children.length;
    final connectionCount = rootMember.connections.length;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Members',
            value: '$totalMembers',
            icon: Icons.group_rounded,
            color: const Color(0xFF4A7AE0),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Children',
            value: '$childrenCount',
            icon: Icons.family_restroom_rounded,
            color: const Color(0xFFE07C54),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Links',
            value: '$connectionCount',
            icon: Icons.hub_rounded,
            color: const Color(0xFF2DAA6E),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary.withOpacity(0.62),
            ),
          ),
        ],
      ),
    );
  }
}

class _FamilyMemberTile extends StatelessWidget {
  const _FamilyMemberTile({
    required this.member,
    required this.level,
    this.isRoot = false,
  });

  final FamilyMember member;
  final int level;
  final bool isRoot;

  @override
  Widget build(BuildContext context) {
    final leftIndent = level * 18.0;

    return Padding(
      padding: EdgeInsets.only(left: leftIndent, bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isRoot
                ? AppTheme.primaryColor.withOpacity(0.35)
                : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          leading: _FamilyAvatar(member: member, radius: 24),
          title: Text(
            member.name.isEmpty ? 'Unknown Member' : member.name,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.relationLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  member.phone.isEmpty ? 'Phone not available' : member.phone,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textPrimary.withOpacity(0.65),
                  ),
                ),
              ],
            ),
          ),
          children: [
            if (member.children.isEmpty && member.connections.isEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'No child members found.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textPrimary.withOpacity(0.6),
                  ),
                ),
              ),
            if (member.children.isNotEmpty) ...[
              _SectionLabel(
                icon: Icons.account_tree_outlined,
                label: 'Children',
              ),
              const SizedBox(height: 10),
              ...member.children.map(
                (child) => _FamilyMemberTile(member: child, level: level + 1),
              ),
            ],
            if (member.connections.isNotEmpty) ...[
              const SizedBox(height: 8),
              _SectionLabel(icon: Icons.hub_outlined, label: 'Connections'),
              const SizedBox(height: 10),
              ...member.connections.map(
                (connection) => _ConnectionTile(connection: connection),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ConnectionTile extends StatelessWidget {
  const _ConnectionTile({required this.connection});

  final FamilyConnection connection;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6EF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.15),
            child: Text(
              connection.name.isEmpty ? '?' : connection.name[0].toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppTheme.primaryDark,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  connection.name.isEmpty
                      ? 'Unknown Connection'
                      : connection.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  connection.relationType.isEmpty
                      ? connection.phone
                      : '${connection.relationType} • ${connection.phone}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textPrimary.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryDark),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _FamilyAvatar extends StatelessWidget {
  const _FamilyAvatar({required this.member, required this.radius});

  final FamilyMember member;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (member.hasProfileImage) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(member.profileImage),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white.withOpacity(0.92),
      child: Text(
        member.name.isEmpty ? '?' : member.name[0].toUpperCase(),
        style: TextStyle(
          fontSize: radius * 0.72,
          fontWeight: FontWeight.w800,
          color: AppTheme.primaryDark,
        ),
      ),
    );
  }
}

class _FamilyErrorView extends StatelessWidget {
  const _FamilyErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.group_off_rounded,
              size: 58,
              color: AppTheme.primaryDark,
            ),
            const SizedBox(height: 14),
            const Text(
              'Unable to load family details',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimary.withOpacity(0.65),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
