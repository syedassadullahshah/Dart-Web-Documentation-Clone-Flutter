import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../data/content.dart';

class MarkdownBuilder extends StatelessWidget {
  final index;
  const MarkdownBuilder({
    this.index,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: content[index],
      styleSheet: MarkdownStyleSheet(
        textAlign: WrapAlignment.spaceBetween,
        h2: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        h1: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        blockSpacing: 20.0,
        p: TextStyle(
          fontSize: 16,
        ),
        code: TextStyle(
          fontSize: 12,
          letterSpacing: 0.5,
          wordSpacing: 0.5,
          height: 1.5,
          color: Color(0xff12202F),
        ),
      ),
    );
  }
}
