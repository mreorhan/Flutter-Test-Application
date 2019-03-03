import 'package:flutter/material.dart';
class CustomCard extends StatelessWidget {
  CustomCard({
    @required this.title,
    @required this.onPress
  });

  final title;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          FlatButton(
            child: new Text(title),
            onPressed: this.onPress,
          ),
        ],
      )
    );
  }
}