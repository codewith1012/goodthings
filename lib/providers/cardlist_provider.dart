import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/models/goodthing_model.dart';
import 'package:hive_ce/hive.dart';

class CardlistProvider extends Notifier<List<GoodthingModel>> {
  final _box = Hive.box<GoodthingModel>("LocalGoodThings");

  @override
  List<GoodthingModel> build() {
    return _box.values.toList();
  }

  /// This is function that takes in the [GoodthingModel] as a input and store it in the state;
  /// If it already presents in the state, it update the respective card.
  void addGoodThing(GoodthingModel newGoodThing) async {
    await _box.put(newGoodThing.serialNo, newGoodThing);

    state = _box.values.toList().reversed.toList();
  }

  /// It Deletes the GoodThing Compelety (Removes it from the Hive itself)
  /// Use it with Caution
  void removeGoodThing(GoodthingModel goodThing) async {
    await _box.delete(goodThing.serialNo);

    state = _box.values.toList().reversed.toList();
  }
}

final cardListProvider =
    NotifierProvider<CardlistProvider, List<GoodthingModel>>(
      () => CardlistProvider(),
    );
