import 'package:flutter/material.dart';

import '../widgets/markdown_builder.dart';

class HomePage extends StatelessWidget {
  final _topics = [
    'Basics',
    'Built-in Types',
    'Functions',
    'Control Flow Statements',
    'Classes',
    'Extension Method',
    'Null Safety',
  ];

  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    //var height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final appBar = AppBar(
      backgroundColor: Color(0xff121A26),
      title: Text('Dart'),
      leading: (width > 700)
          ? const Padding(
              padding: EdgeInsets.only(
                // left: 16.0,
                top: 16.0,
                bottom: 16.0,
              ),
              child: ClipOval(
                child: Image(
                  image: AssetImage('assets/images/dart.png'),
                ),
              ),
            )
          : null,
      elevation: 0.0,
    );
    final appBarHeight = appBar.preferredSize.height;
    return Scaffold(
        appBar: appBar,
        drawer: (width <= 700)
            ? buildMenu(width * 0.4, appBarHeight, context)
            : null,
        body: Row(
          children: [
            if (width > 700) buildMenu(width * 0.2, 0.0, context),
            if (width > 700)
              VerticalDivider(
                thickness: 5,
                color: Color(0xff121A26),
              ),
            Expanded(
              child: PageView(
                  scrollDirection: Axis.vertical,
                  pageSnapping: false,
                  controller: controller,
                  children: List.generate(_topics.length, (index) {
                    return Container(
                      width: double.infinity,
                      height: double.maxFinite,
                      child: MarkdownBuilder(
                        index: index,
                      ),
                    );
                  })),
            ),
          ],
        ));
  }

  Container buildMenu(double width, double appBarWidth, BuildContext context) {
    return Container(
      color: Colors.white,
      width: width,
      height: double.maxFinite,
      margin: EdgeInsets.only(
        top: appBarWidth,
      ),
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          thickness: 1.0,
          color: Color(0xff121A26),
        ),
        itemCount: _topics.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(
            _topics[index],
            style: Theme.of(context).textTheme.headline1,
          ),
          contentPadding: EdgeInsets.all(5),
          onTap: () => _scrollToIndex(index),
        ),
        padding: const EdgeInsets.only(
          top: 8.0,
          right: 2.0,
          left: 2.0,
        ),
      ),
    );
  }

  void _scrollToIndex(int index) {
    controller.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.linear);
  }
}
