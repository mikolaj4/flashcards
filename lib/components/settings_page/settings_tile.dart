import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.icon,
    required this.title,
    required this.callbackFunction,
    Key? key,
  }) : super(key: key);

  final Icon icon;
  final String title;
  final VoidCallback callbackFunction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callbackFunction,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: icon,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
