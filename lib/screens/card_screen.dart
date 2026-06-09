import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/models/goodthing_model.dart';
import 'package:goodthings/providers/cardlist_provider.dart';
import 'package:goodthings/widgets/cardScreen/img_container.dart';
import 'package:goodthings/widgets/cardScreen/save_button.dart';
import 'package:goodthings/widgets/cardScreen/titlechange_alertbox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CardScreen extends ConsumerStatefulWidget {
  final GoodthingModel cardData;

  const CardScreen({super.key, required this.cardData});

  @override
  ConsumerState<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends ConsumerState<CardScreen> {
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late GoodthingModel cardData;

  bool _isContentFocused = false;

  bool get _hasChanges {
    final initial = widget.cardData;
    return cardData.title != initial.title ||
        cardData.imagePath != initial.imagePath ||
        _contentController.text != initial.content;
  }

  @override
  void initState() {
    super.initState();
    cardData = widget.cardData;
    _contentController.text = cardData.content;
    _focusNode.addListener(
      () => setState(() {
        _isContentFocused = _focusNode.hasFocus;
      }),
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    _focusNode.dispose();
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
            final String? newTitle = await showDialog<String>(
              context: context,
              builder: (context) =>
                  TitleChangeAlertBox(currentTitle: cardData.title),
            );

            setState(() {
              cardData = GoodthingModel(
                title: newTitle ?? cardData.title,
                dateTime: cardData.dateTime,
                content: cardData.content,
                serialNo: cardData.serialNo,
                imagePath: cardData.imagePath,
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
        ImgContainer(
          imagePath: cardData.imagePath,
          onPickImage: _pickAndSaveImage,
          isContentFocused: _isContentFocused,
        ),

        // The Texts of the card
        Transform.translate(
          offset: const Offset(0, -20),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
            ),
            child: Padding(
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
                      focusNode: _focusNode,
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
          ),
        ),
      ],
    );
  }

  void _contentValidation() {
    if (_contentController.text.isEmpty) {
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
        content: _contentController.text,
        serialNo: cardData.serialNo,
        imagePath: cardData.imagePath,
      );

      ref.read(cardListProvider.notifier).addGoodThing(cardData);
      Navigator.pop(context);
    }
  }

  Future<bool?> _showWarningDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Do you want to Save the changes to the GoodThing?",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              "Yesss :D",
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

  Future<void> _pickAndSaveImage() async {
    // Using ImgPicker to pick an img from the gallery.
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImg = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImg == null) return;

    // Open the App Personal Dir to save the img there.
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    // Each cardData has only one img for it (at least for now), so using serialNo for the file name.
    final String fileExtension = path.extension(pickedImg.path);
    final String uniqueFileName =
        "${cardData.serialNo}_${DateTime.now().millisecondsSinceEpoch}$fileExtension";

    final String permanentPath = path.join(appDocDir.path, uniqueFileName);

    // Deleting the old file
    if (cardData.imagePath != null) {
      if (await File(cardData.imagePath!).exists()) {
        await File(cardData.imagePath!).delete();
      }
    }

    await File(pickedImg.path).copy(permanentPath);

    setState(() {
      cardData = GoodthingModel(
        title: cardData.title,
        dateTime: cardData.dateTime,
        content: cardData.content,
        serialNo: cardData.serialNo,
        imagePath: permanentPath,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final bool? shouldSave = await _showWarningDialog(context);

        if (context.mounted) {
          if (shouldSave == true) {
            _contentValidation();
          } else if (shouldSave == false) {
            Navigator.pop(context);
          }
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          // Done Button
          floatingActionButton: SaveButton(
            contentValidation: _contentValidation,
          ),
          appBar: _buildAppBar(),
          body: SingleChildScrollView(child: _buildPage()),
        ),
      ),
    );
  }
}
