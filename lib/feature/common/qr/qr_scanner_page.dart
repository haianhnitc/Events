import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage>
    with SingleTickerProviderStateMixin {
  String? _lastScan;
  bool _isProcessing = false;
  final MobileScannerController _controller = MobileScannerController();
  bool _showLoading = false;
  late final AnimationController _lineController;
  late final Animation<double> _lineAnimation;

  void _onDetect(Barcode barcode, MobileScannerArguments? args) {
    debugPrint('QrScannerPage: onDetect called');
    if (_isProcessing) return;
    final code = barcode.rawValue;
    debugPrint('QrScannerPage: detected rawValue="$code"');
    if (code == null || code.isEmpty) return;
    _isProcessing = true;
    if (!mounted) return;
    setState(() => _lastScan = code);
    // Pause the camera while processing and show loading
    try {
      _controller.stop();
    } catch (e) {
      debugPrint('QrScannerPage: controller.stop() error: $e');
    }
    setState(() => _showLoading = true);

    // Simulate processing (replace with real async work if needed)
    Future.delayed(const Duration(milliseconds: 1200)).then((_) {
      if (!mounted) return;
      Navigator.of(context).pop(code);
    });
  }

  @override
  void initState() {
    super.initState();
    debugPrint('QrScannerPage: initState, starting controller');
    // MobileScanner will start the camera when the widget is mounted.
    // Avoid calling _controller.start() here because it may already be
    // in the process of starting (causes "Called start() while already starting.").
    _lineController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat();
    _lineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _lineController, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('QrScannerPage: build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            tooltip: 'Bật/Tắt đèn',
            onPressed: () async {
              try {
                await _controller.toggleTorch();
              } catch (e) {
                debugPrint('QrScannerPage: toggleTorch error: $e');
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            allowDuplicates: false,
            onDetect: _onDetect,
          ),
          // Centered detection frame
          Center(
            child: SizedBox(
              width: 280,
              height: 280,
              child: Stack(
                children: [
                  // Border box
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white70, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  // Animated scan line
                  AnimatedBuilder(
                    animation: _lineAnimation,
                    builder: (context, child) {
                      final top = _lineAnimation.value * 280;
                      return Positioned(
                        top: top,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.greenAccent.withOpacity(0.0),
                              Colors.greenAccent.withOpacity(0.95),
                              Colors.greenAccent.withOpacity(0.0)
                            ]),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _lastScan == null
                      ? 'Hướng camera vào mã QR để quét'
                      : 'Kết quả: $_lastScan',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          // Loading overlay when processing
          if (_showLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black45,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 8),
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text('Đang xử lý...',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('QrScannerPage: dispose, stopping controller');
    _controller.dispose();
    _lineController.dispose();
    super.dispose();
  }
}
