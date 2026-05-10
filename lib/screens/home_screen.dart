import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/models/goodthing_model.dart';
import 'package:goodthings/providers/cardlist_provider.dart';
import 'package:goodthings/screens/card_screen.dart';
import 'package:goodthings/widgets/goodthing_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

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

    return Scaffold(
      // New card adding button (FAB)
      floatingActionButton: AddcardButton(),

      body: SafeArea(
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
      ),
    );
  }
}

class AddcardButton extends StatefulWidget {
  const AddcardButton({super.key});

  @override
  State<AddcardButton> createState() => _AddcardButtonState();
}

class _AddcardButtonState extends State<AddcardButton> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _titleValidationAndSubmission(String title) {
    if (title.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFFDAD4DE),
          content: Text(
            "Title Cannot be Empty!",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      );
      return;
    } else {
      GoodthingModel cardData = GoodthingModel(
        title: title.trim(),
        dateTime: DateTime.now(),
        content: "",
        serialNo: DateTime.now().toString(),
      );

      Navigator.pop(context);
      _titleController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CardScreen(cardData: cardData)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => SizedBox(
            child: AlertDialog(
              backgroundColor: Color(0xFFECE6F0),
              elevation: 10,
              shadowColor: Colors.black,

              // Title
              title: Text(
                "Share Your Good Thing...",
                style: TextStyle(
                  fontFamily: "Junge",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Contents
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Divider(height: 0, thickness: 1, color: Colors.black),
                  SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    maxLines: null,
                    cursorColor: Colors.black,
                    autofocus: true,
                    style: Theme.of(context).textTheme.titleMedium,
                    decoration: InputDecoration(
                      hint: Text(
                        "Be Brief for the title though ;D",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      // Removing the Borders
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),

                    onSubmitted: (value) =>
                        _titleValidationAndSubmission(value),
                  ),

                  TextButton(
                    style: ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(Color(0xFFDAD4DE)),
                    ),
                    onPressed: () =>
                        _titleValidationAndSubmission(_titleController.text),
                    child: Text(
                      "Done!!",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },

      backgroundColor: Color(0xFFECE6F0),
      foregroundColor: Colors.black,
      splashColor: Color(0xFFDAD4DE),
      label: Text(
        "New Good Thing :D",
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
