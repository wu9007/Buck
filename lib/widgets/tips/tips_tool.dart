import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// @author wujianchuan
/// @date 2019/12/28 16:16
enum TipType { INFO, WARNING, ERROR }

class TipsTool {
  final TipType _type;
  final String _message;

  TipsTool.info(String message)
      : this._type = TipType.INFO,
        this._message = message;

  TipsTool.warning(String message)
      : this._type = TipType.WARNING,
        this._message = message;

  TipsTool.error(String message)
      : this._type = TipType.ERROR,
        this._message = message;

  Future<bool> show() {
    Color textColor = _type == TipType.INFO ? Colors.black : _type == TipType.WARNING ? Colors.orange : Colors.red[600];
    return Fluttertoast.showToast(
        msg: _message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey[100],
        textColor: textColor,
        fontSize: 14.0);
  }
}
