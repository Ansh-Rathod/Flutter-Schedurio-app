// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class ExpandablePanel extends StatefulWidget {
  final String heading;
  final Widget child;
  const ExpandablePanel({
    Key? key,
    required this.heading,
    required this.child,
  }) : super(key: key);

  @override
  State<ExpandablePanel> createState() => _ExpandablePanelState();
}

class _ExpandablePanelState extends State<ExpandablePanel> {
  bool showWidget = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: MacosTheme.of(context).dividerColor, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                showWidget = !showWidget;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.heading,
                  style: TextStyle(
                    fontSize: 14,
                    color: MacosTheme.brightnessOf(context) == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  !showWidget ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                  size: 26,
                ),
              ],
            ),
          ),
          if (showWidget) widget.child,
        ],
      ),
    );
  }
}
