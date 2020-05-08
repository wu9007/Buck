import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SyncButton extends StatefulWidget {
  final Widget child;
  final Color textColor;
  final Color color;
  final VoidCallback onPressed;
  final SyncButtonController controller;
  final Color disabledTextColor;
  final Color disabledColor;

  SyncButton({
    Key key,
    @required this.onPressed,
    this.child,
    this.textColor,
    this.color,
    this.controller,
    this.disabledTextColor,
    this.disabledColor = Colors.black26,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SyncButtonState();
}

class SyncButtonState extends State<SyncButton> {
  bool _enable = true;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) widget.controller._syncButtonState = this;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: widget.child,
      textColor: widget.textColor,
      color: widget.color,
      onPressed: _enable ? widget.onPressed : null,
      disabledTextColor: widget.disabledTextColor,
      disabledColor: widget.disabledColor,
    );
  }

  _setEnable(bool enable) {
    this.setState(() => this._enable = enable);
  }
}

class SyncButtonController {
  SyncButtonState _syncButtonState;

  enable() {
    _syncButtonState._setEnable(true);
  }

  disable() {
    _syncButtonState._setEnable(false);
  }
}
