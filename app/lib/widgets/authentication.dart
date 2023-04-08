// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

import '../animations/delayed_animation.dart';
import 'blurry_container.dart';

class Authenticate extends StatefulWidget {
  final Function onNext;
  const Authenticate({
    Key? key,
    required this.onNext,
  }) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
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
                'Nice!',
                textStyle: const TextStyle(
                  fontSize: 32.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FadeAnimatedText(
                'Let\'s Log you in!',
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
                      "Login to Twitter",
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
                  showMacosAlertDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (_) => MacosAlertDialog(
                      appIcon: const FlutterLogo(
                        size: 56,
                      ),
                      title: Text(
                        'Launching your default browser',
                        style: MacosTheme.of(context).typography.headline,
                      ),
                      message: Text(
                        'Please login to your Twitter account and copy the PIN code from the browser and paste it in the next screen.',
                        textAlign: TextAlign.center,
                        style: MacosTheme.of(context).typography.headline,
                      ),
                      primaryButton: PushButton(
                        buttonSize: ButtonSize.large,
                        child: const Text('Okay'),
                        onPressed: () {},
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
