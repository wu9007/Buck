import 'package:buck/bundle/piano.dart';
import 'package:buck/constant/icon_constant.dart';
import 'package:buck_example/widgets/earth.dart';
import 'package:flutter/material.dart';

class PianoEarth extends StatelessPiano {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(tag: id, child: leading),
        title: Text('earth'),
      ),
      body: Earth(),
    );
  }

  @override
  Widget get leading => Icon(MyIcons.browser, color: Colors.green[400]);

  @override
  String get id => 'earth';

  @override
  int get sort => 1;

  @override
  String get cnName => '地图';

  @override
  bool get auth => false;
}
