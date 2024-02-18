import 'package:fiszki_projekt/configs/constants.dart';
import 'package:fiszki_projekt/notifiers/flashcards_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressBar extends StatefulWidget {
  const ProgressBar({super.key});

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  //wartości aby wiedzieć jak zanimować progress bar
  double progressBarState1 = 0.0;
  double progressBarState2 = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: constProgressBarIncreaseDuration),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startAnim() {
    _controller.reset();
    _controller.forward();
    progressBarState1 = progressBarState2;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Consumer<FlashcardsNotifier>(
      builder: (_, notifier, __) {
        progressBarState2 = notifier.percentComplete;
        if (progressBarState2 == 0) {
          progressBarState1 = 0;
        }
        var animation =
            Tween<double>(begin: progressBarState1, end: progressBarState2)
                .animate(CurvedAnimation(
                    parent: _controller, curve: Curves.easeInOutCubic));

        startAnim();

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Padding(
            padding: EdgeInsets.all(screenSize.width * 0.05),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(constBorderRadiusElevatedButtons),
              child: LinearProgressIndicator(
                minHeight: screenSize.height * 0.03,
                value: animation.value,
              ),
            ),
          ),
        );
      },
    );
  }
}
