import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/widgets/image_widget/_image_web.dart';

import '../../models/gif_model.dart';
import 'cubit/gif_picker_cubit.dart';

class GifPicker extends StatelessWidget {
  const GifPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GifPickerCubit()..init(),
      child: BlocBuilder<GifPickerCubit, GifPickerState>(
        builder: (context, state) {
          if (!state.isResults) {
            if (state.status == ProcessStatus.loading) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state.status == ProcessStatus.failed) {
              return const Text("Error");
            } else if (state.status == ProcessStatus.loaded) {
              return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: MacosScaffold(
                      toolBar: ToolBar(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        automaticallyImplyLeading: false,
                        height: 45,
                        centerTitle: true,
                        title: const Text("Select Gif",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                        actions: [
                          ToolBarIconButton(
                            label: 'Close',
                            icon: const MacosIcon(
                              Icons.close,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            showLabel: false,
                            tooltipMessage: 'Close Dialog',
                          ),
                        ],
                      ),
                      children: [
                        ContentArea(
                          builder: (context, scrollController) => Material(
                            color: Colors.transparent,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: MacosTextField(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color:
                                            MacosTheme.of(context).canvasColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 1,
                                          color: MacosTheme.of(context)
                                              .dividerColor,
                                        )),
                                    placeholder: 'Search Gifs..',
                                    suffix: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        CupertinoIcons.search,
                                        size: 16,
                                      ),
                                    ),
                                    onSubmitted: (v) {
                                      BlocProvider.of<GifPickerCubit>(context)
                                          .search(v);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(children: [
                                    ...categories
                                        .map((e) => Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  BlocProvider.of<
                                                              GifPickerCubit>(
                                                          context)
                                                      .search(e['name']);
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        width: 1,
                                                        color: MacosTheme.of(
                                                                context)
                                                            .dividerColor,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        e['name'].toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: MacosTheme
                                                                      .brightnessOf(
                                                                          context) ==
                                                                  Brightness
                                                                      .dark
                                                              ? const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  228,
                                                                  228,
                                                                  232)
                                                              : const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  59,
                                                                  58,
                                                                  58),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            ))
                                        .toList()
                                  ]),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: StaggeredGrid.count(
                                    crossAxisCount: 3,

                                    mainAxisSpacing: 8.0,
                                    crossAxisSpacing:
                                        8.0, // I only need two card horizontally
                                    children: state.files.map((item) {
                                      return GifWidget(model: item);
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]));
            }
            return const Scaffold();
          } else {
            if (state.status == ProcessStatus.loading) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state.status == ProcessStatus.failed) {
              return const Center(child: Text('Error'));
            } else if (state.status == ProcessStatus.loaded) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: MacosScaffold(
                    toolBar: ToolBar(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      automaticallyImplyLeading: false,
                      height: 45,
                      centerTitle: true,
                      title: const Text("Select Gif",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          )),
                      actions: [
                        ToolBarIconButton(
                          label: 'Close',
                          icon: const MacosIcon(
                            Icons.close,
                          ),
                          onPressed: () =>
                              BlocProvider.of<GifPickerCubit>(context).back(),
                          showLabel: false,
                          tooltipMessage: 'Close Dialog',
                        ),
                      ],
                    ),
                    children: [
                      ContentArea(
                        builder: (context, scrollController) => Material(
                          color: Colors.transparent,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8, top: 16),
                              child: StaggeredGrid.count(
                                crossAxisCount: 3,

                                mainAxisSpacing: 6.0,
                                crossAxisSpacing:
                                    6.0, // I only need two card horizontally
                                children: state.results.map((item) {
                                  return GifWidget(model: item);
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),
              );
            }
            return const Scaffold();
          }
        },
      ),
    );
  }
}

class GifWidget extends StatelessWidget {
  final GifModel model;
  const GifWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, {
          "url": model.url,
          'previewUrl': model.previewUrl,
          'title': model.contentDescription!,
          "width": model.dims!.data![0]!,
          "height": model.dims!.data![1]!,
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: AspectRatio(
          aspectRatio: (model.dims!.data![0]!) / (model.dims!.data![1]!),
          child: Container(
            color: Colors.grey,
            width: MediaQuery.of(context).size.width * .5,
            child: ImageWidget(
              imgFile: model.previewUrl!,
            ),
          ),
        ),
      ),
    );
  }
}
