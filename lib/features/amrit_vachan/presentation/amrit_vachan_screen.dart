import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gal/gal.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/app.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<AmritVachanBloc>().add(const FetchAmritVachanEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: const Text(
          'अमृत वचन',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded),
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
      body: BlocListener<AmritVachanBloc, AmritVachanState>(
        listener: (context, state) {
          if (state is AmritVachanFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<AmritVachanBloc, AmritVachanState>(
          builder: (context, state) {
            if (state is AmritVachanLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AmritVachanLoadSuccess) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<AmritVachanBloc>().add(
                    const FetchAmritVachanEvent(),
                  );
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    Center(
                      child: Text(
                        'कुल रिकॉर्ड : ${state.allPosts.length}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (state.todayPosts.isNotEmpty)
                      _buildTodayCard(state.todayPosts.first),
                    if (state.todayPosts.isNotEmpty) const SizedBox(height: 20),
                    Text(
                      'सभी अमृत वचन',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...state.allPosts.map(_buildListCard),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildTodayCard(AmritVachan post) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFE9BF),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'आज का अमृत वचन',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryDark,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            post.caption,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatDate(post.scheduledDate),
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textPrimary.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: CachedNetworkImage(
              imageUrl: post.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (_, __) => Container(
                height: 280,
                color: Colors.white,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
              errorWidget: (_, __, ___) => Container(
                height: 280,
                color: Colors.white,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image_outlined, size: 42),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildActionRow(post),
        ],
      ),
    );
  }

  Widget _buildListCard(AmritVachan post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.caption,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _formatDate(post.scheduledDate),
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textPrimary.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: post.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (_, __) => Container(
                height: 220,
                color: const Color(0xFFF6F4F9),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
              errorWidget: (_, __, ___) => Container(
                height: 220,
                color: const Color(0xFFF6F4F9),
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image_outlined, size: 36),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _buildActionRow(post),
        ],
      ),
    );
  }

  Widget _buildActionRow(AmritVachan post) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.download_rounded,
            label: 'Download',
            onTap: () => _downloadPostSafe(post),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionButton(
            icon: Icons.share_outlined,
            label: 'Share',
            onTap: () => _sharePostSafe(post),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionButton(
            icon: Icons.chat_rounded,
            label: 'WhatsApp',
            onTap: () => _shareOnWhatsAppSafe(post),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        overflow: TextOverflow.ellipsis,
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.primaryDark,
        side: BorderSide(color: AppTheme.primaryDark.withOpacity(0.24)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

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
      _showMessage('पोस्ट डाउनलोड हो गई।');
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

  Future<void> _downloadPost(AmritVachan post) async {
    try {
      final hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        final granted = await Gal.requestAccess(toAlbum: true);
        if (!granted) {
          _showMessage('गैलरी परमिशन नहीं मिली।');
          return;
        }
      }

      final file = await _downloadImageToTemp(post);
      await Gal.putImage(file.path, album: 'Guruji');
      _showMessage('पोस्ट डाउनलोड हो गई।');
    } catch (e) {
      _showMessage('डाउनलोड नहीं हो पाया।');
    }
  }

  Future<void> _sharePost(AmritVachan post) async {
    try {
      final file = await _downloadImageToTemp(post);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: post.caption,
        subject: 'Amrit Vachan',
      );
    } catch (e) {
      _showMessage('पोस्ट शेयर नहीं हो पाई।');
    }
  }

  Future<void> _shareOnWhatsApp(AmritVachan post) async {
    try {
      final file = await _downloadImageToTemp(post);
      if (Platform.isAndroid) {
        await _whatsAppChannel.invokeMethod('shareImageToWhatsApp', {
          'filePath': file.path,
          'text': post.caption,
        });
        return;
      }

      await Share.shareXFiles([XFile(file.path)], text: post.caption);
    } catch (e) {
      _showMessage('WhatsApp पर शेयर नहीं हो पाया।');
    }
  }

  Future<File> _downloadImageToTemp(AmritVachan post) async {
    final response = await http.get(Uri.parse(post.imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Unable to download image');
    }

    final file = File(
      '${Directory.systemTemp.path}\\${post.id}${_fileExtensionFromUrl(post.imageUrl)}',
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
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }

    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    return '$day-$month-$year';
  }
}
