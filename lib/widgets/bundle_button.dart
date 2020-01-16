import 'package:flutter/material.dart';

typedef void OnTap();

class BundleButton extends StatelessWidget {
  BundleButton.build({
    @required this.id,
    this.width = 100.0,
    this.height = 120.0,
    @required this.text,
    @required this.icon,
    this.backColor = Colors.white,
    @required this.onTap,
    this.onLongPress,
  });

  final double width;
  final double height;
  final String id;
  final Widget text;
  final Widget icon;
  final Color backColor;
  final OnTap onTap;
  final OnTap onLongPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Card(
          child: Column(
            children: <Widget>[
              Expanded(flex: 2, child: Center(child: icon)),
              Divider(height: 1),
              Expanded(flex: 1, child: Center(child: text)),
            ],
          ),
        ),
      ),
    );
  }
}
