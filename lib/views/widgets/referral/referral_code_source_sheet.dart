import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/views/screens/qr_scan_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

/// Shows a bottom sheet with two options: pick QR from gallery or scan with camera.
/// Requests camera/photo permissions when needed. Calls [onCode] with the decoded string.
void showReferralCodeSourceSheet(
  BuildContext context, {
  required void Function(String code) onCode,
  void Function(String message)? onError,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: isDark ? AppColors.burgundy.withValues(alpha: 0.95) : Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'كود الدعوة',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isDark ? AppColors.offWhite : AppColors.black,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'اختر طريقة إدخال الكود',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.taupe : AppColors.burgundy,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                  child: Icon(Icons.photo_library_rounded, color: theme.colorScheme.primary, size: 26.r),
                ),
                title: Text(
                  'من المعرض',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? AppColors.offWhite : AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'اختر صورة تحتوي على كود QR',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.taupe : AppColors.burgundy,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await _pickFromGallery(context, onCode: onCode, onError: onError);
                },
              ),
              SizedBox(height: 8.h),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                  child: Icon(Icons.qr_code_scanner_rounded, color: theme.colorScheme.primary, size: 26.r),
                ),
                title: Text(
                  'مسح بالكاميرا',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? AppColors.offWhite : AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'امسح كود QR مباشرة',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.taupe : AppColors.burgundy,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await _scanWithCamera(context, onCode: onCode, onError: onError);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _requestPhotoPermission(BuildContext context, {required void Function(String)? onError}) async {
  final status = await Permission.photos.status;
  if (status.isGranted) return;
  if (status.isPermanentlyDenied) {
    onError?.call('السماح بالوصول إلى الصور مطلوب. يرجى تفعيله من الإعدادات.');
    return;
  }
  final result = await Permission.photos.request();
  if (!result.isGranted && !context.mounted) return;
  if (!result.isGranted) {
    onError?.call('السماح بالوصول إلى المعرض مطلوب لاختيار الصورة.');
  }
}

Future<void> _requestCameraPermission(BuildContext context, {required void Function(String)? onError}) async {
  final status = await Permission.camera.status;
  if (status.isGranted) return;
  if (status.isPermanentlyDenied) {
    onError?.call('السماح بالكاميرا مطلوب. يرجى تفعيله من الإعدادات.');
    return;
  }
  final result = await Permission.camera.request();
  if (!result.isGranted && !context.mounted) return;
  if (!result.isGranted) {
    onError?.call('السماح بالكاميرا مطلوب للمسح.');
  }
}

Future<void> _pickFromGallery(
  BuildContext context, {
  required void Function(String code) onCode,
  void Function(String message)? onError,
}) async {
  await _requestPhotoPermission(context, onError: onError);
  if (!context.mounted) return;
  final picker = ImagePicker();
  final xFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
  if (xFile == null || !context.mounted) return;
  final path = xFile.path;
  if (path.isEmpty) {
    onError?.call('تعذر فتح الصورة.');
    return;
  }
  try {
    final controller = MobileScannerController();
    final capture = await controller.analyzeImage(path);
    await controller.dispose();
    if (!context.mounted) return;
    final barcodes = capture?.barcodes ?? [];
    final barcode = barcodes.isNotEmpty ? barcodes.first : null;
    final value = barcode?.rawValue ?? barcode?.displayValue;
    if (value != null && value.trim().isNotEmpty) {
      onCode(value.trim());
    } else {
      onError?.call('لم يتم العثور على كود QR في الصورة.');
    }
  } catch (_) {
    if (context.mounted) {
      onError?.call('لم يتم العثور على كود QR في الصورة.');
    }
  }
}

Future<void> _scanWithCamera(
  BuildContext context, {
  required void Function(String code) onCode,
  void Function(String message)? onError,
}) async {
  await _requestCameraPermission(context, onError: onError);
  if (!context.mounted) return;
  final value = await Navigator.push<String>(
    context,
    MaterialPageRoute(builder: (_) => const QrScanScreen()),
  );
  if (value != null && context.mounted) {
    onCode(value);
  }
}
