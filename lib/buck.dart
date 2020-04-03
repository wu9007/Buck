import 'dart:io';

import 'package:buck/bundle/menu.dart';
import 'package:buck/bundle/menu_boss.dart';
import 'package:buck/bundle/piano.dart';
import 'package:buck/bundle/piano_boss.dart';
import 'package:buck/service/cache_control.dart';
import 'package:buck/service/common_api.dart';
import 'package:buck/service/message_box.dart';
import 'package:buck/service/theme_painter.dart';
import 'package:buck/service/version_control.dart';
import 'package:buck/message/notifier.dart';
import 'package:buck/message/socket_client.dart';
import 'package:buck/model/user_info.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';

/// const bool inProduction = const bool.fromEnvironment("dart.vm.product");

class Buck {
  static Buck _instance;

  bool _menuFree;
  UserInfo userInfo;
  PackageInfo _packageInfo;
  AndroidDeviceInfo _androidInfo;
  Directory _documentsDir;
  Map<String, WidgetBuilder> _routers = {};
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  Notifier _notifierInstance;
  CommonApi _commonApiInstance;
  MessageBox _messageBoxInstance;
  CacheControl _cacheControlInstance;
  SocketClient _socketClientInstance;
  ThemePainter _themePainterInstance;
  VersionControl _versionControlInstance;

  Buck._();

  static Buck getInstance() {
    WidgetsFlutterBinding.ensureInitialized();
    if (_instance == null) {
      _instance = Buck._();
    }
    return _instance;
  }

  Future init(
      {@required String baseUrl,
      int wsPort,
      int connectTimeout,
      int requestTimeout,
      bool menuFree = false}) async {
    _notifierInstance = Notifier.getInstance();
    _commonApiInstance = CommonApi.getInstance();
    _messageBoxInstance = MessageBox.getInstance();
    _versionControlInstance = VersionControl.getInstance();
    _cacheControlInstance = await CacheControl.getInstance();
    _socketClientInstance = await SocketClient.getInstance();
    _themePainterInstance = ThemePainter.getInstance();
    _androidInfo = await DeviceInfoPlugin().androidInfo;
    _packageInfo = await PackageInfo.fromPlatform();
    _documentsDir = await getApplicationDocumentsDirectory();
    _cacheControlInstance.setVersion(_packageInfo.version);
    _menuFree = menuFree;
    userInfo = _cacheControlInstance.userInfo;
    if (userInfo != null) {
      await _socketClientInstance.connect();
    }
    _notifierInstance.init();
    _cacheControlInstance.init(baseUrl, wsPort);
    if (connectTimeout != null)
      _cacheControlInstance.setConnectTimeout(connectTimeout);
    if (requestTimeout != null)
      _cacheControlInstance.setReceiveTimeout(requestTimeout);
  }

  void settingCommonPath({
    @required String connectApi,
    @required String loginApi,
    @required String listMessageApi,
    @required String readMessageApi,
    @required String versionApi,
  }) {
    _commonApiInstance.setCommonPath(
      connectApi: connectApi,
      loginApi: loginApi,
      listMessageApi: listMessageApi,
      readMessageApi: readMessageApi,
      versionApi: versionApi,
    );
  }

  void installMenus(String groupName, List<Menu> menus) {
    menus.forEach((menu) {
      MenuBoss.register(groupName, menu);
      _routers.putIfAbsent(menu.id, () => (_) => menu);
    });
  }

  void installPianos(String groupName, List<Piano> pianos) {
    pianos.forEach((piano) {
      PianoBoss.register(groupName, piano);
      _routers.putIfAbsent(piano.id, () => (_) => piano);
    });
  }

  CacheControl get cacheControl => _cacheControlInstance;

  SocketClient get socketClient => _socketClientInstance;

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  Notifier get notifier => _notifierInstance;

  MessageBox get messageBox => _messageBoxInstance;

  AndroidDeviceInfo get androidInfo => _androidInfo;

  bool get menuFree => _menuFree;

  Map<String, WidgetBuilder> get routers => _routers;

  ThemePainter get themePainter => _themePainterInstance;

  VersionControl get versionControl => _versionControlInstance;

  PackageInfo get packageInfo => _packageInfo;

  CommonApi get commonApiInstance => _commonApiInstance;

  Directory get documentsDir => _documentsDir;
}
