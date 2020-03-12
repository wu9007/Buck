import 'package:flutter/services.dart';

class Formatter {
  static final BlacklistingTextInputFormatter singleLineFormatter =
      BlacklistingTextInputFormatter(RegExp(r'\n'));

  /// 整型
  static final WhitelistingTextInputFormatter digitsOnly =
      WhitelistingTextInputFormatter(RegExp(r'\d+'));

  /// 浮点型
  static final WhitelistingTextInputFormatter floatOnly =
      WhitelistingTextInputFormatter(RegExp('[0-9.]'));

  /// 浮点保留一位小数
  static final WhitelistingTextInputFormatter floatReg1 =
      WhitelistingTextInputFormatter(RegExp(r'^(\d+)(.\d{0,1})?'));

  /// 浮点保留两位小数
  static final WhitelistingTextInputFormatter floatReg2 =
      WhitelistingTextInputFormatter(RegExp(r'^(\d+)(.\d{0,2})?'));
}
