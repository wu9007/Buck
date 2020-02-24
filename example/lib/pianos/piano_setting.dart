import 'package:buck/bundle/piano.dart';
import 'package:buck/constant/icon_constant.dart';
import 'package:flutter/material.dart';

class PianoSetting extends StatelessPiano {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(tag: id, child: leading),
        title: Text('设置'),
      ),
    );
  }

  @override
  Widget get leading => Icon(MyIcons.setting, color: Colors.deepOrangeAccent[200]);

  @override
  String get id => 'setting';

  @override
  int get sort => 6;

  @override
  String get cnName => '设置';

  @override
  bool get auth => false;
}
