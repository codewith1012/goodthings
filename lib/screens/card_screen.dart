import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/models/goodthing_model.dart';
import 'package:goodthings/providers/cardlist_provider.dart';
import 'package:intl/intl.dart';

class CardScreen extends ConsumerStatefulWidget {
  final GoodthingModel cardData;

  const CardScreen({super.key, required this.cardData});

  @override
  ConsumerState<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends ConsumerState<CardScreen> {
  late GoodthingModel cardData;
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cardData = widget.cardData;
    debugPrint(cardData.serialNo);
    _contentController.text = cardData.content;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        cardData.title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: [
        IconButton(
          onPressed: () async {
            final String newTitle = (await showDialog<String>(
              context: context,
              builder: (context) =>
                  TitleChangeAlertBox(currentTitle: cardData.title),
            ))!;

            setState(() {
              cardData = GoodthingModel(
                title: newTitle,
                dateTime: cardData.dateTime,
                content: cardData.content,
                serialNo: cardData.serialNo,
              );
            });
          },
          icon: Icon(Icons.edit),
        ),
      ],
    );
  }

  Column _buildPage() {
    return Column(
      children: [
        Container(color: Color(0xFFC9C3CD), height: 100),

        // The Texts of the card
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // The date info
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat(' d-MMM-yy').format(cardData.dateTime),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      DateFormat('H:mm  ').format(cardData.dateTime),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),

              // The content Field
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 100),
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    hint: Text(
                      "Elaborate your good thing..",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    // Removing the Borders
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Try clubing the following two funcs into a single FAB class.
  void _contentValidation()
  {
    if(_contentController.text.isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xFFDAD4DE),
        content: Text("Don't Leave Your GoodThing Empty :(", style: Theme.of(context).textTheme.bodySmall,)));
    }
    else
    {
      cardData = GoodthingModel(title: cardData.title, dateTime: cardData.dateTime, content: _contentController.text, serialNo: cardData.serialNo);

      ref.read(cardListProvider.notifier).addGoodThing(cardData);
      Navigator.pop(context);
    }
  }

  FloatingActionButton _buildFAB()
  {
    return FloatingActionButton(
          onPressed: () {
            _contentValidation();
          },
          backgroundColor: Color(0xFFECE6F0),
          foregroundColor: Colors.black,
          splashColor: Color(0xFFDAD4DE),
          child: Icon(Icons.done),
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // Done Button
        floatingActionButton: _buildFAB(),
        appBar: _buildAppBar(),
        body: SingleChildScrollView(child: _buildPage()),
      ),
    );
  }
}

// Title Editor
class TitleChangeAlertBox extends StatefulWidget {
  final String currentTitle;

  const TitleChangeAlertBox({super.key, required this.currentTitle});

  @override
  State<TitleChangeAlertBox> createState() => _TitleChangeAlertBoxState();
}

class _TitleChangeAlertBoxState extends State<TitleChangeAlertBox> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.currentTitle.trim();
  }

  void _titleValidationAndSubmission(String title) {
    if (title.isEmpty) {
      Navigator.pop(context, widget.currentTitle);
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
      Navigator.pop(context, _titleController.text);
      _titleController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFFECE6F0),
      elevation: 10,
      shadowColor: Colors.black,

      // Title
      title: Text(
        "What's your new title?",
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
                "Once Again, Be Brief though :D",
                style: Theme.of(context).textTheme.bodySmall,
              ),

              // Removing the Borders
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),

            onSubmitted: (value) => _titleValidationAndSubmission(value),
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
    );
  }
}
