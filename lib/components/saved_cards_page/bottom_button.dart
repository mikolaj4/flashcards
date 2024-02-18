import 'package:fiszki_projekt/configs/constants.dart';
import 'package:fiszki_projekt/notifiers/saved_cards_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enums/language_type_enum.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({
    required this.languageType,
    this.isDisabled = false,
    Key? key,
  }) : super(key: key);

  final LanguageTypeEnum languageType;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: constMainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: isDisabled
                ? null
                : () {
                    Provider.of<SavedCardsNotifier>(context, listen: false)
                        .updateShowLanguage(language: languageType);
                  },
            child: Text(
              languageType.toSymbol(),
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}

extension LanguageSymbol on LanguageTypeEnum {
  String toSymbol() {
    switch (this) {
      case LanguageTypeEnum.polish:
        return 'Angielski';
      case LanguageTypeEnum.german:
        return 'Niemiecki';
    }
  }
}
