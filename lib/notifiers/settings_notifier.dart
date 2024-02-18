import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/settings_enum.dart';

class SettingsNotifier extends ChangeNotifier {
  Map<SettingsEnum, bool> displayOptions = {
    SettingsEnum.polishFirst: true,
    SettingsEnum.showAudio: false
  };

  udpateDisplayOptions(
      {required SettingsEnum displayOption, required bool isOn}) {
    displayOptions.update(displayOption, (value) => isOn);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(displayOption.name, isOn);
    });
    notifyListeners();
  }
}
