import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/models/goodthing_model.dart';
import 'package:goodthings/providers/cardlist_provider.dart';
import 'package:goodthings/widgets/goodthing_card.dart';

class LocalGoodthings extends ConsumerWidget {
  const LocalGoodthings({super.key});

  Future<bool?> _actionOnGoodThing(
    BuildContext context,
    DismissDirection dir,
  ) async {
    // Delete Action
    if (dir == DismissDirection.endToStart) {
      return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Are you sure?",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                "Yes :(",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                "Nope!!",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
      );
    }
    // Send to Community Action
    // else if (dir == DismissDirection.startToEnd) {}

    return false;
  }

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
    WidgetRef ref,
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
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Dismissible(
                    key: Key(goodThings[index].serialNo),
                    // For now, only Left swipe is treated
                    direction: DismissDirection.endToStart,
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusGeometry.circular(10),
                        color: Color(0xFFC9C3CD),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 50),
                      child: const Icon(
                        Icons.delete_sweep_rounded,
                        color: Color.fromARGB(255, 0, 0, 0),
                        size: 50,
                      ),
                    ),
                    confirmDismiss: (direction) =>
                        _actionOnGoodThing(context, direction),
                    onDismissed: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        ref
                            .read(cardListProvider.notifier)
                            .removeGoodThing(goodThings[index]);
                      }
                    },
                    child: GoodthingCard(cardData: goodThings[index]),
                  ),
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
            _buildGoodThings(context, goodThings, ref),
          ],
        ),
      ),
    );
  }
}
