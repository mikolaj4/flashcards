import 'package:fiszki_projekt/enums/language_type_enum.dart';
import 'package:flutter/material.dart';

class SavedCardsNotifier extends ChangeNotifier {
  bool showPolish = true, showGerman = true, buttonsAreDisabled = false;

  disableButtons({required bool disable}) {
    buttonsAreDisabled = disable;
    notifyListeners();
  }

  updateShowLanguage({required LanguageTypeEnum language}) {
    switch (language) {
      case LanguageTypeEnum.polish:
        showPolish = !showPolish;
        break;
      case LanguageTypeEnum.german:
        showGerman = !showGerman;
        break;
    }

    notifyListeners();
  }
}
