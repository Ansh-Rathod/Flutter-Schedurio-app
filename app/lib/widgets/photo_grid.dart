import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:schedurio_utils/schedurio_utils.dart';

class PhotoGrid extends StatelessWidget {
  final int maxImages;
  final bool isFile;
  final List<Media> imageUrls;
  final Function(int) onImageClicked;
  final Function onExpandClicked;
  const PhotoGrid({
    Key? key,
    required this.maxImages,
    required this.isFile,
    required this.imageUrls,
    required this.onImageClicked,
    required this.onExpandClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var images = buildImages();

    return SafeArea(
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
              width: 0.3,
            ),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: images.length != 1
                  ? GridView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: images.length == 3
                              ? 3
                              : images.length == 2
                                  ? 2
                                  : images.length == 1
                                      ? 1
                                      : 4,
                          crossAxisSpacing: 3,
                          // childAspectRatio: 16 / 9,
                          mainAxisExtent: images.length == 1 ? 250 : 200
                          // mainAxisSpacing: 2,
                          ),
                      children: images,
                    )
                  : GestureDetector(
                      onTap: () {
                        onImageClicked(0);
                      },
                      child: AspectRatio(
                        aspectRatio:
                            (imageUrls[0].width / imageUrls[0].height > 0.80)
                                ? imageUrls[0].width / imageUrls[0].height
                                : 1,
                        child: Container(
                          color: Colors.grey,
                          child: ExtendedImage.network(
                            imageUrls[0].url,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ))),
    );
  }

  List<Widget> buildImages() {
    int numImages = imageUrls.length;
    return List<Widget>.generate(min(numImages, maxImages), (index) {
      // If its the last image
      if (index == maxImages - 1) {
        // Check how many more images are left
        int remaining = numImages - maxImages;
        // If no more are remaining return a simple image widget
        if (remaining == 0) {
          return Container(
            color: Colors.grey,
            child: GestureDetector(
              child: ExtendedImage.network(
                imageUrls[index].url,
                fit: BoxFit.cover,
              ),
              onTap: () => onImageClicked(index),
            ),
          );
        } else {
          // Create the facebook like effect for the last image with number of remaining  images
          return Container(
            color: Colors.grey,
            child: GestureDetector(
              onTap: () => onExpandClicked(),
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  ExtendedImage.network(
                    imageUrls[index].url,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.black54,
                      child: Text(
                        '+$remaining',
                        style:
                            const TextStyle(fontSize: 32, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      } else {
        return Container(
          color: Colors.grey,
          child: GestureDetector(
            child: ExtendedImage.network(
              imageUrls[index].url,
              fit: BoxFit.cover,
            ),
            onTap: () => onImageClicked(index),
          ),
        );
      }
    });
  }
}
