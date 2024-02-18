import 'package:fiszki_projekt/components/flashcards_page/card_2.dart';
import 'package:fiszki_projekt/components/flashcards_page/left_right_buttons.dart';
import 'package:fiszki_projekt/components/flashcards_page/progress_bar.dart';
import 'package:fiszki_projekt/notifiers/flashcards_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/app/cutom_appbar.dart';
import '../components/flashcards_page/card_1.dart';
import '../configs/constants.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({super.key});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  @override
  //initState sie odpala przy początku każdej sesji fiszkowej
  void initState() {
    //gdy sesja startuje to wywyłujemy metodę runSlideCard1
    //czy widgetsbinding nie można wyjebać???
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final flashcardsNotifier =
          Provider.of<FlashcardsNotifier>(context, listen: false);
      flashcardsNotifier.runSlideCard1();
      flashcardsNotifier.generateAllSelectedWords();
      flashcardsNotifier.generateCurrentWord(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashcardsNotifier>(
      // no tu jak wysłyszy że jest zmiana tematu to robi update czy coś
      builder: (_, notifier, __) => Scaffold(
          // tutaj appbar jest CustomAppBar() - który zrobiłem, jest w pliku components/app/
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(constAppBarH),
            child: CustomAppBar(),
          ),
          //Card1() jest z pliku components/flashcards_page
          body: IgnorePointer(
            ignoring: notifier
                .ignoreTouches, // ignorujemy dotykanie kard w trakcje animacji
            child: const Stack(
              children: [
                Align(alignment: Alignment.topCenter, child: ProgressBar()),
                Card2(),
                Card1(),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: LeftRightButtons()),
              ],
            ),
          )),
    );
  }
}
