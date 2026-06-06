import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/models/goodthing_model.dart';
import 'package:goodthings/providers/pageIndex_provider.dart';
import 'package:goodthings/screens/card_screen.dart';
import 'package:goodthings/screens/community_goodthings.dart';
import 'package:goodthings/screens/local_goodthings.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  BottomAppBar _buildbottombar(WidgetRef ref) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 55),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => {ref.read(pageIndexProvider.notifier).setIndex(0)},
            icon: Icon(Icons.person),
            style: IconButton.styleFrom(shape: CircleBorder(), iconSize: 30),
          ),
          IconButton(
            onPressed: () => {ref.read(pageIndexProvider.notifier).setIndex(1)},
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
      bottomNavigationBar: _buildbottombar(ref),

      body: IndexedStack(
        index: pageindex,
        children: [LocalGoodthings(), CommunityGoodthings()],
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
      label: Icon(Icons.celebration_rounded),
    );
  }
}
