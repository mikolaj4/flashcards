import 'package:fiszki_projekt/components/app/tts_button.dart';
import 'package:fiszki_projekt/notifiers/flashcards_notifier.dart';
import 'package:fiszki_projekt/notifiers/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enums/settings_enum.dart';

class CardDisplay extends StatelessWidget {
  const CardDisplay({
    required this.isCard1,
    super.key,
  });

  final bool isCard1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Consumer<SettingsNotifier>(
        builder: (_, notifier, __) {
          final setPolishFirst = notifier.displayOptions.entries
              .firstWhere((element) => element.key == SettingsEnum.polishFirst)
              .value;

          final showAudio = notifier.displayOptions.entries
              .firstWhere((element) => element.key == SettingsEnum.showAudio)
              .value;

          return Consumer<FlashcardsNotifier>(
            builder: (_, notifier, __) => isCard1
                ? Column(
                    // pierwsza strona fiszki
                    children: [
                      if (setPolishFirst) ...[
                        buildTextBox(notifier.word1.polish, context, 1)
                      ] else if (!setPolishFirst) ...[
                        if (showAudio) ...[
                          buildTextBox(notifier.word1.german, context, 1),
                          TTSButton(word: notifier.word1)
                        ] else if (!showAudio) ...[
                          buildTextBox(notifier.word1.german, context, 1),
                        ]
                      ]
                    ],
                  )
                : Column(
                    // druga strona fiszki
                    children: [
                      if (setPolishFirst) ...[
                        if (showAudio) ...[
                          buildTextBox(notifier.word2.german, context, 1),
                          TTSButton(word: notifier.word2)
                        ] else if (!showAudio) ...[
                          buildTextBox(notifier.word2.german, context, 1),
                        ]
                      ] else if (!setPolishFirst) ...[
                        buildTextBox(notifier.word2.polish, context, 1)
                      ]
                    ],
                  ),
          );
        },
      ),
    );
  }
}

Expanded buildTextBox(String text, BuildContext context, int flex) {
  return Expanded(
      flex: flex,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FittedBox(
          child: Text(
            text,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
      ));
}
