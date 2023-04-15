// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/widgets/blurry_container.dart';

import '../config.dart';
import '../services/hive_cache.dart';
import '../services/twitter_login/login.dart';

class GetAuthResult extends StatefulWidget {
  final Function onNext;

  const GetAuthResult({
    Key? key,
    required this.onNext,
  }) : super(key: key);

  @override
  State<GetAuthResult> createState() => _GetAuthResultState();
}

class _GetAuthResultState extends State<GetAuthResult> {
  final TextEditingController urlController = TextEditingController();
  String urlError = '';
  @override
  Widget build(BuildContext context) {
    return BlurryContainer(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: kElevationToShadow[2],
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Last Step!",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Enter the full url you were redirected to after authenticating with Twitter. the url must contain the oauth_token and oauth_verifier parameters.",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 20.0),
                const SizedBox(height: 20.0),
                const Text(
                  "Enter the redirected Url here:",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10.0),
                CupertinoTheme(
                  data: const CupertinoThemeData(brightness: Brightness.light),
                  child: CupertinoTextField(
                    controller: urlController,
                    placeholder: 'https://example.com?oauth_token=...',
                  ),
                ),
                if (urlError != '')
                  Text(
                    urlError,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.red,
                    ),
                  ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PushButton(
                      onPressed: () async {
                        if (urlController.text.length > 10) {
                          try {
                            final data = await TwitterLogin()
                                .getAuthResult(urlController.text);
                            if (data.status == TwitterLoginStatus.loggedIn) {
                              await Future.wait([
                                //  keeping auth tokens
                                LocalCache.twitterApi.put(
                                    AppConfig.hiveKeys.authToken,
                                    data.authToken),
                                LocalCache.twitterApi.put(
                                    AppConfig.hiveKeys.authSecretToken,
                                    data.authTokenSecret),
                                // keeping user data
                                // LocalCache.currentUser.put(
                                //     AppConfig.hiveKeys.username,
                                //     data.user!.screenName),
                                // LocalCache.currentUser.put(
                                //     AppConfig.hiveKeys.displayName,
                                //     data.user!.name),
                                // LocalCache.currentUser.put(
                                //     AppConfig.hiveKeys.profilePicture,
                                //     data.user!.thumbnailImage),
                                // LocalCache.currentUser.put(
                                //     AppConfig.hiveKeys.userId,
                                //     data.user!.id.toString()),
                                // LocalCache.currentUser.put(
                                //     AppConfig.hiveKeys.email, data.user!.email),

                                // keeping walk through status
                                LocalCache.currentUser.put(
                                    AppConfig.hiveKeys.walkThrough, 'tweets'),
                              ]);
                              widget.onNext.call();
                            } else {
                              throw Exception('error');
                            }
                          } catch (e) {
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
                                  style: MacosTheme.of(context)
                                      .typography
                                      .headline,
                                ),
                                message: Text(
                                  'Something went wrong while trying to authenticate with Twitter. Please try again.',
                                  textAlign: TextAlign.center,
                                  style: MacosTheme.of(context)
                                      .typography
                                      .headline,
                                ),
                                primaryButton: PushButton(
                                  buttonSize: ButtonSize.large,
                                  child: const Text('Try again?'),
                                  onPressed: () async {
                                    await LocalCache.currentUser.put(
                                        AppConfig.hiveKeys.walkThrough,
                                        'authenticate');
                                    widget.onNext.call();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            );
                          }
                        }
                      },
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      buttonSize: ButtonSize.small,
                      child: const Text("Next"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
