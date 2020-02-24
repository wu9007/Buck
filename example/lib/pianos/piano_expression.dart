import 'package:buck/bundle/piano.dart';
import 'package:buck/constant/icon_constant.dart';
import 'package:flutter/material.dart';

class PianoExpression extends StatelessPiano {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(tag: id, child: leading),
        title: Text('Expression'),
      ),
    );
  }

  @override
  Widget get leading => Icon(MyIcons.emoji, color: Colors.orange[400]);

  @override
  String get id => 'expression';

  @override
  int get sort => 5;

  @override
  String get cnName => '表情';

  @override
  bool get auth => false;
}
