import 'package:buck/bundle/menu.dart';
import 'package:buck/bundle/menu_boss.dart';
import 'package:buck/bundle/piano.dart';
import 'package:buck/bundle/piano_boss.dart';
import 'package:buck/service/cache_control.dart';
import 'package:buck/service/message_box.dart';
import 'package:buck/service/theme_painter.dart';
import 'package:buck/service/version_control.dart';
import 'package:buck/message/notifier.dart';
import 'package:buck/message/socket_client.dart';
import 'package:buck/model/user_info.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

const bool inProduction = const bool.fromEnvironment("dart.vm.product");

class Buck {
  static Buck _instance;

  CacheControl _cacheControl;
  UserInfo userInfo;
  SocketClient _socketClient;
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  Notifier _notifier;
  MessageBox _messageBox;
  AndroidDeviceInfo _androidInfo;
  bool _menuFree;
  Map<String, WidgetBuilder> _routers = {};
  ThemePainter _themePainter;
  VersionControl _versionControl;
  PackageInfo _packageInfo;

  Buck._();

  static Buck getInstance() {
    WidgetsFlutterBinding.ensureInitialized();
    if (_instance == null) {
      _instance = Buck._();
    }
    return _instance;
  }

  Future init({@required String baseUrl, @required String wsUrl, bool menuFree = !inProduction}) async {
    _cacheControl = await CacheControl.getInstance();
    _socketClient = await SocketClient.getInstance();
    _versionControl = VersionControl.getInstance();
    _notifier = Notifier.getInstance();
    _messageBox = MessageBox.getInstance();
    _themePainter = ThemePainter.getInstance();
    _androidInfo = await DeviceInfoPlugin().androidInfo;
    _packageInfo = await PackageInfo.fromPlatform();
    _cacheControl.setVersion(_packageInfo.version);
    _menuFree = menuFree;
    userInfo = _cacheControl.userInfo;
    if (userInfo != null) {
      await _socketClient.connect();
    }
    _cacheControl.init(baseUrl: baseUrl, wsUrl: wsUrl);
    _notifier.init();
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

  CacheControl get cacheControl => _cacheControl;

  SocketClient get socketClient => _socketClient;

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  Notifier get notifier => _notifier;

  MessageBox get messageBox => _messageBox;

  AndroidDeviceInfo get androidInfo => _androidInfo;

  bool get menuFree => _menuFree;

  Map<String, WidgetBuilder> get routers => _routers;

  ThemePainter get themePainter => _themePainter;

  VersionControl get versionControl => _versionControl;

  PackageInfo get packageInfo => _packageInfo;
}
