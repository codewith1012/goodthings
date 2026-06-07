import 'package:flutter/material.dart';

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
