import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/widgets/app_bottom_nav.dart';
import 'package:guruji/features/events/bloc/events_bloc.dart';
import 'package:guruji/features/events/models/event_model.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  int _currentPage = 1;
  final int _limit = 10;

  static const Color primaryPlum = Color(0xFF7E2B58);
  static const Color richRose = Color(0xFF8E3763);
  static const Color emeraldGreen = Color(0xFF2E8A68);
  static const Color bgEnd = Color(0xFFFBF4F7);
  static const Color charcoalText = Color(0xFF1F1A1D);
  static const Color subtitleColor = Color(0xFF6B5F66);

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    context.read<EventsBloc>().add(
      FetchEventsEvent(page: _currentPage, limit: _limit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/home');
        }
      },
      child: Scaffold(
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
          'Spiritual Events & Utsav',
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
            onPressed: _loadEvents,
          ),
        ],
      ),
      body: BlocListener<EventsBloc, EventsState>(
        listener: (context, state) {
          if (state is EventsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            if (state is EventsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: primaryPlum),
              );
            } else if (state is EventsLoadSuccess) {
              final events = state.eventsResponse.events;
              final totalPages = state.eventsResponse.totalPages;

              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      color: primaryPlum,
                      onRefresh: () async => _loadEvents(),
                      child: events.isEmpty
                          ? _buildEmptyState()
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                              itemCount: events.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 14),
                              itemBuilder: (context, index) {
                                final event = events[index];
                                return _buildEventCard(event);
                              },
                            ),
                    ),
                  ),
                  if (totalPages > 1) _buildPaginationControls(totalPages),
                ],
              );
            } else if (state is EventsFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
                    const SizedBox(height: 12),
                    Text(state.message, style: const TextStyle(fontSize: 14, color: charcoalText)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadEvents,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPlum,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
        bottomNavigationBar: const AppBottomNav(currentTab: AppNavTab.panchang),
      ),
    );
  }

  // ─── Event Card ────────────────────────────────────────────────────────────
  Widget _buildEventCard(Event event) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3E5EB)),
        boxShadow: [
          BoxShadow(
            color: primaryPlum.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image (if any)
          if (event.coverImage.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: event.coverImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (_, __) => Container(
                    color: const Color(0xFFFBF4F7),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(color: primaryPlum),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: const Color(0xFFFBF4F7),
                    alignment: Alignment.center,
                    child: const Icon(Icons.event_note_rounded, size: 40, color: primaryPlum),
                  ),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'serif',
                          color: charcoalText,
                        ),
                      ),
                    ),
                    if (event.rsvpCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF7F2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${event.rsvpCount} Attending',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: emeraldGreen,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                // Date Row
                if (event.dateRange.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded, size: 15, color: richRose),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.dateRange,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: richRose,
                          ),
                        ),
                      ),
                    ],
                  ),
                // Location Row
                if (event.location.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 15, color: subtitleColor),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: subtitleColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Pagination ────────────────────────────────────────────────────────────
  Widget _buildPaginationControls(int totalPages) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: _currentPage > 1
                ? () {
                    setState(() => _currentPage--);
                    _loadEvents();
                  }
                : null,
            icon: const Icon(Icons.arrow_back_rounded, size: 16),
            label: const Text('Previous'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryPlum,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          Text(
            'Page $_currentPage of $totalPages',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: charcoalText,
            ),
          ),
          ElevatedButton.icon(
            onPressed: _currentPage < totalPages
                ? () {
                    setState(() => _currentPage++);
                    _loadEvents();
                  }
                : null,
            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
            label: const Text('Next'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryPlum,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.event_available_rounded, size: 56, color: primaryPlum),
          const SizedBox(height: 12),
          const Text(
            'No upcoming events at this moment',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: charcoalText),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadEvents,
            style: ElevatedButton.styleFrom(backgroundColor: primaryPlum),
            child: const Text('Refresh', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
