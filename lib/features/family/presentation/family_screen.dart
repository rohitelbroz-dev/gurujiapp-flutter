import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/widgets/app_bottom_nav.dart';
import 'package:guruji/features/family/bloc/family_bloc.dart';
import 'package:guruji/features/family/models/family_member.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  static const Color primaryPlum = Color(0xFF7E2B58);
  static const Color richRose = Color(0xFF8E3763);
  static const Color mauveAccent = Color(0xFFCE6590);
  static const Color bgEnd = Color(0xFFFBF4F7);
  static const Color charcoalText = Color(0xFF1F1A1D);
  static const Color subtitleColor = Color(0xFF6B5F66);

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
      backgroundColor: bgEnd,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: primaryPlum),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: const Text(
          'Family Sadhana Circle',
          style: TextStyle(
            color: primaryPlum,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            fontFamily: 'serif',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: primaryPlum),
            onPressed: _refreshFamilyTree,
          ),
        ],
      ),
      body: BlocConsumer<FamilyBloc, FamilyState>(
        listener: (context, state) {
          if (state is FamilyFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FamilyLoading || state is FamilyInitial) {
            return const Center(
              child: CircularProgressIndicator(color: primaryPlum),
            );
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
              color: primaryPlum,
              onRefresh: () async => _refreshFamilyTree(),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  _FamilyHeroCard(rootMember: familyTree),
                  const SizedBox(height: 16),
                  _FamilyStatsRow(rootMember: familyTree),
                  const SizedBox(height: 22),
                  const Text(
                    'Family Hierarchy Tree',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      fontFamily: 'serif',
                      color: charcoalText,
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
      bottomNavigationBar: const AppBottomNav(currentTab: AppNavTab.panchang),
    );
  }
}

// ─── Hero Card ───────────────────────────────────────────────────────────────
class _FamilyHeroCard extends StatelessWidget {
  const _FamilyHeroCard({required this.rootMember});
  final FamilyMember rootMember;

  static const Color primaryPlum = Color(0xFF7E2B58);
  static const Color richRose = Color(0xFF8E3763);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryPlum, richRose],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryPlum.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _FamilyAvatar(member: rootMember, radius: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rootMember.name.isEmpty ? 'Karta (Head of Family)' : rootMember.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    rootMember.relationLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (rootMember.phone.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    rootMember.phone,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stats Row ───────────────────────────────────────────────────────────────
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
            color: const Color(0xFF7E2B58),
            bgColor: const Color(0xFFFFF0F5),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'Children',
            value: '$childrenCount',
            icon: Icons.family_restroom_rounded,
            color: const Color(0xFFC86134),
            bgColor: const Color(0xFFFFF0E8),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'Relations',
            value: '$connectionCount',
            icon: Icons.hub_rounded,
            color: const Color(0xFF2E8A68),
            bgColor: const Color(0xFFEBF7F2),
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
    required this.bgColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF3E5EB)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B5F66),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hierarchy Tile ──────────────────────────────────────────────────────────
class _FamilyMemberTile extends StatelessWidget {
  const _FamilyMemberTile({
    required this.member,
    required this.level,
    this.isRoot = false,
  });

  final FamilyMember member;
  final int level;
  final bool isRoot;

  static const Color primaryPlum = Color(0xFF7E2B58);
  static const Color richRose = Color(0xFF8E3763);

  @override
  Widget build(BuildContext context) {
    final leftIndent = level * 14.0;

    return Padding(
      padding: EdgeInsets.only(left: leftIndent, bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isRoot ? primaryPlum.withOpacity(0.3) : const Color(0xFFF3E5EB),
            width: isRoot ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ExpansionTile(
          shape: const Border(),
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          leading: _FamilyAvatar(member: member, radius: 22),
          title: Text(
            member.name.isEmpty ? 'Unknown Member' : member.name,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F1A1D),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              children: [
                Text(
                  member.relationLabel,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: richRose,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (member.phone.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Text(
                    '• ${member.phone}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF6B5F66),
                    ),
                  ),
                ],
              ],
            ),
          ),
          children: [
            if (member.children.isEmpty && member.connections.isEmpty)
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    'No direct sub-branches found.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B5F66)),
                  ),
                ),
              ),
            if (member.children.isNotEmpty) ...[
              const _SectionLabel(
                icon: Icons.account_tree_outlined,
                label: 'Direct Lineage (Children)',
              ),
              const SizedBox(height: 10),
              ...member.children.map(
                (child) => _FamilyMemberTile(member: child, level: level + 1),
              ),
            ],
            if (member.connections.isNotEmpty) ...[
              const SizedBox(height: 8),
              const _SectionLabel(
                icon: Icons.hub_outlined,
                label: 'Connected Relatives',
              ),
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
  static const Color primaryPlum = Color(0xFF7E2B58);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF4F7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF3E5EB)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: primaryPlum.withOpacity(0.12),
            child: Text(
              connection.name.isEmpty ? '?' : connection.name[0].toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                color: primaryPlum,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  connection.name.isEmpty ? 'Relative' : connection.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F1A1D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  connection.relationType.isEmpty
                      ? connection.phone
                      : '${connection.relationType} • ${connection.phone}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B5F66),
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
  static const Color primaryPlum = Color(0xFF7E2B58);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: primaryPlum),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1F1A1D),
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
  static const Color primaryPlum = Color(0xFF7E2B58);

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
      backgroundColor: Colors.white.withOpacity(0.9),
      child: Text(
        member.name.isEmpty ? '?' : member.name[0].toUpperCase(),
        style: TextStyle(
          fontSize: radius * 0.72,
          fontWeight: FontWeight.w800,
          color: primaryPlum,
        ),
      ),
    );
  }
}

class _FamilyErrorView extends StatelessWidget {
  const _FamilyErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;
  static const Color primaryPlum = Color(0xFF7E2B58);

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
              size: 56,
              color: primaryPlum,
            ),
            const SizedBox(height: 14),
            const Text(
              'Unable to load family circle',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F1A1D),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B5F66)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPlum,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
