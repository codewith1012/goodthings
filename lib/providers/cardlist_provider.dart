import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/models/goodthing_model.dart';

class CardlistProvider extends Notifier<List<GoodthingModel>> {
  @override
  List<GoodthingModel> build() {
    // At First the Cards List is empty, In future, it gets its value from the phone's disk
    return [];
  }

  /// This is function that takes in the [GoodthingModel] as a input and store it in the state;
  /// If it already presents in the state, it update the respective card.
  void addGoodThing(GoodthingModel newGoodThing) {
    bool exists = state.any((card) => card.serialNo == newGoodThing.serialNo);

    // Debug print
    debugPrint("Card exists? $exists");

    if (exists) {
      state = [
        for (final item in state)
          if (item.serialNo == newGoodThing.serialNo) newGoodThing else item,
      ];
    } else {
      state = [...state, newGoodThing];
    }

    debugPrint("No of Cards ${state.length}");
  }
}

final cardListProvider =
    NotifierProvider<CardlistProvider, List<GoodthingModel>>(
      () => CardlistProvider(),
    );
