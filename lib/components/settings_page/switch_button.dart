import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enums/settings_enum.dart';
import '../../notifiers/settings_notifier.dart';

class SwitchButton extends StatelessWidget {
  const SwitchButton({
    required this.displayOption,
    required this.text,
    super.key,
  });

  final SettingsEnum displayOption;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsNotifier>(
      builder: (_, notifier, __) => Column(
        children: [
          SwitchListTile(
            inactiveThumbColor: Colors.black.withOpacity(0.6),
            tileColor: Colors.black.withOpacity(0.6),
            title: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            value: notifier.displayOptions.entries
                .firstWhere((element) => element.key == displayOption)
                .value,
            onChanged: (value) {
              notifier.udpateDisplayOptions(
                displayOption: displayOption,
                isOn: value,
              );
            },
          ),
          const Divider(
            height: 2,
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
