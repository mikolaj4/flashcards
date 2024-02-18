import 'package:fiszki_projekt/components/app/cutom_appbar.dart';
import 'package:fiszki_projekt/databases/database_manager.dart';
import 'package:fiszki_projekt/notifiers/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/settings_page/settings_tile.dart';
import '../components/settings_page/switch_button.dart';
import '../configs/constants.dart';
import '../enums/settings_enum.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsNotifier>(
      builder: (_, notifier, __) {
        return Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(constAppBarH),
            child: CustomAppBar(),
          ),
          body: Stack(
            children: [
              const Column(children: [
                SwitchButton(
                  displayOption: SettingsEnum.polishFirst,
                  text: 'Pokaż Polski najpierw',
                ),
                SwitchButton(
                  displayOption: SettingsEnum.showAudio,
                  text: 'Pokaż dźwięk',
                ),
              ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SettingsTile(
                    title: 'Usuń bazę danych',
                    icon: const Icon(Icons.delete),
                    callbackFunction: () async {
                      await DatabaseManager().removeDatabase();
                      debugPrint('RESET bazy danych NADUSZONY');
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
