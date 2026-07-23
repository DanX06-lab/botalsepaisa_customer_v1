import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/design_system.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BottleScannerScreen extends StatefulWidget {
  final String shopId;
  const BottleScannerScreen({super.key, required this.shopId});

  @override
  State<BottleScannerScreen> createState() => _BottleScannerScreenState();
}

class _BottleScannerScreenState extends State<BottleScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _isProcessing = false;
  late AnimationController _lineController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  Future<void> _handleBottleDetected(String barcode) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    await controller.stop();
    if (mounted) {
      context.push('/bottle-details', extra: {
        'shopId': widget.shopId,
        'barcode': barcode,
      }).then((_) {
        setState(() => _isProcessing = false);
        controller.start();
      });
    }
  }

  void _onDetect(BarcodeCapture capture) {
    final barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final code = barcodes.first.rawValue ?? 'Unknown';
      _handleBottleDetected(code);
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final BarcodeCapture? capture = await controller.analyzeImage(image.path);
      if (capture != null && capture.barcodes.isNotEmpty) {
        final code = capture.barcodes.first.rawValue ?? 'Unknown';
        _handleBottleDetected(code);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No barcode found in the selected image. Try scanning directly.'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _lineController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanAreaSize = MediaQuery.of(context).size.width * 0.75;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Column(
          children: [
            Text('Step 2 of 2',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text('Scan Bottle Barcode',
                style:
                    TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.photo_library, color: Colors.white),
            onPressed: _pickFromGallery,
          ),
          IconButton(
            icon: Icon(Icons.flash_on, color: Colors.white),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: Icon(Icons.cameraswitch, color: Colors.white),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) => Center(
              child: Text(
                'Camera error: ${error.errorDetails?.message ?? "Unknown"}',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ),
          CustomPaint(
            painter: _BottleScannerOverlayPainter(),
            child: const SizedBox.expand(),
          ),
          Center(
            child: SizedBox(
              width: scanAreaSize,
              height: scanAreaSize,
              child: AnimatedBuilder(
                animation: _lineController,
                builder: (context, _) => Stack(
                  children: [
                    Positioned(
                      top: _lineController.value * (scanAreaSize - 4),
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.8),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black.withValues(alpha: 0.6),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 96,
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.xlRadius,
                border: Border.all(color: AppColors.border, width: 0.5),
                boxShadow: AppShadows.soft,
              ),
              child: const Row(
                children: [
                  Icon(Icons.barcode_reader, color: AppColors.primary, size: 32),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Scan the barcode printed on the bottle.',
                      style: TextStyle(
                          color: AppColors.textPrimary, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ).animate().slideY(
                begin: 1.0,
                end: 0.0,
                duration: 500.ms,
                curve: Curves.easeOutQuad),
          ),
        ],
      ),
    );
  }
}

class _BottleScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    final scanAreaSize = size.width * 0.75;
    final left = (size.width - scanAreaSize) / 2;
    final top = (size.height - scanAreaSize) / 2;
    final rect = Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize);

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(32)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);

    final cornerPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    const cornerLength = 30.0;

    canvas.drawPath(
      Path()
        ..moveTo(left, top + cornerLength)
        ..quadraticBezierTo(left, top, left + cornerLength, top),
      cornerPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(left + scanAreaSize - cornerLength, top)
        ..quadraticBezierTo(
            left + scanAreaSize, top, left + scanAreaSize, top + cornerLength),
      cornerPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(left + scanAreaSize, top + scanAreaSize - cornerLength)
        ..quadraticBezierTo(left + scanAreaSize, top + scanAreaSize,
            left + scanAreaSize - cornerLength, top + scanAreaSize),
      cornerPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(left + cornerLength, top + scanAreaSize)
        ..quadraticBezierTo(
            left, top + scanAreaSize, left, top + scanAreaSize - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
