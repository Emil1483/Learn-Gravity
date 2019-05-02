import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ui_elements/custom_fab.dart';

class AboutRoute extends StatelessWidget {
  final List<String> skills = [
    "Use an API",
    "Use git",
    "Build beutiful UI in flutter",
    "Make stunning animations in flutter",
    "Handle errors in flutter",
    "Write general purpose code",
    "Use spritewidget to build games",
    "Build simulations based on real physics",
  ];

  @override
  Widget build(BuildContext context) {
    Widget headline = Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        "Why Does This App Exist?",
        style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w300),
        textAlign: TextAlign.center,
      ),
    );

    Widget body = Padding(
      padding: EdgeInsets.only(bottom: 24.0),
      child: Text(
        "This app is the 2nd app of my portfolio; If you need a flutter developer, send me an email! My portfolio apps are proof that I can:",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.grey.shade700,
        ),
        textAlign: TextAlign.center,
      ),
    );

    Widget bulletPoints = Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: skills.map((String skill) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
            margin: EdgeInsets.symmetric(vertical: 1.0),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(4.0)),
            child: Text(
              skill,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          );
        }).toList(),
      ),
    );

    Widget text = Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          headline,
          body,
          bulletPoints,
        ],
      ),
    );

    Widget fab = Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CustomFab(
          mainColor: Theme.of(context).accentColor,
          buttons: <Widget>[
            FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () async {
                final url = "mailto:emil14833@gmail.com";
                if (await canLaunch(url))
                  await launch(url);
                else
                  throw "Could not launch $url";
              },
              child: Icon(Icons.mail_outline),
            ),
          ],
        ),
      ),
    );

    return Stack(
      children: <Widget>[
        fab,
        text,
      ],
    );
  }
}
