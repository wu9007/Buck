/// @author wujianchuan
/// @date 2019/12/18 15:12
import 'package:flutter/material.dart';

class PersonBar extends StatelessWidget {
  final double height;

  const PersonBar({Key key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            color: Colors.lightBlue,
            gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).cardColor
              ],
            ),
          ),
          height: height,
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text("个人中心",
              style: TextStyle(
                  fontFamily: 'pinshang',
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
      ],
    );
  }
}
