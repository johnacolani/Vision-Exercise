import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'brock_string_painter.dart';

/// Screen for the Brock String vision therapy exercise.
///
/// Designed for strabismus users. Displays a horizontal string with a bead
/// moving left and right for convergence practice.
class BrockStringExerciseScreen extends StatefulWidget {
  const BrockStringExerciseScreen({super.key});

  @override
  State<BrockStringExerciseScreen> createState() =>
      _BrockStringExerciseScreenState();
}

class _BrockStringExerciseScreenState extends State<BrockStringExerciseScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  static const int _baseDurationSeconds = 5;
  int _speedMultiplier = 1;
  bool _isRunning = true;
  MovementMode _mode = MovementMode.horizontal;

  @override
  void initState() {
    super.initState();

    final durationSeconds =
        (_baseDurationSeconds / _speedMultiplier).round().clamp(1, 10);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: durationSeconds),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _animation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    setState(() {
      if (_isRunning) {
        _controller.stop();
      } else {
        _controller.repeat(reverse: true);
      }
      _isRunning = !_isRunning;
    });
  }

  void _setSpeedMultiplier(int multiplier) {
    if (_speedMultiplier == multiplier) return;
    setState(() {
      _speedMultiplier = multiplier;
    });
    _updateSpeed();
  }

  void _setMode(MovementMode mode) {
    if (_mode == mode) return;
    setState(() => _mode = mode);
  }

  void _updateSpeed() {
    final durationSeconds =
        (_baseDurationSeconds / _speedMultiplier).round().clamp(1, 10);
    _controller.duration = Duration(seconds: durationSeconds);
    _controller.reset();
    if (_isRunning) {
      _controller.repeat(reverse: true);
    }
    setState(() {});
  }

  Widget _modeChip(String label, MovementMode mode) {
    final isSelected = _mode == mode;
    return Material(
      color: isSelected
          ? const Color(0xFF1B5E20)
          : const Color(0xFF2E7D32),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => _setMode(mode),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _speedChip(String label, int multiplier) {
    final isSelected = _speedMultiplier == multiplier;
    return Material(
      color: isSelected
          ? const Color(0xFF1B5E20)
          : const Color(0xFF2E7D32),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => _setSpeedMultiplier(multiplier),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final requireLandscape = !kIsWeb;

    if (requireLandscape && !isLandscape) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Brock String Exercise'),
          centerTitle: true,
        ),
        body: _buildRotateToLandscapeMessage(context),
      );
    }

    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Brock String Exercise'),
        centerTitle: true,
      ),
      body: SafeArea(
        left: false,
        right: false,
        child: Padding(
          padding: EdgeInsets.only(
            top: padding.top + 8,
            bottom: padding.bottom + 100,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Focus on the moving bead. Keep both eyes aligned.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF212121),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: CustomPaint(
                  painter: BrockStringPainter(
                    beadPosition: _animation.value,
                    mode: _mode,
                  ),
                  child: Container(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            onPressed: _toggleAnimation,
            icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
            label: Text(_isRunning ? 'Pause' : 'Start'),
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: [
              _speedChip('1×', 1),
              _speedChip('2×', 2),
              _speedChip('3×', 3),
              _speedChip('4×', 4),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              _modeChip('Horizontal', MovementMode.horizontal),
              _modeChip('↘ Diagonal', MovementMode.diagonalTLBR),
              _modeChip('↙ Reverse', MovementMode.diagonalTRBL),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildRotateToLandscapeMessage(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.screen_rotation,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Please rotate your device to landscape\nto continue the exercise',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF212121),
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
