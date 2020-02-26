import 'package:flutter/material.dart';

class StepTab extends StatelessWidget {
  final String text;
  final bool selected;
  final GestureTapCallback onTap;

  const StepTab({Key key, this.text, this.selected = false, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bottomBorderColor = selected ? Colors.deepOrange : Colors.transparent;
    Color textColor = selected ? Colors.black : Colors.black38;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 7),
        child: new InkWell(
          onTap: onTap,
          child: new Container(
            height: 40.0,
            decoration: new BoxDecoration(
              border: new Border(bottom: BorderSide(color: bottomBorderColor, width: 2.5)),
            ),
            child: new Center(
              child: new Text(
                text,
                style: new TextStyle(color: textColor, fontSize: 15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
