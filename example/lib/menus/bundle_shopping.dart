import 'package:buck/bundle/menu.dart';
import 'package:buck/constant/icon_constant.dart';
import 'package:flutter/material.dart';

class BundleShopping extends StatelessMenu {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: icon,
        title: Text('shopping', style: TextStyle(color: Colors.black, fontFamily: 'pinshang')),
      ),
    );
  }

  @override
  Widget get icon => Icon(MyIcons.shopping, color: Colors.pink);

  @override
  String get id => 'shopping';

  @override
  int get sort => 4;

  @override
  String get cnName => 'shopping';
}
