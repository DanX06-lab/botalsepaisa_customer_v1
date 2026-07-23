// scanner_screen.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/design_system.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _isProcessing = false;
  bool _showSuccess = false;
  late AnimationController _animationController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  Future<void> _handleScanSuccess(String code) async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
    });

    await controller.stop();

    setState(() {
      _showSuccess = true;
    });

    // Short success animation
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      context.push('/bottle-scanner', extra: {'shopId': code}).then((_) {
        setState(() {
          _isProcessing = false;
          _showSuccess = false;
        });
        controller.start();
      });
    }
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String code = barcodes.first.rawValue ?? 'Unknown';
      _handleScanSuccess(code);
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final BarcodeCapture? capture = await controller.analyzeImage(image.path);
      if (capture != null && capture.barcodes.isNotEmpty) {
        final String code = capture.barcodes.first.rawValue ?? 'Unknown';
        _handleScanSuccess(code);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No valid QR code found in the selected image. Please try again or use the camera.'),
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
    _animationController.dispose();
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
            Text('Step 1 of 2', style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text('Scan Collection Point QR', style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.photo_library, color: Colors.white),
            onPressed: _pickImageFromGallery,
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
            errorBuilder: (context, error) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: AppRadius.lgRadius,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error, color: AppColors.error, size: 48),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        'Camera Error:\n${error.errorDetails?.message ?? "Unknown"}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.error),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          CustomPaint(
            painter: ScannerOverlayPainter(),
            child: const SizedBox.expand(),
          ),
          Center(
            child: SizedBox(
              width: scanAreaSize,
              height: scanAreaSize,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Stack(
                    children: [
                      Positioned(
                        top: _animationController.value * (scanAreaSize - 4),
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
                  );
                },
              ),
            ),
          ),
          if (_showSuccess)
            Container(
              color: AppColors.success.withValues(alpha: 0.9),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 80).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                    SizedBox(height: AppSpacing.md),
                    Text('Collection Point Verified', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)).animate().fadeIn(delay: 200.ms),
                  ],
                ),
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
                  Icon(Icons.qr_code_2, color: AppColors.primary, size: 32),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Scan the QR code displayed at the collection point.',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 1.0, end: 0.0, duration: 500.ms, curve: Curves.easeOutQuad),
          )
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
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
        ..quadraticBezierTo(left + scanAreaSize, top, left + scanAreaSize, top + cornerLength),
      cornerPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(left + scanAreaSize, top + scanAreaSize - cornerLength)
        ..quadraticBezierTo(left + scanAreaSize, top + scanAreaSize, left + scanAreaSize - cornerLength, top + scanAreaSize),
      cornerPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(left + cornerLength, top + scanAreaSize)
        ..quadraticBezierTo(left, top + scanAreaSize, left, top + scanAreaSize - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
