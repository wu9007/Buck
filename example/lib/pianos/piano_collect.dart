import 'package:buck/bundle/piano.dart';
import 'package:buck/constant/icon_constant.dart';
import 'package:flutter/material.dart';

class PianoCollect extends StatelessPiano {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(tag: id, child: leading),
        title: Text('collect'),
      ),
    );
  }

  @override
  Widget get leading => Icon(MyIcons.favor, color: Colors.redAccent[200]);

  @override
  String get id => 'collect';

  @override
  int get sort => 2;

  @override
  String get cnName => '收藏';

  @override
  bool get auth => false;
}
