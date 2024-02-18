import 'package:fiszki_projekt/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../data/word.dart';

class TTSButton extends StatefulWidget {
  const TTSButton({super.key, required this.word, this.iconSize = 50});

  final Word word;
  final double iconSize;

  @override
  State<TTSButton> createState() => _TTSButtonState();
}

class _TTSButtonState extends State<TTSButton> {
  bool _isTapped = false;
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setUpTTS();
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
        onPressed: () {
          _runTts(text: widget.word.german);
          setState(() {
            _isTapped = true;
          });
          Future.delayed(const Duration(milliseconds: 600), () {
            setState(() {
              _isTapped = false;
            });
          });
        },
        icon: Icon(
          Icons.audiotrack_rounded,
          size: widget.iconSize,
          color: _isTapped ? constBackgroundColor : Colors.red,
        ),
      ),
    );
  }

  void _setUpTTS() async {
    //ustawienie jezyka na niemiecki
    await _tts.setLanguage('de');
    await _tts.setSpeechRate(0.6);
  }

  void _runTts({required String text}) async {
    await _tts.speak(text);
  }
}
