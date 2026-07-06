import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';

/// The three outcomes of the source-selection sheet.
enum CoverSourceChoice { camera, gallery, remove }

/// Bottom sheet that offers Camera / Gallery (+ Remove when a photo exists).
/// Extracted so it can be widget-tested without the picker/cropper.
Future<CoverSourceChoice?> showCoverSourceSheet(
  BuildContext context, {
  required bool hasPhoto,
}) {
  return showModalBottomSheet<CoverSourceChoice>(
    context: context,
    backgroundColor: AppSurfaces.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
    ),
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppDimensions.sm),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.neutral200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.lg,
              AppDimensions.md,
              AppDimensions.lg,
              AppDimensions.xs,
            ),
            child: Row(
              children: [
                Text(
                  'Foto sampul',
                  style: AppTypography.titleMedium
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          _CoverSourceTile(
            icon: Icons.camera_alt_outlined,
            label: 'Ambil foto',
            onTap: () => Navigator.pop(ctx, CoverSourceChoice.camera),
          ),
          _CoverSourceTile(
            icon: Icons.photo_library_outlined,
            label: 'Pilih dari galeri',
            onTap: () => Navigator.pop(ctx, CoverSourceChoice.gallery),
          ),
          if (hasPhoto)
            _CoverSourceTile(
              icon: Icons.delete_outline,
              label: 'Hapus sampul',
              color: AppColors.error,
              onTap: () => Navigator.pop(ctx, CoverSourceChoice.remove),
            ),
          const SizedBox(height: AppDimensions.sm),
        ],
      ),
    ),
  );
}

class _CoverSourceTile extends StatelessWidget {
  const _CoverSourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? AppColors.textPrimary;
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textSecondary),
      title: Text(
        label,
        style: AppTypography.bodyLarge.copyWith(color: tileColor),
      ),
      onTap: onTap,
    );
  }
}

/// Full cover-photo flow. Returns true when the cover changed.
Future<bool> editSessionCover(
  BuildContext context,
  WidgetRef ref, {
  required String sessionId,
  required bool hasPhoto,
}) async {
  final choice = await showCoverSourceSheet(context, hasPhoto: hasPhoto);
  if (choice == null || !context.mounted) return false;

  if (choice == CoverSourceChoice.remove) {
    return _removeCover(context, ref, sessionId);
  }

  final source = choice == CoverSourceChoice.camera
      ? ImageSource.camera
      : ImageSource.gallery;

  final File? cropped = await _pickAndCrop(context, source);
  if (cropped == null || !context.mounted) return false;

  return _upload(context, ref, sessionId, cropped);
}

Future<File?> _pickAndCrop(BuildContext context, ImageSource source) async {
  try {
    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 85,
    );
    if (picked == null) return null;

    // The cropper's confirm screen IS the preview step (16:9 locked; the
    // server re-crops to 16:9 as a safety net).
    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Atur sampul',
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: AppColors.textOnPrimary,
          activeControlsWidgetColor: AppColors.primary,
          lockAspectRatio: true,
          hideBottomControls: true,
        ),
        IOSUiSettings(
          title: 'Atur sampul',
          aspectRatioLockEnabled: true,
          rotateButtonsHidden: true,
          resetButtonHidden: true,
        ),
      ],
    );
    return cropped == null ? null : File(cropped.path);
  } on PlatformException {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tidak bisa mengakses kamera/galeri. Beri izin di pengaturan.',
          ),
        ),
      );
    }
    return null;
  }
}

Future<bool> _upload(
  BuildContext context,
  WidgetRef ref,
  String sessionId,
  File file,
) async {
  _showBlockingProgress(context);
  try {
    await ref
        .read(organizerRepositoryProvider)
        .uploadSessionCoverPhoto(sessionId, file);
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    _invalidate(ref, sessionId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sampul diperbarui')),
      );
    }
    return true;
  } catch (_) {
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Gagal mengunggah sampul'),
          action: SnackBarAction(
            label: 'Coba lagi',
            onPressed: () => _upload(context, ref, sessionId, file),
          ),
        ),
      );
    }
    return false;
  }
}

Future<bool> _removeCover(
  BuildContext context,
  WidgetRef ref,
  String sessionId,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Hapus sampul?'),
      content: const Text('Sesi akan memakai gambar bawaan klub.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text(
            'Hapus',
            style: TextStyle(color: AppColors.error),
          ),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return false;

  _showBlockingProgress(context);
  try {
    await ref
        .read(organizerRepositoryProvider)
        .deleteSessionCoverPhoto(sessionId);
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    _invalidate(ref, sessionId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sampul dihapus')),
      );
    }
    return true;
  } catch (_) {
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus sampul')),
      );
    }
    return false;
  }
}

void _showBlockingProgress(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    ),
  );
}

void _invalidate(WidgetRef ref, String sessionId) {
  ref.invalidate(organizerSessionDetailProvider(sessionId));
  ref.invalidate(organizerSessionsProvider);
}
