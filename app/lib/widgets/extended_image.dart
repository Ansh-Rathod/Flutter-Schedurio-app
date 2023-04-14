// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:html' as html;
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final html.File? imgFile;
  const ImageWidget({
    Key? key,
    this.imgFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.file(
      imgFile! as File,
      fit: BoxFit.contain,
      mode: ExtendedImageMode.editor,
      enableLoadState: true,
      cacheRawData: true,
    );
  }
}
