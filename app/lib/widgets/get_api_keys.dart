import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/config.dart';

import '../services/hive_cache.dart';
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
  String apiKeyError = '';
  String apiSecretError = '';
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
                  "To get started, create a new project on the twitter developer portal and get your API Key and Secret to schedurio.",
                  style: TextStyle(
                    fontSize: 14.0,
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
                  "Need help? with twitter developer account?",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.blue,
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
                            LocalCache.currentUser.put(
                                AppConfig.hiveKeys.walkThrough, 'authenticate')
                          ]);

                          widget.onNext.call();
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
