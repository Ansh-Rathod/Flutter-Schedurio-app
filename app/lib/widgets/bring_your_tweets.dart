// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedurio/widgets/blurry_container.dart';

import '../animations/delayed_animation.dart';
import '../apis/get_tweets.dart';

class GetTweetsWidget extends StatefulWidget {
  final Function onNext;
  const GetTweetsWidget({
    Key? key,
    required this.onNext,
  }) : super(key: key);

  @override
  State<GetTweetsWidget> createState() => _GetTweetsWidgetState();
}

class _GetTweetsWidgetState extends State<GetTweetsWidget> {
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
                'Hurray! 🎉',
                textStyle: const TextStyle(
                  fontSize: 32.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FadeAnimatedText(
                'Let\'s bring your old tweets!',
                fadeInEnd: 0.8,
                fadeOutBegin: 0.9,
                textStyle: const TextStyle(
                  fontSize: 34.0,
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
                      "Get my old tweets",
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
                  for (var i = 0; i < 4; i++) {
                    final tweets = await GetTweets.fromServer(i);
                  }
                  widget.onNext();
                },
              ),
            ),
        ],
      ),
    );
  }
}
