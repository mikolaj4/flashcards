import 'package:fiszki_projekt/configs/constants.dart';
import 'package:fiszki_projekt/data/words.dart';
import 'package:fiszki_projekt/databases/database_manager.dart';
import 'package:fiszki_projekt/notifiers/flashcards_notifier.dart';
import 'package:fiszki_projekt/notifiers/saved_cards_notifier.dart';
import 'package:fiszki_projekt/pages/saved_cards_page.dart';
import 'package:fiszki_projekt/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/home_page/topic_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _topics = []; // lista zawierająca kategorie słówek

  @override
  void initState() {
    for (var t in words) {
      // wypełnienie listy kategorii kategoriami z words.dart
      if (!_topics.contains(t.topic)) {
        // aby nie powtarzać kategorii
        _topics.add(t.topic);
      }
      _topics.sort(); // posortowanie kategorii alfabetycznie
    }

    _topics.insertAll(0, ['5 Losowych', '20 Losowych', 'Wszystko']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize =
        MediaQuery.of(context).size; // pobiera rozmiary ekranu urządzenia
    final paddingAroundScrollView = screenSize.width * 0.03;

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: screenSize.height * constHomePageAppbarHeigth,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Provider.of<FlashcardsNotifier>(context, listen: false)
                      .setTopic(topic: 'Ustawienia');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                },
                child: SizedBox(
                    width: screenSize.width * constIconPadding,
                    child: const Icon(Icons.settings)),
              ),
              const Text('Fiszki - strona główna'),
              GestureDetector(
                onTap: () {
                  _loadReviewPage(context);
                },
                child: SizedBox(
                    width: screenSize.width * constIconPadding,
                    child: const Icon(Icons.analytics)),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
              top: paddingAroundScrollView,
              left: paddingAroundScrollView,
              right: paddingAroundScrollView),
          child: CustomScrollView(
            slivers: [
              SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                      // buduje te kafelki
                      childCount: _topics
                          .length, // lista kafelków ma mieć tyle kafelków ile jest tematów
                      (context, index) => TopicTile(
                          topic: _topics[index])), // TopicTile to mój  widżet
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  )) // odpowiada za wygląd kafelków, 3 to liczba kolumn
            ],
          ),
        ));
  }

  void _loadReviewPage(BuildContext context) {
    Provider.of<FlashcardsNotifier>(context, listen: false)
        .setTopic(topic: 'Review');

    DatabaseManager().selectWords().then((words) {
      final reviewNotifier =
          Provider.of<SavedCardsNotifier>(context, listen: false);
      if (words.isEmpty) {
        reviewNotifier.disableButtons(disable: true);
      } else {
        reviewNotifier.disableButtons(disable: false);
      }

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ReviewPage()));
    });
  }
}
