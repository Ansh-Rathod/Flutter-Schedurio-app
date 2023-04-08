// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';

class BlurryContainer extends StatelessWidget {
  final Widget child;
  const BlurryContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Blob.animatedRandom(
            size: 500,
            styles: BlobStyles(
                color: Colors.blue,
                gradient: RadialGradient(colors: [
                  Colors.yellow,
                  Colors.blue.shade300,
                  Colors.green,
                  Colors.yellow,
                  Colors.blue.shade200,
                ]).createShader(Rect.fromCenter(
                    center: const Offset(250, 250), width: 500, height: 500))),
            edgesCount: 5,
            loop: true,
            minGrowth: 2,
            duration: const Duration(milliseconds: 1000),
          ),
          Container(
              color: Colors.white.withOpacity(0.3),
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 80.0),
                  child: child))
        ],
      ),
    );
  }
}
