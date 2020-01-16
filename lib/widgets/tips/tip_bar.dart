import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TipBar {
  static SnackBar build(String message, {Color color}) {
    return SnackBar(
      content: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.notifications_active, color: Colors.white),
          ),
          Text(message, style: TextStyle(color: Colors.white))
        ],
      ),
      backgroundColor: color == null ? Colors.orangeAccent : color,
      duration: Duration(seconds: 1),
    );
  }
}
