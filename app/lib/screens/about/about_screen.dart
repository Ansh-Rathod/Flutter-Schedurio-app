// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/config.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
        toolBar: ToolBar(
          height: 45,
          title: const Text(
            "About",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          titleWidth: 150.0,
          actions: [
            ToolBarIconButton(
              label: 'Toggle Sidebar',
              icon: const MacosIcon(
                CupertinoIcons.sidebar_left,
              ),
              onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
              showLabel: false,
              tooltipMessage: 'Toggle Sidebar',
            ),
          ],
        ),
        children: [
          ContentArea(builder: (context, scrollController) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: MacosTheme.brightnessOf(context) ==
                                Brightness.dark
                            ? Border.all(
                                color: const Color.fromARGB(255, 69, 69, 71))
                            : Border.all(
                                color:
                                    const Color.fromARGB(255, 225, 224, 224)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color:
                            MacosTheme.brightnessOf(context) != Brightness.dark
                                ? const Color(0xfff1f0f5)
                                : const Color(0xff2e2e2e),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "App Info",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text("Schedurio v${AppConfig.version}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                      color: MacosTheme.brightnessOf(context) ==
                                              Brightness.dark
                                          ? const Color(0xffa1a1a1)
                                          : const Color(0xff6f6f6f),
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const AboutListTile(
                            subtitle:
                                'Find more about the product on my website',
                            title: 'App Website',
                            url: AppConfig.schedurioWeb,
                          ),
                          const MacosPulldownMenuDivider(),
                          const AboutListTile(
                            subtitle:
                                'For latest news and updates follow us on twitter.',
                            title: 'Twitter',
                            url: AppConfig.twitter,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: MacosTheme.brightnessOf(context) ==
                                Brightness.dark
                            ? Border.all(
                                color: const Color.fromARGB(255, 69, 69, 71))
                            : Border.all(
                                color:
                                    const Color.fromARGB(255, 225, 224, 224)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color:
                            MacosTheme.brightnessOf(context) != Brightness.dark
                                ? const Color(0xfff1f0f5)
                                : const Color(0xff2e2e2e),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "About the Developer",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                    "The App is build by Ansh Rathod. A full-stack developer from India. building apps for every single platform using flutter."
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                      color: MacosTheme.brightnessOf(context) ==
                                              Brightness.dark
                                          ? const Color(0xffa1a1a1)
                                          : const Color(0xff6f6f6f),
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const AboutListTile(
                            subtitle: 'Find more about me on my website',
                            title: 'My Website',
                            url: AppConfig.myWebsite,
                          ),
                          const MacosPulldownMenuDivider(),
                          const AboutListTile(
                            subtitle:
                                'I am mostly active on Twitter. find out daily memes that i create.',
                            title: 'Twitter',
                            url: AppConfig.twitter,
                          ),
                          const MacosPulldownMenuDivider(),
                          const AboutListTile(
                            subtitle:
                                'Connect me here if you\'re interested in working with me.',
                            title: 'LinkedIn',
                            url: AppConfig.linkedIn,
                          ),
                          const MacosPulldownMenuDivider(),
                          const AboutListTile(
                            subtitle:
                                'Follow me on Github to see what i am working on.',
                            title: 'Github',
                            url: AppConfig.github,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: MacosTheme.brightnessOf(context) ==
                                Brightness.dark
                            ? Border.all(
                                color: const Color.fromARGB(255, 69, 69, 71))
                            : Border.all(
                                color:
                                    const Color.fromARGB(255, 225, 224, 224)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color:
                            MacosTheme.brightnessOf(context) != Brightness.dark
                                ? const Color(0xfff1f0f5)
                                : const Color(0xff2e2e2e),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Github Repository",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text("Yes We are open source :)",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        color:
                                            MacosTheme.brightnessOf(context) ==
                                                    Brightness.dark
                                                ? const Color(0xffa1a1a1)
                                                : const Color(0xff6f6f6f),
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const AboutListTile(
                              subtitle:
                                  'Join our discord server for feature requests and bug reports.',
                              title: 'Discord',
                              url: AppConfig.discordLink,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const AboutListTile(
                              subtitle:
                                  'Source Code for this app is available on Github',
                              title: 'Source code',
                              url: AppConfig.gitHubRepoUrl,
                            ),
                            const MacosPulldownMenuDivider(),
                            const AboutListTile(
                              subtitle:
                                  'If you find any bugs or have any suggestions, you can create an issue on Github.',
                              title: 'Issues',
                              url: AppConfig.issuesUrl,
                            ),
                            const MacosPulldownMenuDivider(),
                            const AboutListTile(
                              subtitle:
                                  'If you want to contribute to this project, you can do so by forking the repository and making a pull request.',
                              title: 'Contributing',
                              url: AppConfig.contributionUrl,
                            ),
                          ]),
                    ),
                  )
                ],
              ),
            );
          })
        ]);
  }
}

class AboutListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String url;
  const AboutListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(subtitle.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: MacosTheme.brightnessOf(context) == Brightness.dark
                          ? const Color(0xffa1a1a1)
                          : const Color(0xff6f6f6f),
                    )),
              ],
            ),
          ),
          MacosIconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded),
            onPressed: () async {
              launchUrlString(url);
            },
          )
        ],
      ),
    );
  }
}
