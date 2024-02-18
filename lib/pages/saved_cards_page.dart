import 'package:fiszki_projekt/components/app/cutom_appbar.dart';
import 'package:fiszki_projekt/configs/constants.dart';
import 'package:fiszki_projekt/databases/database_manager.dart';
import 'package:fiszki_projekt/enums/language_type_enum.dart';
import 'package:fiszki_projekt/notifiers/flashcards_notifier.dart';
import 'package:fiszki_projekt/notifiers/saved_cards_notifier.dart';
import 'package:fiszki_projekt/pages/flashcards_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/saved_cards_page/top_button.dart';
import '../components/saved_cards_page/bottom_button.dart';
import '../components/saved_cards_page/flashcard_tile.dart';
import '../data/word.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _listKey = GlobalKey<AnimatedListState>();
  final _reviewWords = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(constAppBarH),
        child: CustomAppBar(),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Selector<SavedCardsNotifier, bool>(
              selector: (_, review) => review.buttonsAreDisabled,
              builder: (_, disable, __) => Row(
                children: [
                  TopButton(
                    isDisabled: disable,
                    title: 'Nauka wszystkich',
                    onPressed: () {
                      final provider = Provider.of<FlashcardsNotifier>(context,
                          listen: false);
                      provider.selectedWords.clear();
                      DatabaseManager().selectWords().then((words) {
                        provider.selectedWords = words.toList();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FlashcardsPage()));
                      });
                    },
                  ),
                  TopButton(
                    isDisabled: disable,
                    title: 'Usuń wszystko',
                    onPressed: () {
                      _clearAllWords();
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: FutureBuilder(
              future: DatabaseManager().selectWords(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var sortlist = snapshot.data as List<Word>;
                  sortlist.sort((a, b) => a.polish.compareTo(b.polish));

                  WidgetsBinding.instance.addPostFrameCallback(((timeStamp) {
                    _insertWords(words: sortlist);
                  }));

                  return AnimatedList(
                    key: _listKey,
                    initialItemCount: _reviewWords.length,
                    itemBuilder: (context, index, animation) => WordTile(
                      word: _reviewWords[index],
                      animation: animation,
                      onPressed: () {
                        _removeWord(word: _reviewWords[index]);
                      },
                    ),
                  );
                } else {
                  //jeśli nie ma hasdata
                  return SizedBox();
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Selector<SavedCardsNotifier, bool>(
              selector: (_, review) => review.buttonsAreDisabled,
              builder: (_, disable, __) => Row(
                children: [
                  BottomButton(
                    isDisabled: disable,
                    languageType: LanguageTypeEnum.polish,
                  ),
                  BottomButton(
                    isDisabled: disable,
                    languageType: LanguageTypeEnum.german,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _insertWords({required List<Word> words}) {
    for (int i = 0; i < words.length; i++) {
      _listKey.currentState?.insertItem(i);
      _reviewWords.insert(i, words[i]);
    }
  }

  _removeWord({required Word word}) async {
    var w = word;
    _listKey.currentState?.removeItem(_reviewWords.indexOf(w),
        (context, animation) => WordTile(word: w, animation: animation));
    _reviewWords.remove(w);
    await DatabaseManager().removeWord(word: w);

    //jeśli usunę ostatnie słowo to wyłączam przyciski
    if (_reviewWords.isEmpty) {
      // ignore: use_build_context_synchronously
      Provider.of<SavedCardsNotifier>(context, listen: false)
          .disableButtons(disable: true);
    }
  }

  _clearAllWords() {
    for (int i = 0; i < _reviewWords.length; i++) {
      _listKey.currentState?.removeItem(
          0,
          (context, animation) =>
              WordTile(word: _reviewWords[i], animation: animation));
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _reviewWords.clear();
      await DatabaseManager().removeAllWords();
      //tu gdy usuwam wszystkie słowa na raz to guzki też wyłączam
      // ignore: use_build_context_synchronously
      Provider.of<SavedCardsNotifier>(context, listen: false)
          .disableButtons(disable: true);
    });
  }
}
