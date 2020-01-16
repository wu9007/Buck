import 'package:buck/buck.dart';
import 'package:buck/service/cache_control.dart';
import 'package:buck/service/message_box.dart';
import 'package:buck/service/theme_painter.dart';
import 'package:buck/home/home_page.dart';
import 'package:buck/login/login_page.dart';
import 'package:buck/message/notifier.dart';
import 'package:buck/message/socket_client.dart';
import 'package:flutter/material.dart';
import 'package:pda_scanner/pda_lifecycle_mixin.dart';

Buck buck = Buck.getInstance();

class BasicApp extends StatefulWidget {
  final ThemeData theme;
  final String appTitle;
  final String homeTitle;
  final Map<String, WidgetBuilder> routers;
  final Widget loginPage;

  const BasicApp({
    Key key,
    this.theme,
    this.appTitle = '',
    @required this.homeTitle,
    this.routers = const <String, WidgetBuilder>{},
    this.loginPage,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BasicAppState();
}

class BasicAppState extends State<BasicApp> with PdaLifecycleMixin {
  Map<String, WidgetBuilder> _routers;
  Widget _loginPage;
  Widget _homePage;
  ThemeData _themeData;
  int _lastClickTime = 0;

  @override
  void initState() {
    super.initState();
    this._controlTheme();
    this._controlLoginPage();
    _homePage = HomePage(title: widget.homeTitle);
    _routers = {'loginPage': (_) => _loginPage, 'homePage': (_) => _homePage};
    _routers.addAll(widget.routers);
    _routers.addAll(buck.routers);

    themeSubject.listen((themeType) {
      ThemeData themeData = buck.themePainter.getThemeData(themeType);
      this.setState(() => _themeData = themeData);
    });
  }

  @override
  void dispose() {
    messageBoxSubject.close();
    socketMessageSubject.close();
    notifierSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _currentPage = buck.userInfo == null ? _loginPage : _homePage;
    return MaterialApp(
      navigatorKey: buck.navigatorKey,
      routes: _routers,
      title: widget.appTitle,
      theme: _themeData,
      home: WillPopScope(
        child: _currentPage,
        onWillPop: _doubleExit,
      ),
    );
  }

  _controlTheme() {
    String _currentThemeType = buck.cacheControl.themeType;
    if (_currentThemeType != null) {
      _themeData = buck.themePainter.getThemeData(_currentThemeType);
    } else {
      if (widget.theme == null) {
        buck.cacheControl.initThemeType(ThemeType.light);
        _themeData = buck.themePainter.getThemeData(ThemeType.light);
      } else {
        _themeData = widget.theme;
        buck.themePainter.add(_themeData);
      }
    }
  }

  _controlLoginPage() {
    if (widget.loginPage == null) {
      _loginPage = LoginPage(
          backgroundPath: 'assets/images/background.png',
          logoPath: 'assets/images/logo.png',
          titleLabel: 'Basic Engine',
          welcomeLabel: 'Albert Einstein: Logic will get you from A to B. Imagination will take you everywhere.');
    } else {
      _loginPage = widget.loginPage;
    }
  }

  Future<bool> _doubleExit() {
    int nowTime = new DateTime.now().microsecondsSinceEpoch;
    if (_lastClickTime != 0 && nowTime - _lastClickTime > 500) {
      return new Future.value(true);
    } else {
      _lastClickTime = new DateTime.now().microsecondsSinceEpoch;
      new Future.delayed(const Duration(milliseconds: 500), () {
        _lastClickTime = 0;
      });
      return new Future.value(false);
    }
  }
}
