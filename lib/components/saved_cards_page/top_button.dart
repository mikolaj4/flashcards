import 'package:fiszki_projekt/configs/constants.dart';
import 'package:flutter/material.dart';

class TopButton extends StatelessWidget {
  const TopButton({
    required this.title,
    required this.onPressed,
    this.isDisabled = false,
    Key? key,
  }) : super(key: key);

  final String title;
  final VoidCallback onPressed;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: constMainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}
