import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fiszki_projekt/components/flashcards_page/results_box.dart';
import 'package:fiszki_projekt/configs/constants.dart';
import 'package:fiszki_projekt/data/word.dart';
import 'package:fiszki_projekt/data/words.dart';
import 'package:fiszki_projekt/enums/slide_direction_enum.dart';

class FlashcardsNotifier extends ChangeNotifier {
  int roundCounter = 0;
  int totalCardsCounter = 0;
  int correctCardsCounter = 0;
  int incorrectCardsCounter = 0;
  int correctPercentage = 0;

  double percentComplete = 0.0;
  List<Word> incorrectFlashcards = [];

  String topic = '';
  Word word1 = Word(topic: "", polish: "", german: "");
  Word word2 = Word(topic: "", polish: "", german: "");
  List<Word> selectedWords = [];

  bool isFirstround = true;
  bool isRoundCompleted = false;
  bool isSessionCompleted = false;

  resetFlashcards() {
    resetCard1();
    resetCard2();
    incorrectFlashcards.clear();
    isFirstround = true;
    isRoundCompleted = false;
    isSessionCompleted = false;
    roundCounter = 0;
  }

  setTopic({required String topic}) {
    this.topic = topic;
    notifyListeners();
  }

  generateAllSelectedWords() {
    words.shuffle();
    isRoundCompleted = false;
    if (isFirstround) {
      if (topic == '5 Losowych') {
        selectedWords = words.take(5).toList();
      } else if (topic == '20 Losowych') {
        selectedWords = words.take(20).toList();
      } else if (topic == 'Wszystko') {
        selectedWords = words.toList();
      } else if (topic != 'Review') {
        selectedWords =
            words.where((element) => element.topic == topic).toList();
      }
    } else {
      selectedWords = incorrectFlashcards.toList();
      incorrectFlashcards.clear();
    }
    roundCounter++;
    totalCardsCounter = selectedWords.length;
    correctCardsCounter = 0;
    incorrectCardsCounter = 0;
    resetProgressBar();
  }

  generateCurrentWord({required BuildContext context}) {
    if (selectedWords.isNotEmpty) {
      final r = Random().nextInt(selectedWords.length);
      word1 = selectedWords[r];
      selectedWords.removeAt(r);
    } else {
      if (incorrectFlashcards.isEmpty) {
        isSessionCompleted = true;
      }
      isRoundCompleted = true;
      isFirstround = false;
      calculateCorrectPercentage();
      debugPrint("wszystkie słowa wybrane");
      Future.delayed(const Duration(milliseconds: 500), () {
        showDialog(context: context, builder: (context) => ResultsBox());
      });
    }

    Future.delayed(
        const Duration(milliseconds: constFlashcardSizeSlideDuration), () {
      word2 = word1;
    });
  }

  calculateCorrectPercentage() {
    final percentage = correctCardsCounter / totalCardsCounter;
    correctPercentage = (percentage * 100).round();
  }

  calculateCompletedPercent() {
    percentComplete =
        (correctCardsCounter + incorrectCardsCounter) / totalCardsCounter;
    notifyListeners();
  }

  resetProgressBar() {
    percentComplete = 0.0;
    notifyListeners();
  }

  updateCardOutcome({required Word word, required bool isCorrect}) {
    if (!isCorrect) {
      incorrectFlashcards.add(word);
      incorrectCardsCounter++;
    } else {
      correctCardsCounter++;
    }

    calculateCompletedPercent();
    notifyListeners();
  }

  bool ignoreTouches = true;

  setIgnoreTouch({required bool ignore}) {
    ignoreTouches = ignore;
    notifyListeners();
  }

  SlideDirectionEnum swipedDirection = SlideDirectionEnum.none;

  bool slideCard1 = false;
  bool flipCard1 = false;
  bool flipCard2 = false;
  bool swipeCard2 = false;

  bool resetSlideCard1 = false;
  bool resetFlipCard1 = false;
  bool resetFlipCard2 = false;
  bool resetSwipeCard2 = false;

  runSlideCard1() {
    resetSlideCard1 = false;
    slideCard1 = true;
    notifyListeners();
  }

  runflipCard1() {
    resetFlipCard1 = false;
    flipCard1 = true;
    notifyListeners();
  }

  resetCard1() {
    resetSlideCard1 = true;
    resetFlipCard1 = true;
    slideCard1 = false;
    flipCard1 = false;
  }

  runflipCard2() {
    resetFlipCard2 = false;
    flipCard2 = true;
    notifyListeners();
  }

  runSwipeCard2({required SlideDirectionEnum direction}) {
    updateCardOutcome(
        word: word2, isCorrect: direction == SlideDirectionEnum.leftAway);
    resetSwipeCard2 = false;
    swipedDirection = direction;
    swipeCard2 = true;
    notifyListeners();
  }

  resetCard2() {
    resetSwipeCard2 = true;
    resetFlipCard2 = true;
    swipeCard2 = false;
    flipCard2 = false;
  }

  int countWordsForTopic({required String topic}) {
    return words.where((word) => word.topic == topic).length;
  }
}
