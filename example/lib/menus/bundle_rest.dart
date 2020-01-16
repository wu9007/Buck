import 'package:buck/bundle/menu.dart';
import 'package:buck/constant/icon_constant.dart';
import 'package:buck_example/earth.dart';
import 'package:flutter/material.dart';

class BundleRest extends StatelessMenu {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: icon,
        title: Text('rest', style: TextStyle(color: Colors.black, fontFamily: 'pinshang')),
      ),
      body: Earth(),
    );
  }

  @override
  Widget get icon => Icon(MyIcons.rest, color: Colors.teal);

  @override
  String get id => 'rest';

  @override
  int get sort => 1;

  @override
  String get cnName => 'rest';
}
