import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/config.dart';
import 'package:twitter_api/twitter_api.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../services/hive_cache.dart';
import '../supabase.dart';
import 'blurry_container.dart';

class GetApiKeys extends StatefulWidget {
  final Function onNext;
  const GetApiKeys({
    Key? key,
    required this.onNext,
  }) : super(key: key);

  @override
  State<GetApiKeys> createState() => _GetApiKeysState();
}

class _GetApiKeysState extends State<GetApiKeys> {
  final TextEditingController apiKeyController = TextEditingController();
  final TextEditingController apiSecretController = TextEditingController();
  final TextEditingController authtokenController = TextEditingController();
  final TextEditingController authtokenSecretController =
      TextEditingController();
  String apiKeyError = '';
  String apiSecretError = '';
  String redirectURIError = '';

  bool isLoading = false;
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
                  "Get Started",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  "To get started, create a new project on the twitter developer portal and get these keys. follow our guide for help."
                      .toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "API Key",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10.0),
                CupertinoTheme(
                  data: const CupertinoThemeData(brightness: Brightness.light),
                  child: CupertinoTextField(
                    controller: apiKeyController,
                    placeholder: '******#*#*#**@*#*@*#@*#*@',
                    suffix: MacosIconButton(
                      hoverColor: Colors.grey.shade300,
                      onPressed: () {},
                      icon: const Icon(Icons.info_outline),
                    ),
                  ),
                ),
                if (apiKeyError != '')
                  Text(
                    apiKeyError,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.red,
                    ),
                  ),
                const SizedBox(height: 20.0),
                const Text(
                  "API Secret",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10.0),
                CupertinoTheme(
                  data: const CupertinoThemeData(brightness: Brightness.light),
                  child: CupertinoTextField(
                    controller: apiSecretController,
                    placeholder: '******#*#*#**@*#*@*#@*#*@',
                    suffix: MacosIconButton(
                      hoverColor: Colors.grey.shade300,
                      onPressed: () {},
                      icon: const Icon(Icons.info_outline),
                    ),
                  ),
                ),
                if (apiSecretError != '')
                  Text(
                    apiSecretError,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.red,
                    ),
                  ),
                const SizedBox(height: 20.0),
                const Text(
                  "Access token",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10.0),
                CupertinoTheme(
                  data: const CupertinoThemeData(brightness: Brightness.light),
                  child: CupertinoTextField(
                    controller: authtokenController,
                    placeholder: 'Access token',
                    suffix: MacosIconButton(
                      hoverColor: Colors.grey.shade300,
                      onPressed: () {},
                      icon: const Icon(Icons.info_outline),
                    ),
                  ),
                ),
                if (redirectURIError != '')
                  Text(
                    redirectURIError,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.red,
                    ),
                  ),
                const SizedBox(height: 20.0),
                const Text(
                  "Access token Secret",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10.0),
                CupertinoTheme(
                  data: const CupertinoThemeData(brightness: Brightness.light),
                  child: CupertinoTextField(
                    controller: authtokenSecretController,
                    placeholder: 'Access token Secret',
                    suffix: MacosIconButton(
                      hoverColor: Colors.grey.shade300,
                      onPressed: () {},
                      icon: const Icon(Icons.info_outline),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    launchUrlString(
                        'https://github.com/Ansh-Rathod/schedurio/blob/main/guide.md');
                  },
                  child: Text(
                    "Need help? with twitter developer account?".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PushButton(
                      onPressed: () async {
                        setState(() {
                          apiSecretError = '';
                          isLoading = true;
                          apiKeyError = '';
                        });
                        if (apiSecretController.text.length != 50 &&
                            apiKeyController.text.length != 25) {
                          setState(() {
                            apiKeyError = 'Invalid API Key';
                            apiSecretError = 'Invalid API Secret';
                          });
                        } else if (apiSecretController.text.length != 50) {
                          setState(() {
                            apiSecretError = 'Invalid API Secret';
                          });
                        } else if (apiKeyController.text.length != 25) {
                          setState(() {
                            apiKeyError = 'Invalid API Key';
                          });
                        } else {
                          await Future.wait([
                            LocalCache.twitterApi.put(AppConfig.hiveKeys.apiKey,
                                apiKeyController.text),
                            LocalCache.twitterApi.put(
                                AppConfig.hiveKeys.apiSecretKey,
                                apiSecretController.text),
                            LocalCache.twitterApi.put(
                                AppConfig.hiveKeys.authToken,
                                authtokenController.text),
                            LocalCache.twitterApi.put(
                                AppConfig.hiveKeys.authSecretToken,
                                authtokenSecretController.text),
                            LocalCache.currentUser.put(
                                AppConfig.hiveKeys.walkThrough,
                                'posting_schedule')
                          ]);
                          try {
                            final userData = await TwitterApi.getAuthUser(
                              apiKey: apiKeyController.text,
                              apiSecretKey: apiSecretController.text,
                              oauthToken: authtokenController.text,
                              tokenSecret: authtokenSecretController.text,
                            );
                            await Future.wait([
                              LocalCache.currentUser.put(
                                  AppConfig.hiveKeys.username,
                                  userData['data']['username']),
                              LocalCache.currentUser.put(
                                  AppConfig.hiveKeys.profilePicture,
                                  userData['data']['profile_image_url']),
                              LocalCache.currentUser.put(
                                  AppConfig.hiveKeys.displayName,
                                  userData['data']['name']),
                              LocalCache.currentUser.put(
                                  AppConfig.hiveKeys.userId,
                                  userData['data']['id']),
                              LocalCache.currentUser.put(
                                  AppConfig.hiveKeys.verified,
                                  userData['data']['verified'])
                            ]);

                            final supaData =
                                await supabase.from('info').insert({
                              "twitter": {
                                "apiKey": apiKeyController.text,
                                "oauthToken": authtokenController.text,
                                "apiSecretKey": apiSecretController.text,
                                "oauthTokenSecret":
                                    authtokenSecretController.text
                              }
                            }).select('id');
                            final currenUserSupabaseId =
                                supaData.map((e) => e['id']).toList().first;
                            //TODO: breackpoint
                            await LocalCache.currentUser.put(
                                AppConfig.hiveKeys.currenUserSupabaseId,
                                currenUserSupabaseId);
                            setState(() {
                              isLoading = false;
                            });
                            widget.onNext.call();
                          } catch (e) {
                            print(e);
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
                                  style: MacosTheme.of(context)
                                      .typography
                                      .headline,
                                ),
                                message: Text(
                                  'Something went wrong while trying to authenticate with Twitter. Please try again or check your keys? maybe.',
                                  textAlign: TextAlign.center,
                                  style: MacosTheme.of(context)
                                      .typography
                                      .headline,
                                ),
                                primaryButton: PushButton(
                                  buttonSize: ButtonSize.large,
                                  child: const Text('Try again?'),
                                  onPressed: () async {
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
                      child: isLoading
                          ? CupertinoActivityIndicator(
                              color: MacosTheme.brightnessOf(context) ==
                                      Brightness.dark
                                  ? const Color.fromARGB(255, 228, 228, 232)
                                  : const Color.fromARGB(255, 59, 58, 58),
                            )
                          : const Text("Next"),
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
