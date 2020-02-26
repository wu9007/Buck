import 'package:buck/widgets/scaffold/chromatic_app_bar.dart';
import 'package:flutter/material.dart';

class ChromaticScaffold extends StatelessWidget {
  final ChromaticAppBar chromaticAppBar;
  final Widget body;
  final Color backgroundColor;
  final List<Widget> stackChildren;
  final double marginTop;

  ChromaticScaffold({
    @required this.chromaticAppBar,
    @required this.body,
    this.backgroundColor,
    this.stackChildren = const <Widget>[],
    this.marginTop = 110,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          chromaticAppBar,
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(top: marginTop),
              child: body,
            ),
          ),
          Stack(children: stackChildren),
        ],
      ),
    );
  }
}
