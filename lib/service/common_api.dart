import 'package:flutter/material.dart';

/// @author wujianchuan
/// @date 2020/1/17 15:08
class CommonApi {
  static CommonApi _instance = CommonApi._();
  String _loginApi;
  String _logoutApi;
  String _connectApi;
  String _listMessageApi;
  String _readMessageApi;
  String _versionApi;

  CommonApi._();

  static CommonApi getInstance() {
    return _instance;
  }

  void setCommonPath({
    @required String connectApi,
    @required String loginApi,
    @required String logoutApi,
    @required String listMessageApi,
    @required String readMessageApi,
    @required String versionApi,
  }) {
    this._connectApi = connectApi;
    this._loginApi = loginApi;
    this._logoutApi = logoutApi;
    this._listMessageApi = listMessageApi;
    this._readMessageApi = readMessageApi;
    this._versionApi = versionApi;
  }

  String get versionApi => _versionApi;

  String get listMessageApi => _listMessageApi;

  String get readMessageApi => _readMessageApi;

  String get loginApi => _loginApi;

  String get logoutApi => _logoutApi;

  String get connectApi => _connectApi;
}
