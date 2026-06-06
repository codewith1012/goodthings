import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityGoodthings extends ConsumerWidget {
  const CommunityGoodthings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Center(
        child: Text(
          "The Community Update is Ongoing!!",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
