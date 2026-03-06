import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Full-screen QR/barcode scanner. Pops with the scanned string on success.
class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  bool _hasScanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final barcode = barcodes.first;
    final value = barcode.rawValue ?? barcode.displayValue;
    if (value == null || value.trim().isEmpty) return;
    _hasScanned = true;
    if (mounted) Navigator.of(context).pop(value.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'مسح كود الدعوة',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: Colors.white, size: 26.r),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          Center(
            child: Container(
              width: 260.w,
              height: 260.w,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.goldLight.withValues(alpha: 0.8),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: CustomPaint(
                painter: _CornerAccentPainter(
                  color: AppColors.goldLight,
                  cornerLength: 32,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 48.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'وجّه الكاميرا نحو كود الدعوة',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerAccentPainter extends CustomPainter {
  _CornerAccentPainter({required this.color, required this.cornerLength});

  final Color color;
  final double cornerLength;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;
    final l = cornerLength;

    // Top-left
    canvas.drawPath(
      Path()
        ..moveTo(0, l)
        ..lineTo(0, 0)
        ..lineTo(l, 0),
      paint,
    );
    // Top-right
    canvas.drawPath(
      Path()
        ..moveTo(w - l, 0)
        ..lineTo(w, 0)
        ..lineTo(w, l),
      paint,
    );
    // Bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(w, h - l)
        ..lineTo(w, h)
        ..lineTo(w - l, h),
      paint,
    );
    // Bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(l, h)
        ..lineTo(0, h)
        ..lineTo(0, h - l),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
