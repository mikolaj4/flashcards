import 'package:fiszki_projekt/notifiers/flashcards_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configs/constants.dart';
import '../../enums/slide_direction_enum.dart';

class LeftRightButtons extends StatelessWidget {
  const LeftRightButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonWidth = (size.width * 0.8) / 2;
    final buttonHeight = (size.height * 0.06);

    Widget buildButton(String buttonText, Color buttonColor) {
      return Consumer<FlashcardsNotifier>(
        builder: (_, notifier, __) => GestureDetector(
          child: ElevatedButton(
            onPressed: () {
              if (notifier.flipCard2) {
                if (buttonText == 'Umiem!') {
                  notifier.runSwipeCard2(
                      direction: SlideDirectionEnum.leftAway);
                  notifier.runSlideCard1();
                  notifier.setIgnoreTouch(ignore: true);
                  //generujemy nowe słowo na nową fisze po przesunięciu
                  notifier.generateCurrentWord(context: context);
                } else if (buttonText == 'Nie umiem') {
                  notifier.runSwipeCard2(
                      direction: SlideDirectionEnum.rightAway);
                  notifier.runSlideCard1();
                  notifier.setIgnoreTouch(ignore: true);
                  //generujemy nowe słowo na nową fisze po przesunięciu
                  notifier.generateCurrentWord(context: context);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
            ),
            child: SizedBox(
              width: buttonWidth,
              height: buttonHeight,
              child: Center(
                child: Text(
                  buttonText,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButton('Nie umiem',
              constLeftButtonColor), // Set the desired color for the left button
          buildButton('Umiem!',
              constRightButtonColor), // Set the desired color for the right button
        ],
      ),
    );
  }
}
