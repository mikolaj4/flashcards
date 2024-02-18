import 'dart:math';

import 'package:fiszki_projekt/components/flashcards_page/card_display.dart';
import 'package:fiszki_projekt/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../animations/half_flip_animation.dart';
import '../../animations/slide_animation.dart';
import '../../enums/slide_direction_enum.dart';
import '../../notifiers/flashcards_notifier.dart';

class Card2 extends StatelessWidget {
  const Card2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<FlashcardsNotifier>(
      builder: (_, notifier, __) => GestureDetector(
        //gdy fiszka zostanie przesunięta w lewo lub prawo
        onHorizontalDragEnd: (details) {
          debugPrint('WARTOŚĆ SWIPE: ${details.primaryVelocity}');
          if (details.primaryVelocity! > 0) {
            //gdy fiszka zostanie przesunięta w lewo
            notifier.runSwipeCard2(direction: SlideDirectionEnum.leftAway);
            notifier.runSlideCard1();
            notifier.setIgnoreTouch(ignore: true);
            //generujemy nowe słowo na nową fisze po przesunięciu
            notifier.generateCurrentWord(context: context);
          }
          if (details.primaryVelocity! < 0) {
            //gdy fiszka zostanie przesunięta w prawo
            notifier.runSwipeCard2(direction: SlideDirectionEnum.rightAway);
            notifier.runSlideCard1();
            notifier.setIgnoreTouch(ignore: true);
            //generujemy nowe słowo na nową fisze po przesunięciu
            notifier.generateCurrentWord(context: context);
          }
        },
        child: HalfFlipAnimation(
          animate: notifier.flipCard2,
          reset: notifier.resetFlipCard2,
          secondHalfFlip: true,
          fistHalfFlipDone: () {
            debugPrint('anim2 flip zrobiony');
            //po animacji już można dotykać karty
            notifier.setIgnoreTouch(ignore: false);
          },
          child: SlideAnimation(
            animationCompleted: () {
              notifier.resetCard2();
            },
            reset: notifier.resetSwipeCard2,
            //ta animacja sie odpali jesli swipeCard2 będzie true
            animate: notifier.swipeCard2,
            //tutaj z enuma wybieram kierunek animacji
            direction: notifier.swipedDirection,
            // animacja dla fiszki
            child: Center(
              // to jest katta fiszki
              child: Container(
                width: size.width *
                    constFlashcardWidth, // wymiary fiszki na podstawie ekranu
                height: size.height * constFlashcardHeigth,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: constFlashcardBorderWidth,
                  ),
                  borderRadius:
                      BorderRadius.circular(constBorderRadiusElevatedButtons),
                  color: Theme.of(context).primaryColor,
                ),
                child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: const CardDisplay(isCard1: false)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
