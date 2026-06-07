import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/models/goodthing_model.dart';
import 'package:goodthings/providers/cardlist_provider.dart';

class SaveButton extends ConsumerStatefulWidget {
  final GoodthingModel cardData;
  final TextEditingController contentController;

  const SaveButton({
    super.key,
    required this.cardData,
    required this.contentController,
  });

  @override
  ConsumerState<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends ConsumerState<SaveButton> {
  late GoodthingModel cardData;

  @override
  void initState() {
    super.initState();
    cardData = widget.cardData;
  }

  void _contentValidation() {
    if (widget.contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFFDAD4DE),
          content: Text(
            "Don't Leave Your GoodThing Empty :(",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      );
    } else {
      cardData = GoodthingModel(
        title: cardData.title,
        dateTime: cardData.dateTime,
        content: widget.contentController.text,
        serialNo: cardData.serialNo,
        imagePath: cardData.imagePath,
      );

      ref.read(cardListProvider.notifier).addGoodThing(cardData);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
}
