// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

import '../data/heatmap_color.dart';

class HeatMapContainer extends StatelessWidget {
  final DateTime date;
  final int number;
  final double? size;
  final double? fontSize;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;
  final EdgeInsets? margin;
  final bool? showText;
  final Function(DateTime dateTime)? onClick;

  const HeatMapContainer({
    Key? key,
    required this.date,
    required this.number,
    this.size,
    this.fontSize,
    this.borderRadius,
    this.backgroundColor,
    this.selectedColor,
    this.textColor,
    this.margin,
    this.showText,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: margin ?? const EdgeInsets.all(2),
        child: MacosTooltip(
          message: number == 0
              ? "no tweets"
              : number == 1
                  ? "1 Tweet"
                  : "$number Tweets",
          child: InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor ?? Color.fromARGB(255, 73, 97, 121),
                borderRadius:
                    BorderRadius.all(Radius.circular(borderRadius ?? 5)),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOutQuad,
                width: size,
                height: size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius:
                      BorderRadius.all(Radius.circular(borderRadius ?? 5)),
                ),
                child: (showText! && number != 0)
                    ? Text(
                        number.toString(),
                        style: TextStyle(
                            color: textColor ?? const Color(0xFF8A8A8A),
                            fontSize: fontSize),
                      )
                    : null,
              ),
            ),
            onTap: () {
              onClick != null ? onClick!(date) : null;
            },
          ),
        ),
      ),
    );
  }
}
