import 'dart:convert';

import 'package:buck/model/user_info.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

final PublishSubject<List<String>> shortcutSubject =
    PublishSubject<List<String>>();
final PublishSubject<String> themeSubject = PublishSubject<String>();

class CacheControl {
  static final String _tokenKey = '0';
  static final String _userInfoKey = '1';

  /// The server address built into the program.
  static final String _baseUrlKey = '2';
  static final String _shortcutKey = '3';
  static final String _themeTypeKey = '4';
  static final String _appVersionKey = '5';

  /// The address of the server currently in use by the app.
  static final String _customBaseUrlsKey = '6';

  /// User-defined list of server addresses.
  static final String _allBaseUrlKey = '7';
  static final String _connectTimeoutKey = '8';
  static final String _receiveTimeoutKey = '9';

  static final String _wsPortKey = '10';

  static final CacheControl _instance = CacheControl._();
  static SharedPreferences _sp;

  CacheControl._();

  static Future<CacheControl> getInstance() async {
    _sp = await SharedPreferences.getInstance();
    return _instance;
  }

  Future init(String baseUrl, String wsPort) async {
    _setBaseUrl(baseUrl);
    _setWsPort(wsPort);
  }

  void setToken(token) => _sp.setString(_tokenKey, token);

  void recycleAuth() {
    _sp.setString(_tokenKey, null);
    _sp.setString(_userInfoKey, null);
  }

  String get token => _sp.getString(_tokenKey) ?? '';

  void _setBaseUrl(String baseUrl) => _sp.setString(_baseUrlKey, baseUrl);

  String get baseUrl => _sp.getString(_baseUrlKey);

  void _setWsPort(String wsPort) => _sp.setString(_wsPortKey, wsPort);

  String get wsPort => _sp.getString(_wsPortKey);

  void setUserInfo(String userInfo) => _sp.setString(_userInfoKey, userInfo);

  String get userInfoStr => _sp.getString(_userInfoKey);

  UserInfo get userInfo {
    if (userInfoStr == null) {
      return null;
    }
    return UserInfo.fromMap(jsonDecode(userInfoStr));
  }

  List<String> get shortcutBundleIds => _sp.getStringList(_shortcutKey) ?? [];

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

  void initThemeType(String themeType) =>
      _sp.setString(_themeTypeKey, themeType);

  void setThemeType(String themeType) {
    _sp.setString(_themeTypeKey, themeType);
    themeSubject.add(themeType);
  }

  String get themeType => _sp.get(_themeTypeKey);

  void setVersion(String latestVersion) {
    if (version == null) _sp.setString(_appVersionKey, latestVersion);
  }

  String get version => _sp.get(_appVersionKey);

  void setActiveBaseUrl(String activeBaseUrl) =>
      _sp.setString(_customBaseUrlsKey, activeBaseUrl);

  String get activeBaseUrl => _sp.get(_customBaseUrlsKey);

  void setCustomBaseUrls(String customBaseUrls) =>
      _sp.setString(_allBaseUrlKey, customBaseUrls);

  String get customBaseUrls => _sp.get(_allBaseUrlKey);

  void setConnectTimeout(int connectTimeout) =>
      _sp.setInt(_connectTimeoutKey, connectTimeout);

  int get connectTimeout => _sp.getInt(_connectTimeoutKey);

  void setReceiveTimeout(int receiveTimeout) =>
      _sp.setInt(_receiveTimeoutKey, receiveTimeout);

  int get receiveTimeout => _sp.getInt(_receiveTimeoutKey);
}
