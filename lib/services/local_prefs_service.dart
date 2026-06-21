import 'package:shared_preferences/shared_preferences.dart';

class LocalprefsService {
  final SharedPreferences _prefs;

  LocalprefsService(this._prefs);

  static const String completedOnBoarding = "has_completed_onBoarding";

  bool hasCompletedOnBoarding() {
    return _prefs.getBool(completedOnBoarding) ?? false;
  }

  Future<void> setOnBoardingCompleted() async {
    await _prefs.setBool(completedOnBoarding, true);
  }
}
