// ignore_for_file: unused_import

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/firebase_options.dart';
import 'package:goodthings/hive_registrar.g.dart';
import 'package:goodthings/models/goodthing_model.dart';
import 'package:goodthings/providers/sharedprefs_provider.dart';
import 'package:goodthings/screens/authgate.dart';
import 'package:goodthings/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:goodthings/screens/sign_up_screen.dart';
import 'package:goodthings/services/local_prefs_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Only for Debugging purpose, It is like a nuke bomb to the app; As it wipes out every data.
Future<void> clearDB() async {
  final Directory appDocDir = await getApplicationDocumentsDirectory();

  if (await appDocDir.exists()) {
    // recursive: true deletes the folder and everything inside it instantly
    await appDocDir.delete(recursive: true);

    // Re-create the empty folder right after so the app doesn't crash on next upload
    await appDocDir.create(recursive: true);
  }
}

Future<void> initializeHiveWithBoxes() async {
  // await clearDB();
  await Hive.initFlutter();
  Hive.registerAdapters();
  await Hive.openBox<GoodthingModel>("LocalGoodThings");
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  initializeHiveWithBoxes();

  SharedPreferences sharedPreferencesInstance =
      await SharedPreferences.getInstance();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GoogleSignIn.instance.initialize();

  // Keep the splash screen visible for 2 seconds
  await Future.delayed(const Duration(milliseconds: 900));
  FlutterNativeSplash.remove();

  runApp(
    ProviderScope(
      overrides: [
        localPrefsProvider.overrideWithValue(
          LocalprefsService(sharedPreferencesInstance),
        ),
      ],
      child: const GoodThings(),
    ),
  );
}

class GoodThings extends ConsumerWidget {
  const GoodThings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: "Good Things",
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const Authgate(),
        'homeScreen': (context) => const HomeScreen(),
        'signUpScreen': (context) => const SignUpScreen(),
      },
      initialRoute: '/',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style:
              ElevatedButton.styleFrom(
                splashFactory: InkRipple.splashFactory,
              ).copyWith(
                overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return const Color(0xFFDAD4DE);
                  }
                  return null;
                }),
              ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFFC9C3CD),
          selectionHandleColor: Color(0xFFC9C3CD),
          selectionColor: Color(0xFFC9C3CD),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(fontFamily: "Junge", fontSize: 60),
          displayMedium: TextStyle(fontFamily: "Junge", fontSize: 33),
          titleMedium: TextStyle(fontFamily: "Judson", fontSize: 20),
          bodySmall: TextStyle(fontFamily: "Judson", fontSize: 16),
          titleLarge: TextStyle(fontFamily: "Judson", fontSize: 25),
          titleSmall: TextStyle(fontFamily: "Judson", fontSize: 18),
        ),
      ),
    );
  }
}
