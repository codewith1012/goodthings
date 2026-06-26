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
    final bool hasImage = cardData.imagePath != null;

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CardScreen(cardData: cardData)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withAlpha(50),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withAlpha(50),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeStamp(),
            _buildTitle(context),
            if (hasImage) ..._buildImage(),
            ..._buildContent(context, hasImage),
          ],
        ),
      ),
    );
  }

  Row _buildTimeStamp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatDateTime(cardData.dateTime),
          style: const TextStyle(
            fontFamily: 'Judson',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: Color(0xFF4B4445),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.more_horiz_rounded,
            size: 20,
            color: Color(0xFF4B4445),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final cardDay = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(cardDay).inDays;

    final timeStr = DateFormat('h:mm a').format(dt);
    if (diff == 0) return 'TODAY, $timeStr'.toUpperCase();
    if (diff == 1) return 'YESTERDAY, $timeStr'.toUpperCase();
    return '${DateFormat('MMM d').format(dt).toUpperCase()}, $timeStr';
  }

  Text _buildTitle(BuildContext context) {
    return Text(
      cardData.title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: 'Junge',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primaryContainer,
        height: 1.25,
      ),
    );
  }

  List<Widget> _buildImage() {
    return [
      const SizedBox(height: 14),
      ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.file(File(cardData.imagePath!), fit: BoxFit.cover),
        ),
      ),
    ];
  }

  List<Widget> _buildContent(BuildContext context, bool hasImage) {
    return [
      const SizedBox(height: 14),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left accent bar (tertiary-container colour)
            Container(
              width: 3.5,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                cardData.content,
                maxLines: hasImage ? 2 : 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Judson',
                  fontSize: hasImage ? 15 : 16,
                  fontStyle: hasImage ? FontStyle.italic : FontStyle.normal,
                  color: Color(0xFF4B4445),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
