import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goodthings/models/goodthing_model.dart';
import 'package:goodthings/screens/card_screen.dart';
import 'package:intl/intl.dart';

class GoodthingCard extends StatelessWidget {
  final GoodthingModel cardData;

  const GoodthingCard({super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date & Time
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat(' d-MMM-yy').format(cardData.dateTime),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              DateFormat('H:mm  ').format(cardData.dateTime),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),

        // The Card
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CardScreen(cardData: cardData),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),

            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 80, maxHeight: 100),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // The Text Content
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cardData.title,
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                cardData.content,
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // The Image, For now the icon
                    if (cardData.imagePath != null)
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          child: Image.file(
                            File(cardData.imagePath!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
