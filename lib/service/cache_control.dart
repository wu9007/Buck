import 'dart:convert';

import 'package:buck/model/user_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

final PublishSubject<List<String>> shortcutSubject = PublishSubject<List<String>>();
final PublishSubject<String> themeSubject = PublishSubject<String>();

class CacheControl {
  static final String _tokenKey = '0';
  static final String _userInfoKey = '1';
  static final String _baseUrlKey = '2';
  static final String _wsUrlKey = '3';
  static final String _shortcutKey = '4';
  static final String _themeTypeKey = '5';
  static final String _appVersionKey = '6';

  static final CacheControl _instance = CacheControl._();
  static SharedPreferences _sp;

  CacheControl._();

  static Future<CacheControl> getInstance() async {
    _sp = await SharedPreferences.getInstance();
    return _instance;
  }

  Future init({@required String baseUrl, @required wsUrl}) async {
    _setBaseUrl(baseUrl);
    _setWsUrl(wsUrl);
  }

  void setToken(token) {
    _sp.setString(_tokenKey, token);
  }

  void clear() {
    _sp.setString(_tokenKey, null);
    _sp.setString(_userInfoKey, null);
  }

  String get token {
    return _sp.getString(_tokenKey) ?? '';
  }

  String get baseUrl {
    return _sp.getString(_baseUrlKey);
  }

  String get wsUrl {
    return _sp.getString(_wsUrlKey);
  }

  void setUserInfo(String userInfo) {
    _sp.setString(_userInfoKey, userInfo);
  }

  String get userInfoStr {
    return _sp.getString(_userInfoKey);
  }

  UserInfo get userInfo {
    if (userInfoStr == null) {
      return null;
    }
    return UserInfo.fromMap(jsonDecode(userInfoStr));
  }

  void _setBaseUrl(String baseUrl) {
    _sp.setString(_baseUrlKey, baseUrl);
  }

  void _setWsUrl(String wsUrl) {
    _sp.setString(_wsUrlKey, wsUrl);
  }

  List<String> get shortcutBundleIds {
    return _sp.getStringList(_shortcutKey) ?? [];
  }

  void operateShortcut(String bundleId) {
    List<String> bundleIdList = _sp.getStringList(_shortcutKey);
    if (bundleIdList == null) {
      bundleIdList = [];
    }
    if (!bundleIdList.contains(bundleId)) {
      bundleIdList.add(bundleId);
    } else {
      bundleIdList.remove(bundleId);
    }
    _sp.setStringList(_shortcutKey, bundleIdList);
    shortcutSubject.add(shortcutBundleIds);
  }

  void initThemeType(String themeType) {
    _sp.setString(_themeTypeKey, themeType);
  }

  void setThemeType(String themeType) {
    _sp.setString(_themeTypeKey, themeType);
    themeSubject.add(themeType);
  }

  String get themeType => _sp.get(_themeTypeKey);

  void setVersion(String latestVersion) {
    if (version == null) _sp.setString(_appVersionKey, latestVersion);
  }

  String get version => _sp.get(_appVersionKey);
}
