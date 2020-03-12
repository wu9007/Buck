/// @author wujianchuan
/// @date 2019/12/18 15:12
import 'package:flutter/material.dart';

class MenuBar extends StatelessWidget {
  final double radius;

  const MenuBar({Key key, this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: -radius * 2 / 3,
          left: -radius * 2 / 3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: Colors.redAccent[100],
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.red,
                  blurRadius: 17.0,
                ),
              ],
            ),
            height: radius * 2,
            width: radius * 2,
          ),
        ),
        Positioned.fill(
          top: 40,
          left: 40,
          child: Text("功  能",
              style: TextStyle(
                  fontFamily: 'pinshang',
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
        ),
//        AppBar(
//          backgroundColor: Colors.transparent,
//          elevation: 0.0,
//          title: Text("功  能", style: TextStyle(fontFamily: 'pinshang', fontWeight: FontWeight.bold)),
//        ),
      ],
    );
  }
}
