// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class ImageWidget extends StatelessWidget {
  final String imgFile;
  final double? width;
  final double? height;
  final BoxShape? shape;

  const ImageWidget({
    Key? key,
    required this.imgFile,
    this.width,
    this.height,
    this.shape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: ExtendedImage.network(
        imgFile,
        fit: BoxFit.cover,
        width: width,
        height: height,
        cache: true,
        loadStateChanged: (ExtendedImageState state) {
          if (state.extendedImageLoadState == LoadState.loading) {
            return Container(
              color: MacosTheme.of(context).dividerColor,
              child: const ProgressCircle(value: null),
            );
          }
          return null;
        },
        shape: shape,
      ),
    );
  }
}
