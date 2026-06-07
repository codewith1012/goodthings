import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:goodthings/models/goodthing_model.dart';
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
  late GoodthingModel cardData;

  @override
  void initState() {
    super.initState();
    cardData = widget.cardData;
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
        Container(
          color: Color(0xFFC9C3CD),
          height: 100,
          width: double.infinity,
          child: Center(
            child: cardData.imagePath == null
                ? ElevatedButton(
                    onPressed: _pickAndSaveImage,
                    child: Icon(Icons.photo_album_outlined),
                  )
                : Image.file(File(cardData.imagePath!), fit: BoxFit.fill),
          ),
        ),

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // Done Button
        floatingActionButton: SaveButton(
          cardData: cardData,
          contentController: _contentController,
        ),
        appBar: _buildAppBar(),
        body: SingleChildScrollView(child: _buildPage()),
      ),
    );
  }
}
