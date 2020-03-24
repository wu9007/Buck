import 'package:buck/bundle/menu.dart';
import 'package:buck/constant/icon_constant.dart';
import 'package:buck/widgets/loading/gradient_circular_progress_route.dart';
import 'package:flutter/material.dart';

class BundleLoading extends StatelessMenu {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: icon,
        title: Text('loading',
            style: TextStyle(color: Colors.black, fontFamily: 'pinshang')),
      ),
      body: WillPopScope(
        child: GradientCircularProgressRoute(
          colors: [Colors.yellow, Colors.orange],
          label: Container(
              child: Text('loading……',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      decoration: TextDecoration.none))),
        ),
        onWillPop: () => Future.value(true),
      ),
    );
  }

  @override
  Widget get icon => Icon(MyIcons.fill, color: Colors.green);

  @override
  String get id => 'loading';

  @override
  int get sort => 2;

  @override
  String get cnName => 'Loading';
}
