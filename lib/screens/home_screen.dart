import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/providers/pageindex_provider.dart';
import 'package:goodthings/screens/community_goodthings.dart';
import 'package:goodthings/screens/local_goodthings.dart';
import 'package:goodthings/widgets/addcard_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  BottomAppBar _buildbottombar(BuildContext context, WidgetRef ref) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 55),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ref.read(pageIndexProvider.notifier).setIndex(0);
            },
            icon: Icon(Icons.person),
            style: IconButton.styleFrom(shape: CircleBorder(), iconSize: 30),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ref.read(pageIndexProvider.notifier).setIndex(1);
            },
            icon: Icon(Icons.groups),
            style: IconButton.styleFrom(shape: CircleBorder(), iconSize: 30),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int pageindex = ref.watch(pageIndexProvider);

    return Scaffold(
      // New card adding button (FAB)
      floatingActionButton: pageindex == 0 ? AddcardButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      // Bottom App Bar
      bottomNavigationBar: _buildbottombar(context, ref),

      body: IndexedStack(
        index: pageindex,
        children: [LocalGoodthings(), CommunityGoodthings()],
      ),
    );
  }
}
