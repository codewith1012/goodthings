import 'package:hive_ce_flutter/adapters.dart';

part 'goodthing_model.g.dart';

@HiveType(typeId: 0)
class GoodthingModel {
  // The variables
  @HiveField(0)
  final String serialNo;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final String? imagePath;

  GoodthingModel({
    required this.title,
    required this.dateTime,
    required this.content,
    required this.serialNo,
    required this.imagePath,
  });
}
