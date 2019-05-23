import 'package:flutter/material.dart';

class PopupTab extends StatelessWidget {
  final String text;
  final String imgUrl;
  final EdgeInsetsGeometry padding;

  PopupTab({
    @required this.text,
    @required this.imgUrl,
    this.padding = const EdgeInsets.all(22.0),
  })  : assert(text != null),
        assert(imgUrl != null);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Container(
        padding: padding,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: textTheme.subtitle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.0),
            Container(
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(imgUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
