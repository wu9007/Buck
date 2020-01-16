import 'package:flutter/services.dart';

class Formatter {
  static final BlacklistingTextInputFormatter singleLineFormatter = BlacklistingTextInputFormatter(RegExp(r'\n'));
  static final WhitelistingTextInputFormatter digitsOnly = WhitelistingTextInputFormatter(RegExp(r'\d+'));
  static final WhitelistingTextInputFormatter floatOnly = WhitelistingTextInputFormatter(RegExp('[0-9.]'));
}
