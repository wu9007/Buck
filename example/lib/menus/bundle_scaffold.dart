import 'package:buck/bundle/menu.dart';
import 'package:buck/constant/icon_constant.dart';
import 'package:flutter/material.dart';
import 'package:buck/widgets/scaffold/chromatic_app_bar.dart';
import 'package:buck/widgets/scaffold/chromatic_scaffold.dart';
import 'package:flutter/cupertino.dart';

class BundleScaffold extends StatelessMenu {
  @override
  Widget build(BuildContext context) {
    return ChromaticScaffold(
      chromaticAppBar: ChromaticAppBar(
        'Chromatic Scaffold',
        height: 80,
        colors: [Colors.blue[600], Colors.blue[200]],
      ),
      body: Center(
        child: Text(''),
      ),
    );
  }

  @override
  Widget get icon => Icon(MyIcons.emoji, color: Colors.orangeAccent);

  @override
  String get id => 'scaffold';

  @override
  int get sort => 2;

  @override
  String get cnName => 'Scaffold';
}
