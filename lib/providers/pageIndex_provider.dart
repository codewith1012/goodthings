// A provider for a page index
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageIndexNotifier extends Notifier<int> {
  @override
  int build() => 0; // The initial state is 0

  void setIndex(int newIndex) {
    state = newIndex;
  }
}

final pageIndexProvider = NotifierProvider<PageIndexNotifier, int>(
  () => PageIndexNotifier(),
);
