import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../notifiers/flashcards_notifier.dart';
import '../../pages/home_page.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  void _resetAndNavigateToHomePage(
      BuildContext context, FlashcardsNotifier notifier) {
    notifier.resetFlashcards();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashcardsNotifier>(
      builder: (_, notifier, __) {
        return AppBar(
          actions: [
            IconButton(
              onPressed: () {
                _resetAndNavigateToHomePage(context, notifier);
              },
              icon: const Icon(Icons.clear),
            ),
          ],
          title: Text(notifier.topic),
        );
      },
    );
  }
}
