import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gal/gal.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/localization/app_strings.dart';
import 'package:guruji/core/widgets/app_bottom_nav.dart';
import 'package:guruji/features/amrit_vachan/bloc/amrit_vachan_bloc.dart';
import 'package:guruji/features/amrit_vachan/models/amrit_vachan_model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class AmritVachanScreen extends StatefulWidget {
  const AmritVachanScreen({super.key});

  @override
  State<AmritVachanScreen> createState() => _AmritVachanScreenState();
}

class _AmritVachanScreenState extends State<AmritVachanScreen> {
  static const MethodChannel _whatsAppChannel = MethodChannel(
    'guruji/whatsapp_share',
  );

  static const Color primaryPlum = Color(0xFF7E2B58);
  static const Color richRose = Color(0xFF8E3763);
  static const Color mauveCard = Color(0xFFCE6590);
  static const Color bgStart = Color(0xFFFFFDFE);
  static const Color bgEnd = Color(0xFFFBF4F7);
  static const Color charcoalText = Color(0xFF1F1A1D);
  static const Color subtitleColor = Color(0xFF6B5F66);

  @override
  void initState() {
    super.initState();
    context.read<AmritVachanBloc>().add(const FetchAmritVachanEvent());
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
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            context.tr('amritVachanHeader'),
            style: const TextStyle(
              color: primaryPlum,
              fontWeight: FontWeight.w700,
              fontSize: 17,
              fontFamily: 'serif',
            ),
            maxLines: 1,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: primaryPlum),
            onPressed: () {
              context.read<AmritVachanBloc>().add(
                const FetchAmritVachanEvent(),
              );
            },
          ),
        ],
      ),
      body: BlocListener<AmritVachanBloc, AmritVachanState>(
        listener: (context, state) {
          if (state is AmritVachanFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: BlocBuilder<AmritVachanBloc, AmritVachanState>(
          builder: (context, state) {
            if (state is AmritVachanLoading) {
              return const Center(
                child: CircularProgressIndicator(color: primaryPlum),
              );
            }

            if (state is AmritVachanLoadSuccess) {
              return RefreshIndicator(
                color: primaryPlum,
                onRefresh: () async {
                  context.read<AmritVachanBloc>().add(
                    const FetchAmritVachanEvent(),
                  );
                },
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    // Count Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBF4F7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF3E5EB)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.auto_stories_rounded, size: 16, color: primaryPlum),
                          const SizedBox(width: 8),
                          Text(
                            '${context.tr('totalAmritVachan')} : ${state.allPosts.length}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: primaryPlum,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Today's Featured Card
                    if (state.todayPosts.isNotEmpty)
                      _buildTodayCard(state.todayPosts.first),
                    if (state.todayPosts.isNotEmpty) const SizedBox(height: 24),

                    // All Posts Header
                    Text(
                      context.tr('allAmritVachan'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'serif',
                        color: charcoalText,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...state.allPosts.map(_buildListCard),
                  ],
                ),
              );
            }

            if (state is AmritVachanFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
                    const SizedBox(height: 12),
                    Text(state.message, style: const TextStyle(fontSize: 14, color: charcoalText)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AmritVachanBloc>().add(const FetchAmritVachanEvent());
                      },
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

  // ─── Today's Hero Card ─────────────────────────────────────────────────────
  Widget _buildTodayCard(AmritVachan post) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF0F5), Color(0xFFFBE4ED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF7D9E4), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: primaryPlum.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [primaryPlum, richRose]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star_rounded, size: 14, color: Colors.amberAccent),
                    SizedBox(width: 4),
                    Text(
                      'आज का अमृत वचन',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _formatDate(post.scheduledDate),
                style: const TextStyle(
                  fontSize: 12,
                  color: subtitleColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            post.caption,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'serif',
              color: charcoalText,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: CachedNetworkImage(
              imageUrl: post.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (_, __) => Container(
                height: 260,
                color: Colors.white,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(color: primaryPlum),
              ),
              errorWidget: (_, __, ___) => Container(
                height: 260,
                color: Colors.white,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image_outlined, size: 42, color: primaryPlum),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildActionRow(post),
        ],
      ),
    );
  }

  // ─── List Card ─────────────────────────────────────────────────────────────
  Widget _buildListCard(AmritVachan post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  post.caption,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'serif',
                    color: charcoalText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _formatDate(post.scheduledDate),
            style: const TextStyle(
              fontSize: 12,
              color: subtitleColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: post.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (_, __) => Container(
                height: 220,
                color: const Color(0xFFF8EEF3),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(color: primaryPlum),
              ),
              errorWidget: (_, __, ___) => Container(
                height: 220,
                color: const Color(0xFFF8EEF3),
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image_outlined, size: 36, color: primaryPlum),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _buildActionRow(post),
        ],
      ),
    );
  }

  // ─── Actions Row (Download, Share, WhatsApp) ────────────────────────────────
  Widget _buildActionRow(AmritVachan post) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.file_download_outlined,
            label: context.tr('save'),
            color: primaryPlum,
            bgColor: const Color(0xFFFFF0F5),
            onTap: () => _downloadPostSafe(post),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            icon: Icons.share_rounded,
            label: context.tr('share'),
            color: const Color(0xFF1565C0),
            bgColor: const Color(0xFFE3F2FD),
            onTap: () => _sharePostSafe(post),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            icon: Icons.chat_rounded,
            label: context.tr('whatsApp'),
            color: const Color(0xFF2E7D32),
            bgColor: const Color(0xFFE8F5E9),
            onTap: () => _shareOnWhatsAppSafe(post),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 15, color: color),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Safe Downloader & Exporters ────────────────────────────────────────────
  Future<void> _downloadPostSafe(AmritVachan post) async {
    try {
      final hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        final granted = await Gal.requestAccess(toAlbum: true);
        if (!granted) {
          _showMessage('गैलरी परमिशन नहीं मिली।');
          return;
        }
      }

      final file = await _downloadImageToCacheFile(post);
      await Gal.putImage(file.path, album: 'Guruji');
      _showMessage('अमृत वचन गैलरी में सुरक्षित हो गया।');
    } catch (e) {
      _showMessage('डाउनलोड नहीं हो पाया।');
    }
  }

  Future<void> _sharePostSafe(AmritVachan post) async {
    try {
      final file = await _downloadImageToCacheFile(post);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: post.caption,
        subject: 'Amrit Vachan',
      );
    } catch (e) {
      _showMessage('पोस्ट शेयर नहीं हो पाई।');
    }
  }

  Future<void> _shareOnWhatsAppSafe(AmritVachan post) async {
    try {
      final file = await _downloadImageToCacheFile(post);
      if (Platform.isAndroid) {
        await _whatsAppChannel.invokeMethod('shareImageToWhatsApp', {
          'filePath': file.path,
          'text': post.caption,
        });
        return;
      }

      await Share.shareXFiles([XFile(file.path)], text: post.caption);
    } on PlatformException catch (e) {
      _showMessage(e.message ?? 'WhatsApp पर शेयर नहीं हो पाया।');
    } catch (e) {
      _showMessage('WhatsApp पर शेयर नहीं हो पाया।');
    }
  }

  Future<File> _downloadImageToCacheFile(AmritVachan post) async {
    final response = await http.get(Uri.parse(post.imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Unable to download image');
    }

    final tempDir = await getTemporaryDirectory();
    final file = File(
      '${tempDir.path}${Platform.pathSeparator}${post.id}${_fileExtensionFromUrl(post.imageUrl)}',
    );
    await file.writeAsBytes(response.bodyBytes, flush: true);
    return file;
  }

  String _fileExtensionFromUrl(String url) {
    final uri = Uri.tryParse(url);
    final segments = uri?.pathSegments ?? const <String>[];
    if (segments.isEmpty) {
      return '.jpg';
    }

    final lastSegment = segments.last;
    final dotIndex = lastSegment.lastIndexOf('.');
    if (dotIndex == -1) {
      return '.jpg';
    }

    return lastSegment.substring(dotIndex);
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryPlum,
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    return '$day-$month-$year';
  }
}
