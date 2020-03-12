import 'package:flutter/material.dart';

const List<Color> commonColors = [Colors.deepOrange, Colors.orange];

class ChromaticAppBar extends StatelessWidget {
  final double height;
  final String title;
  final List<Color> colors;

  ChromaticAppBar(this.title, {this.height = 200, this.colors = commonColors});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
            ),
          ),
          height: height,
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text(title,
              style: TextStyle(
                  fontFamily: 'pinshang', fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
