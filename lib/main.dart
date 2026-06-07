import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/hive_registrar.g.dart';
import 'package:goodthings/models/goodthing_model.dart';
import 'package:goodthings/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await clearDB();
  await Hive.initFlutter();

  Hive.registerAdapters();
  await Hive.openBox<GoodthingModel>("LocalGoodThings");

  runApp(ProviderScope(child: const GoodThings()));
}

class GoodThings extends StatelessWidget {
  const GoodThings({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {'homeScreen': (context) => const HomeScreen()},
      initialRoute: 'homeScreen',
      theme: ThemeData(
        buttonTheme: ButtonThemeData(splashColor: Color(0xFFDAD4DE)),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFFC9C3CD),
          selectionHandleColor: Color(0xFFC9C3CD),
          selectionColor: Color(0xFFC9C3CD),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(fontFamily: "Junge", fontSize: 60),
          titleMedium: TextStyle(fontFamily: "Judson", fontSize: 20),
          bodySmall: TextStyle(fontFamily: "Judson", fontSize: 16),
          titleLarge: TextStyle(fontFamily: "Judson", fontSize: 25),
          titleSmall: TextStyle(fontFamily: "Judson", fontSize: 18),
        ),
      ),
    );
  }
}
