import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/models/goodthing_model.dart';
import 'package:goodthings/providers/cardlist_provider.dart';
import 'package:goodthings/widgets/goodthing_card.dart';

class LocalGoodthings extends ConsumerWidget {
  const LocalGoodthings({super.key});

  Center _buildTitle(BuildContext context) {
    return Center(
      child: Text(
        "Good Things",
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }

  Expanded _buildGoodThings(
    BuildContext context,
    List<GoodthingModel> goodThings,
  ) {
    return // Building the GoodThings
    Expanded(
      child: goodThings.isEmpty
          ? Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
              child: Text(
                "Waiting for your first Good thing!!",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            )
          : ListView.builder(
              itemCount: goodThings.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: GoodthingCard(cardData: goodThings[index]),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<GoodthingModel> goodThings = ref.watch(cardListProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildTitle(context),
            // The Horizontal Line
            Divider(height: 40, thickness: 1, color: Colors.black),
            _buildGoodThings(context, goodThings),
          ],
        ),
      ),
    );
  }
}
