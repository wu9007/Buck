import 'package:flutter/material.dart';

/// @author wujianchuan
/// @date 2020/1/17 15:08
class CommonApi {
  static CommonApi _instance = CommonApi._();
  String _loginApi;
  String _listMessageApi;
  String _readMessageApi;
  String _versionApi;

  CommonApi._();

  static CommonApi getInstance() {
    return _instance;
  }

  void setCommonPath({@required String loginApi, @required String listMessageApi, @required String readMessageApi, @required String versionApi}) {
    this._loginApi = loginApi;
    this._listMessageApi = listMessageApi;
    this._readMessageApi = readMessageApi;
    this._versionApi = versionApi;
  }

  String get versionApi => _versionApi;

  String get listMessageApi => _listMessageApi;

  String get readMessageApi => _readMessageApi;

  String get loginApi => _loginApi;
}
