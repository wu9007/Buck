import 'package:buck/bundle/piano.dart';
import 'package:buck/constant/icon_constant.dart';
import 'package:flutter/material.dart';

class PianoPay extends StatelessPiano {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(tag: id, child: leading),
        title: Text('pay'),
      ),
    );
  }

  @override
  Widget get leading => Icon(MyIcons.roundCheck, color: Colors.green[400]);

  @override
  String get id => 'pay';

  @override
  int get sort => 1;

  @override
  String get cnName => '支付';

  @override
  bool get auth => false;
}
