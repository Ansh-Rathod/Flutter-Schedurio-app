import 'package:flutter/material.dart';
import '../util/date_util.dart';

class HeatMapWeekText extends StatelessWidget {
  /// The margin value for correctly space between labels.
  final EdgeInsets? margin;

  /// The double value of label's font size.
  final double? fontSize;

  /// The double value of every block's size to fit the height.
  final double? size;

  /// The color value of every font's color.
  final Color? fontColor;

  const HeatMapWeekText({
    Key? key,
    this.margin,
    this.fontSize,
    this.size,
    this.fontColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (String label in DateUtil.WEEK_LABEL)
          Container(
            height: size ?? 20,
            margin: margin ??
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2),
            child: Text(
              label.toUpperCase(),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: fontSize ?? 10,
                color: fontColor,
              ),
            ),
          ),
      ],
    );
  }
}
