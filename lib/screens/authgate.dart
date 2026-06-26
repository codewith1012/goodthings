import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/providers/authstate_provider.dart';
import 'package:goodthings/providers/sharedprefs_provider.dart';
import 'package:goodthings/screens/home_screen.dart';
import 'package:goodthings/screens/sign_up_screen.dart';
import 'package:toastification/toastification.dart';

class Authgate extends ConsumerWidget {
  const Authgate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final localPrefs = ref.watch(localPrefsProvider);

    return ToastificationWrapper(
      child: authState.when(
        data: (user) {
          if (user != null && localPrefs.hasCompletedOnBoarding()) {
            return const HomeScreen();
          } else {
            return const SignUpScreen();
          }
        },
        error: (err, stack) => Scaffold(
          body: Center(child: Text("Firebase Connection Failed: $err")),
        ),
        loading: () => const Scaffold(body: CircularProgressIndicator()),
      ),
    );
  }
}
