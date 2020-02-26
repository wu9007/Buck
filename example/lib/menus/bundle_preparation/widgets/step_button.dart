import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StepButton extends StatelessWidget {
  final StepButtonType stepButtonType;
  final Text text;
  final Color backgroundColor;
  final Icon icon;
  final GestureTapCallback onTap;
  final bool disabled;

  StepButton({Key key, this.stepButtonType, this.text, this.icon, this.onTap, this.backgroundColor, this.disabled = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius _borderRadius =
        stepButtonType == StepButtonType.next ? BorderRadius.horizontal(left: Radius.circular(50.0)) : BorderRadius.horizontal(right: Radius.circular(50.0));
    Widget _preIcon = icon != null && stepButtonType == StepButtonType.pre ? icon : Container();
    Widget _nexIcon = icon != null && stepButtonType == StepButtonType.next ? icon : Container();
    Widget _text = text ?? Container();
    Color _backgroundColor = !disabled ? (backgroundColor != null ? backgroundColor : Colors.lightBlue) : Colors.black38;
    GestureTapCallback _onTap = onTap != null && !disabled ? onTap : () {};
    return ClipRRect(
      borderRadius: _borderRadius,
      child: FlatButton(
        color: _backgroundColor,
        onPressed: _onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[_preIcon, _text, _nexIcon],
          ),
        ),
      ),
    );
  }
}

enum StepButtonType {
  next,
  pre,
}
