import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/models/goodthing_model.dart';
import 'package:hive_ce/hive.dart';

class CardlistProvider extends Notifier<List<GoodthingModel>> {
  final _box = Hive.box<GoodthingModel>("LocalGoodThings");

  @override
  List<GoodthingModel> build() {
    // At First the Cards List is empty, In future, it gets its value from the phone's disk
    return _box.values.toList();
  }

  /// This is function that takes in the [GoodthingModel] as a input and store it in the state;
  /// If it already presents in the state, it update the respective card.
  void addGoodThing(GoodthingModel newGoodThing) {
    _box.put(newGoodThing.serialNo, newGoodThing);

    state = _box.values.toList();
  }
}

final cardListProvider =
    NotifierProvider<CardlistProvider, List<GoodthingModel>>(
      () => CardlistProvider(),
    );
