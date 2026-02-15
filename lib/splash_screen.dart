import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'exercise_screen.dart';

/// Splash: first one bounce cycle, then rotate screen; then home when user rotates.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  /// After one full bounce cycle we show the "rotate your screen" screen.
  bool _showRotateScreen = false;
  bool _controllerDisposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed && !_showRotateScreen) {
        if (mounted) setState(() => _showRotateScreen = true);
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (!_controllerDisposed) {
      _controller.dispose();
      _controllerDisposed = true;
    }
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (_showRotateScreen &&
        _isLandscape(WidgetsBinding.instance.platformDispatcher.views.first)) {
      _goToExercise();
    }
  }

  bool _isLandscape(dynamic view) {
    final size = view.physicalSize / view.devicePixelRatio;
    return size.width > size.height;
  }

  void _goToExercise() {
    if (!_controllerDisposed) {
      _controller.stop();
    }
    if (!mounted) return;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => const BrockStringExerciseScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showRotateScreen) {
      return _buildRotateScreen();
    }
    return _buildBounceScreen(context);
  }

  Widget _buildBounceScreen(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const ballRadius = 40.0;
    final bounceHeight = size.height * 0.25;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: bounceHeight + ballRadius * 2,
            child: AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                final yOffset = bounceHeight * _bounceAnimation.value;
                return CustomPaint(
                  size: Size(ballRadius * 2, bounceHeight + ballRadius * 2),
                  painter: _BouncingBallPainter(
                    ballRadius: ballRadius,
                    yOffset: yOffset,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRotateScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: GestureDetector(
          onTap: _goToExercise,
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please rotate your device to landscape\nfor the best experience',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF212121),
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Rotate to landscape to begin • Tap to continue',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF757575),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints the bouncing ball at the given vertical offset.
class _BouncingBallPainter extends CustomPainter {
  _BouncingBallPainter({required this.ballRadius, required this.yOffset});

  final double ballRadius;
  final double yOffset;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, ballRadius + yOffset);

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center, ballRadius, shadowPaint);

    // Ball
    final ballPaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, ballRadius, ballPaint);
  }

  @override
  bool shouldRepaint(covariant _BouncingBallPainter oldDelegate) {
    return oldDelegate.yOffset != yOffset;
  }
}
