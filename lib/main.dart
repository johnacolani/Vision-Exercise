import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'exercise_screen.dart';
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Allow rotation on splash so user can rotate to landscape to continue.
  // Landscape lock is applied when entering the Brock String exercise.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const VisionExerciseApp());
}

class VisionExerciseApp extends StatelessWidget {
  const VisionExerciseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vision Exercise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Neutral, low-glare palette for extended vision therapy use.
        // High contrast supports users with varying visual acuity.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
          primary: const Color(0xFF2E7D32),
          surface: const Color(0xFFF5F5F0),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF424242),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: const Color(0xFF212121),
              displayColor: const Color(0xFF212121),
            ),
      ),
      home: kIsWeb ? const BrockStringExerciseScreen() : const SplashScreen(),
    );
  }
}
