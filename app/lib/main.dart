import 'package:flutter/material.dart';
import 'package:genai/pages/hero_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Optional: catch Flutter framework errors and print them
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  var firebaseInitialized = false;
  try {
    // FIX IS HERE: Check if Firebase is already initialized to prevent "Duplicate App" errors
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    // If we get past the check (or if we just initialized), mark as true
    firebaseInitialized = true;
  } catch (e, stack) {
    // Specifically ignore the duplicate app error if it somehow slips through
    if (e.toString().contains('duplicate-app')) {
      debugPrint('Firebase already initialized (Hot Restart detected). Continuing...');
      firebaseInitialized = true;
    } else {
      debugPrint('Firebase initialization error: $e');
      debugPrintStack(stackTrace: stack);
      firebaseInitialized = false;
    }
  }

  runApp(MyApp(firebaseInitialized: firebaseInitialized));
}

class MyApp extends StatelessWidget {
  final bool firebaseInitialized;

  const MyApp({Key? key, required this.firebaseInitialized}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GenAI',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,

      // Wrap every route with a full-screen gradient
      builder: (BuildContext context, Widget? child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF9ED8F6), // top — soft sky blue
                Color(0xFFE8F8FC), // mid — very light sky tint
                Colors.white, // bottom — white
              ],
              stops: [0.0, 0.6, 1.0],
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },

      // If Firebase failed to initialize show a clear friendly screen, otherwise
      // continue to the existing HeroPage.
      home: firebaseInitialized
          ? HeroPage() // FIX: Removed 'const'
          : const _FirebaseErrorScreen(), // FIX: Removed 'const'
    );
  }
}

class _FirebaseErrorScreen extends StatelessWidget {
  // FIX: Removed 'const' from constructor
  const _FirebaseErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                // FIX: Removed 'const'
                Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                SizedBox(height: 12),
                Text(
                  'Unable to initialize Firebase',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Check your GoogleService-Info.plist and firebase_options.dart configuration, then restart the app.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}