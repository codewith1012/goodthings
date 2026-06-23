import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showToast({required BuildContext context, required String message}) {
  toastification.showCustom(
    context: context,
    alignment: Alignment.bottomCenter,
    autoCloseDuration: const Duration(seconds: 3),
    builder: (context, holder) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.only(bottom: 50.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/logo/app_logo_foreground.png', // Swap with your actual app icon path
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 3),
              Text(message, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      );
    },
  );
}
