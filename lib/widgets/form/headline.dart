import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Headline extends StatelessWidget {
  final String text;

  Headline(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      color: Colors.black12,
      child: Row(
        children: <Widget>[
          Container(
            width: 6,
            height: 20,
            margin: EdgeInsets.symmetric(horizontal: 3),
            color: Colors.orange,
          ),
          Text(text, style: TextStyle(fontSize: 16, fontFamily: 'pinshang', fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
