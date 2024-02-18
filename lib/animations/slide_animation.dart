import 'package:fiszki_projekt/enums/slide_direction_enum.dart';
import 'package:flutter/material.dart';

import '../configs/constants.dart';

// animacja dla wysuwania fiszki od dołu
class SlideAnimation extends StatefulWidget {
  const SlideAnimation(
      {required this.child,
      required this.direction,
      this.animate = true,
      this.reset,
      this.animationCompleted,
      this.animationDuration = constFlashcardSizeSlideDuration,
      this.animationDelay = 0,
      super.key});

  final Widget child;
  final SlideDirectionEnum direction; //kierunek animacji z enuma
  final bool animate;
  final bool? reset;
  final VoidCallback? animationCompleted;
  final int animationDuration;
  final int animationDelay;

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: widget.animationDuration),
      vsync: this,
    )..addListener(() {
        if (_animationController.isCompleted) {
          widget.animationCompleted?.call();
        }
      });

    super.initState();
  }

  @override
  didUpdateWidget(covariant oldWidget) {
    if (widget.reset == true) {
      _animationController.reset();
    }

    if (widget.animate) {
      if (widget.animationDelay > 0) {
        Future.delayed(Duration(milliseconds: widget.animationDelay), () {
          if (mounted) {
            _animationController.forward();
          }
        });
      } else {
        _animationController.forward();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final Animation<Offset> animation;
    Tween<Offset> tween;

    // w tym switchu na podstawie wartosi SlideDirection (z enuma) tworzymy animajaje o danym kierunku.
    switch (widget.direction) {
      case SlideDirectionEnum.leftAway:
        tween =
            Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-1, 0));
        break;
      case SlideDirectionEnum.rightAway:
        tween =
            Tween<Offset>(begin: const Offset(0, 0), end: const Offset(1, 0));
        break;
      case SlideDirectionEnum.leftIn:
        tween =
            Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0));
        break;
      case SlideDirectionEnum.rightIn:
        tween =
            Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0));
        break;
      case SlideDirectionEnum.upIn:
        tween =
            Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0));
        break;
      case SlideDirectionEnum.none:
        tween =
            Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0));
        break;
    }

    animation = tween.animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    return SlideTransition(
      position: animation,
      child: widget.child,
    );
  }
}
