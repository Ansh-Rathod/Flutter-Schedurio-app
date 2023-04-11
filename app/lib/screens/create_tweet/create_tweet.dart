// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/create_tweet_widget.dart';
import '../../widgets/custom_pull_down_button.dart';
import '../../widgets/custom_push_button.dart';
import 'cubit/create_tweet_cubit.dart';

class CreateTweet extends StatelessWidget {
  const CreateTweet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateTweetCubit(),
      child: BlocBuilder<CreateTweetCubit, CreateTweetState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          ...state.tweets
                              .map((tweet) => CreateTweetWidget(
                                    controller: tweet['controller'],
                                    onAdd: BlocProvider.of<CreateTweetCubit>(
                                            context)
                                        .addNewTweet,
                                    onRemove: BlocProvider.of<CreateTweetCubit>(
                                            context)
                                        .removeTweet,
                                    onTextChanged:
                                        BlocProvider.of<CreateTweetCubit>(
                                                context)
                                            .updateTweet,
                                    tweet: tweet,
                                    tweets: state.tweets,
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomPushButton(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(7),
                            bottomLeft: Radius.circular(7),
                          ),
                          onPressed: () {},
                          buttonSize: CustomButtonSize.large,
                          child: const Text("Add To Queue")),
                      const CustomMacosPulldownButton(items: [
                        CustomMacosPulldownMenuItem(title: Text("Post now")),
                        CustomMacosPulldownMenuItem(
                            title: Text("Save as draft")),
                      ])
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
