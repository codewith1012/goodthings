import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/screens/home_screen.dart';
import 'package:goodthings/screens/sign_up_screen.dart';
import 'package:goodthings/services/auth_service.dart';

class Authgate extends ConsumerWidget {
  const Authgate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final authService = AuthService();

    return authState.when(
      data: (user) {
        if (user == null) {
          return const SignUpScreen();
        } else {
          authService.signOut();
          return const HomeScreen();
        }
      },
      error: (err, stack) => Scaffold(
        body: Center(child: Text("Firebase Connection Failed: $err")),
      ),
      loading: () => const Scaffold(body: CircularProgressIndicator()),
    );
  }
}
