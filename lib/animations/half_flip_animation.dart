import 'dart:math';

import 'package:flutter/material.dart';

import '../configs/constants.dart';

//animacja połowy obrotu fiszki
class HalfFlipAnimation extends StatefulWidget {
  const HalfFlipAnimation({
    required this.secondHalfFlip,
    required this.fistHalfFlipDone,
    required this.child,
    required this.animate,
    required this.reset,
    Key? key,
  }) : super(key: key);

  // zmienna przechowuje info o tym która połowa obrotu to jest
  final bool secondHalfFlip;
  // ta funkcja będzie wywołana gdy pierwsza połowa obrotu fiszki się dokona
  final VoidCallback fistHalfFlipDone;
  final Widget child;
  final bool animate;
  final bool reset;

  @override
  State<HalfFlipAnimation> createState() => _HalfFlipAnimationState();
}

class _HalfFlipAnimationState extends State<HalfFlipAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController controllerFlipAnimation;

  @override
  void initState() {
    super.initState();
    controllerFlipAnimation = AnimationController(
      duration: const Duration(milliseconds: constHalfFlipDuration),
      vsync: this,
    )..addListener(() {
        if (controllerFlipAnimation.isCompleted) {
          widget.fistHalfFlipDone.call();
        }
      });
  }

  @override
  void dispose() {
    controllerFlipAnimation.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(HalfFlipAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate) {
      controllerFlipAnimation.forward();
    }
    if (widget.reset) {
      controllerFlipAnimation.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    double rotationAdjustment = 0;
    if (widget.secondHalfFlip) {
      rotationAdjustment = pi / 2;
    }

    return AnimatedBuilder(
      animation: controllerFlipAnimation,
      builder: (context, child) {
        final double animationValue = controllerFlipAnimation.value;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY((animationValue * pi) / 2)
            ..rotateY(rotationAdjustment),
          child: widget.child,
        );
      },
    );
  }
}
