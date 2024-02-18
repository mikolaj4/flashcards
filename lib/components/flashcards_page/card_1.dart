import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../animations/half_flip_animation.dart';
import '../../animations/slide_animation.dart';
import '../../configs/constants.dart';
import '../../enums/slide_direction_enum.dart';
import '../../notifiers/flashcards_notifier.dart';
import 'card_display.dart';

class Card1 extends StatelessWidget {
  const Card1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Consumer<FlashcardsNotifier>(
      builder: (_, notifier, __) => GestureDetector(
        // gdy fliszka zostanie naciśnięta 2 razy to się obraca
        onDoubleTap: () {
          notifier.runflipCard1();
          notifier.setIgnoreTouch(ignore: true);
        },
        child: HalfFlipAnimation(
          animate: notifier.flipCard1,
          reset: notifier.resetFlipCard1,
          secondHalfFlip: false,
          fistHalfFlipDone: () {
            notifier.resetCard1();
            //gdy pierwsza część animacji obrotu kart sie zrobi to wywołuje tu wykonanie drugiej części
            notifier.runflipCard2();
            debugPrint('anim1 flip zrobiony');
          },
          child: SlideAnimation(
            animationDuration: constFlashcardUpSlideDuratoin,
            animationDelay: 100,
            animationCompleted: () {
              notifier.setIgnoreTouch(ignore: false);
            },
            reset: notifier.resetSlideCard1,
            //gdy slideCard1 zmienia się na true to wyświetlamy kolejną karte
            animate: notifier.slideCard1 && !notifier.isRoundCompleted,
            //tutaj z enuma wybieram kierunek animacji
            direction: SlideDirectionEnum.upIn,
            // animacja dla fiszki
            child: Center(
              // to jest katta fiszki
              child: Container(
                width: screenSize.width *
                    constFlashcardWidth, // wymiary fiszki na podstawie ekranu
                height: screenSize.height * constFlashcardHeigth,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: constFlashcardBorderWidth,
                  ),
                  borderRadius:
                      BorderRadius.circular(constBorderRadiusElevatedButtons),
                  color: Theme.of(context).primaryColor,
                ),
                child: const CardDisplay(
                  isCard1: true,
                ), // mój widżet
              ),
            ),
          ),
        ),
      ),
    );
  }
}
