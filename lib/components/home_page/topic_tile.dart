import 'package:fiszki_projekt/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/words.dart';
import '../../notifiers/flashcards_notifier.dart';
import '../../pages/flashcards_page.dart';

class TopicTile extends StatelessWidget {
  const TopicTile({super.key, required this.topic});

  final String topic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleTap(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(constBorderRadiusElevatedButtons),
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          children: [
            buildNumberOfFlashcardsInSet(),
            buildTopicText(),
          ],
        ),
      ),
    );
  }

  void handleTap(BuildContext context) {
    debugPrint('Naciśnięta kategoria: $topic');
    loadSession(context: context, topic: topic);
  }

  Widget buildNumberOfFlashcardsInSet() {
    return Consumer<FlashcardsNotifier>(
      builder: (_, notifier, __) {
        int wordCount = 0;

        if (topic == '5 Losowych') {
          wordCount = 5;
        } else if (topic == '20 Losowych') {
          wordCount = 20;
        } else if (topic == 'Wszystko') {
          // ignore: unused_local_variable
          for (var word in words) {
            wordCount++;
          }
        } else {
          wordCount = notifier.countWordsForTopic(topic: topic);
        }

        return Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
            child: Text(
              wordCount.toString(),
              style:
                  const TextStyle(fontSize: constFontSizeTopicTileWordsCount),
            ),
          ),
        );
      },
    );
  }

  Widget buildTopicText() {
    return Expanded(
      flex: 1,
      child: Text(topic),
    );
  }

  loadSession({required BuildContext context, required String topic}) {
    Navigator.of(context).pushReplacement(
        // pushReplacement nie pozwala wrócić do poprzedniej storny
        MaterialPageRoute(builder: (context) => const FlashcardsPage()));

    Provider.of<FlashcardsNotifier>(context, listen: false)
        .setTopic(topic: topic);
  }
}
