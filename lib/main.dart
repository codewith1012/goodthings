import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ProviderScope(child: const GoodThings()));
}

class GoodThings extends StatelessWidget {
  const GoodThings({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'homeScreen': (context) => const HomeScreen(),
      },
      initialRoute: 'homeScreen',
      theme: ThemeData(
        buttonTheme: ButtonThemeData(
          splashColor: Color(0xFFDAD4DE),
        ),
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
