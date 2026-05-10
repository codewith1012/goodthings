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
            debugPrint("CardData SerialNo ${cardData.serialNo}");
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CardScreen(cardData: cardData)));},
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
            
            child: Row(
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
                        ),
                        SizedBox(height: 8),
                        Text(
                          cardData.content,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
          
                // The Image, For now the icon
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Color(0xFFC9C3CD),
                    height: 75,
                    child: Icon(Icons.emoji_emotions),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
