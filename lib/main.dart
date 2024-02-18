import 'package:fiszki_projekt/configs/themes.dart';
import 'package:fiszki_projekt/notifiers/flashcards_notifier.dart';
import 'package:fiszki_projekt/notifiers/saved_cards_notifier.dart';
import 'package:fiszki_projekt/notifiers/settings_notifier.dart';
import 'package:fiszki_projekt/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => FlashcardsNotifier()),
    ChangeNotifierProvider(create: (_) => SettingsNotifier()),
    ChangeNotifierProvider(create: (_) => SavedCardsNotifier()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Projekt fiszki',
      theme: appTheme,
      home: const HomePage(),
    );
  }
}
