// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedurio/config.dart';
import 'package:schedurio/services/hive_cache.dart';
import 'package:schedurio/widgets/blurry_container.dart';

import '../animations/delayed_animation.dart';

class AboutWalkThrough extends StatefulWidget {
  final Function onNext;
  const AboutWalkThrough({
    Key? key,
    required this.onNext,
  }) : super(key: key);

  @override
  State<AboutWalkThrough> createState() => _AboutWalkThroughState();
}

class _AboutWalkThroughState extends State<AboutWalkThrough> {
  bool showButton = false;
  @override
  Widget build(BuildContext context) {
    return BlurryContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedTextKit(
            animatedTexts: [
              FadeAnimatedText(
                'Hey!',
                textStyle: const TextStyle(
                  fontSize: 32.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FadeAnimatedText(
                'Welcome to Schedurio!',
                fadeInEnd: 0.8,
                fadeOutBegin: 0.9,
                textStyle: const TextStyle(
                  fontSize: 34.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FadeAnimatedText(
                'Simple, yet powerful scheduling app.',
                textAlign: TextAlign.center,
                textStyle: const TextStyle(
                  fontSize: 32.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FadeAnimatedText(
                'Made with 💙 by @Ansh-Rathod',
                textAlign: TextAlign.center,
                textStyle: const TextStyle(
                  fontSize: 32.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FadeAnimatedText(
                'Let\'s get started!',
                textAlign: TextAlign.center,
                textStyle: const TextStyle(
                  fontSize: 32.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            pause: const Duration(milliseconds: 500),
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
            isRepeatingAnimation: false,
            totalRepeatCount: 0,
            repeatForever: false,
            onFinished: () {
              setState(() {
                showButton = true;
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
          if (showButton)
            DelayedAnimation(
              slidingBeginOffset: const Offset(0, 1),
              delay: const Duration(milliseconds: 100),
              child: CupertinoButton.filled(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Get Started",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
                onPressed: () async {
                  // await LocalCache.currentUser
                  //     .put(AppConfig.hiveKeys.walkThrough, 'done');

                  widget.onNext.call();
                },
              ),
            ),
        ],
      ),
    );
  }
}
