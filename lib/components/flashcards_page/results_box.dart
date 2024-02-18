import 'package:fiszki_projekt/notifiers/flashcards_notifier.dart';
import 'package:fiszki_projekt/pages/flashcards_page.dart';
import 'package:fiszki_projekt/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../databases/database_manager.dart';

class ResultsBox extends StatefulWidget {
  const ResultsBox({super.key});

  @override
  State<ResultsBox> createState() => _ResultsBoxState();
}

class _ResultsBoxState extends State<ResultsBox> {
  bool _haveSavedCards = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashcardsNotifier>(
      builder: (_, notifier, __) {
        return AlertDialog(
          title: Text(
            notifier.isSessionCompleted
                ? 'Umiesz już wszystko!'
                : 'Koniec rundy',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: DataTable(
              columnSpacing: 8.0,
              columns: const [
                DataColumn(label: Text('Statystyka')),
                DataColumn(label: Text('Wartość')),
              ],
              rows: [
                buildDataRow(
                    title: 'Runda:', stat: notifier.roundCounter.toString()),
                buildDataRow(
                    title: 'Liczba fiszek:',
                    stat: notifier.totalCardsCounter.toString()),
                buildDataRow(
                    title: 'Nie umiesz:',
                    stat: notifier.incorrectCardsCounter.toString()),
                buildDataRow(
                    title: 'Umiesz:',
                    stat: notifier.correctCardsCounter.toString()),
                buildDataRow(
                    title: 'Procent:',
                    stat: '${notifier.correctPercentage.toString()}%'),
              ],
            ),
          ),
          actions: [
            if (!notifier.isSessionCompleted)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FlashcardsPage()));
                },
                child: const Text('Powtórka błędnych'),
              ),
            const SizedBox(height: 8),
            if (!notifier.isSessionCompleted)
              ElevatedButton(
                onPressed: _haveSavedCards
                    ? null
                    : () async {
                        for (int i = 0;
                            i < notifier.incorrectFlashcards.length;
                            i++) {
                          await DatabaseManager().insertWord(
                              word: notifier.incorrectFlashcards[i]);
                          final words = await DatabaseManager().selectWords();
                          debugPrint(
                              'Wpisów do bazy lokalnej: ${words.length}');
                        }
                        setState(() {
                          _haveSavedCards = true;
                        });
                      },
                child: const Text('Zapisz błędne do bazy'),
              ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                notifier.resetFlashcards();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
              },
              child: const Text('Strona główna'),
            ),
          ],
        );
      },
    );
  }

  DataRow buildDataRow({required String title, required String stat}) {
    return DataRow(cells: [
      DataCell(
        Padding(
          padding: const EdgeInsets.all(7.0),
          child: Text(title),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.all(7.0),
          child: Text(
            stat,
            textAlign: TextAlign.right,
          ),
        ),
      ),
    ]);
  }
}
