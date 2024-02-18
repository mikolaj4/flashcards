import 'package:fiszki_projekt/components/app/tts_button.dart';
import 'package:fiszki_projekt/configs/constants.dart';
import 'package:fiszki_projekt/notifiers/saved_cards_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/word.dart';

class WordTile extends StatelessWidget {
  WordTile({
    required this.word,
    required this.animation,
    this.onPressed,
    super.key,
  });

  final Word word;

  final Animation animation;
  final _tweenOffset =
      Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0));
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation
          .drive(CurveTween(curve: Curves.easeInOutSine))
          .drive(_tweenOffset),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
        child: Consumer<SavedCardsNotifier>(
          builder: (_, notifier, __) => Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius:
                    BorderRadius.circular(constBorderRadiusElevatedButtons),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                )),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  notifier.showPolish ? Text(word.polish) : const SizedBox(),
                  notifier.showGerman ? Text(word.german) : const SizedBox(),
                ],
              ),
              trailing: SizedBox(
                width: 75,
                child: Row(
                  children: [
                    TTSButton(
                      word: word,
                      iconSize: 30,
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          onPressed?.call();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
