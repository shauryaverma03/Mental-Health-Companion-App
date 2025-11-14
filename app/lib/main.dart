import 'package:flutter/material.dart';
import 'package:genai/pages/hero_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(
    MaterialApp(
      title: 'GenAI',
      // Keep your original font; make scaffold background transparent so the
      // global gradient (below) shows through.
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,

      // Wrap every route with a full-screen gradient so you don't need to edit
      // each page. This is the minimal change — all other code left intact.
      builder: (BuildContext context, Widget? child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF9ED8F6), // top — soft sky blue
                Color(0xFFE8F8FC), // mid — very light sky tint
                Colors.white,      // bottom — white
              ],
              stops: [0.0, 0.6, 1.0],
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },

      home: HeroPage(),
    ),
  );
}