import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/providers/authstate_provider.dart';

// The Value is updated/overrided in the AuthGateClass.
final userProvider = Provider<User?>((ref) {
  final asyncState = ref.watch(authStateProvider);
  return asyncState.asData?.value;
});
