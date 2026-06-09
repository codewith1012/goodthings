import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {

  final VoidCallback contentValidation;

  const SaveButton({
    super.key,
    required this.contentValidation
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        contentValidation();
      },
      backgroundColor: Color(0xFFECE6F0),
      foregroundColor: Colors.black,
      splashColor: Color(0xFFDAD4DE),
      child: Icon(Icons.done),
    );
  }
}
