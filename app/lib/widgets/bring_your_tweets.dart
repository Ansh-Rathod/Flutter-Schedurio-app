// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/config.dart';
import 'package:schedurio/services/hive_cache.dart';
import 'package:schedurio/widgets/blurry_container.dart';

import '../animations/delayed_animation.dart';

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
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlurryContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedTextKit(
            animatedTexts: [
              FadeAnimatedText(
                'Hurray! 🎉 ${LocalCache.currentUser.get(AppConfig.hiveKeys.displayName)}!',
                textStyle: const TextStyle(
                  fontSize: 32.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FadeAnimatedText(
                'Let\'s get your old tweets.',
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
                child: isLoading
                    ? CupertinoActivityIndicator(
                        color:
                            MacosTheme.brightnessOf(context) == Brightness.dark
                                ? const Color.fromARGB(255, 228, 228, 232)
                                : const Color.fromARGB(255, 59, 58, 58),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            "Proceed",
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
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    // var pageinationToken;
                    // for (var i = 0; i < 2; i++) {
                    //   final tweets = await TwitterApi.getTweets(
                    //     apiKey: LocalCache.twitterApi
                    //         .get(AppConfig.hiveKeys.apiKey),
                    //     apiSecretKey: LocalCache.twitterApi
                    //         .get(AppConfig.hiveKeys.apiSecretKey),
                    //     oauthToken: LocalCache.twitterApi
                    //         .get(AppConfig.hiveKeys.authToken),
                    //     tokenSecret: LocalCache.twitterApi
                    //         .get(AppConfig.hiveKeys.authSecretToken),
                    //     userId: LocalCache.currentUser
                    //         .get(AppConfig.hiveKeys.userId),
                    //     pageinationToken: pageinationToken,
                    //   );
                    //   if (tweets['meta'].containsKey('next_token')) {
                    //     pageinationToken = tweets['meta']['next_token'];
                    //   } else {
                    //     break;
                    //   }
                    //   final tweetModels =
                    //       ConvertTwitterResponse.toTweetModel(tweets);
                    //   for (var tweet in tweetModels) {
                    //     // await supabase.from('tweets').insert(tweet.toJson());
                    //     await LocalCache.tweets.put(tweet.id, tweet.toJson());
                    //   }
                    // }

                    setState(() {
                      isLoading = false;
                    });
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    if (!context.mounted) return;
                    showMacosAlertDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (_) => MacosAlertDialog(
                        appIcon: const FlutterLogo(
                          size: 56,
                        ),
                        title: Text(
                          'Something went wrong!',
                          style: MacosTheme.of(context).typography.headline,
                        ),
                        message: Text(
                          'Something went wrong while Getting your tweets.',
                          textAlign: TextAlign.center,
                          style: MacosTheme.of(context).typography.headline,
                        ),
                        primaryButton: PushButton(
                          buttonSize: ButtonSize.large,
                          child: const Text('Try again?'),
                          onPressed: () async {
                            await LocalCache.currentUser.put(
                                AppConfig.hiveKeys.walkThrough, 'authenticate');
                            widget.onNext.call();
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    );
                  }
                  await LocalCache.currentUser
                      .put(AppConfig.hiveKeys.walkThrough, 'posting_schedule');
                  widget.onNext();
                },
              ),
            ),
        ],
      ),
    );
  }
}
