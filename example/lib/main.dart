import 'dart:convert';

import 'package:buck/buck.dart';
import 'package:buck/basic_app.dart';
import 'package:buck/utils/rsa_helper.dart';
import 'package:buck/login/login_page.dart';
import 'package:buck/model/user_info.dart';
import 'package:buck_example/menus/bundle_dialog.dart';
import 'package:buck_example/menus/bundle_form.dart';
import 'package:buck_example/menus/bundle_list.dart';
import 'package:buck_example/menus/bundle_loading.dart';
import 'package:buck_example/menus/bundle_scaffold.dart';
import 'package:buck_example/pianos/piano_album.dart';
import 'package:buck_example/pianos/piano_card.dart';
import 'package:buck_example/pianos/piano_collect.dart';
import 'package:buck_example/pianos/piano_earth.dart';
import 'package:buck_example/pianos/piano_expression.dart';
import 'package:buck_example/pianos/piano_setting.dart';
import 'package:flutter/material.dart';
import 'package:buck/widgets/tips/tips_tool.dart';

const BASE_URL = 'http://10.1.6.212:8001';
const APP_ID = 'COLLECTBLOOD';

const CONNECT_API = '/connect';
const LOGIN_API = '/authentication/authentication/login';
const LOGOUT_API = '/authentication/authentication/logout';
const VERSION_PATH_API = '/setting/app/latest_version';
const LIST_MESSAGE_API = '/admin/app/list_own';
const READ_MESSAGE_API = '/admin/app/read';

const LOGO_PATH = "assets/images/logo.png";
const HOME_TITLE = "BUCK";
const TITLE_LABEL = "BUCK";
const BACKGROUND_PATH = "assets/images/background.png";
const WELCOME_LABEL =
    "Albert Einstein: Logic will get you from A to B. Imagination will take you everywhere.";

Future<void> main() async {
  Buck buck = Buck.getInstance();
  await buck.init(
      baseUrl: BASE_URL,
      appId: APP_ID,
      connectTimeout: 20000,
      requestTimeout: 40000,
      menuFree: true);
  buck.settingCommonPath(
      connectApi: CONNECT_API,
      loginApi: LOGIN_API,
      logoutApi: LOGOUT_API,
      listMessageApi: LIST_MESSAGE_API,
      readMessageApi: READ_MESSAGE_API,
      versionApi: VERSION_PATH_API);

  buck.installMenus('Alpha', [
    BundleDialog(),
    BundleList(),
    BundleForm(key: Key('c-Deliver')),
    BundleLoading()
  ]);
  buck.installMenus('Bate', [BundleScaffold()]);
  buck.installPianos('Piano Group A', [PianoEarth()]);
  buck.installPianos('Piano Group B',
      [PianoCollect(), PianoAlbum(), PianoCard(), PianoExpression()]);
  buck.installPianos('Piano Group C', [PianoSetting()]);

  await RsaHelper.getInstance().init(
    clientPublicKeyPath: 'assets/rsa/public_key.pem',
    clientPrivateKeyPath: 'assets/rsa/private_key.pem',
  );

  Widget loginPage = LoginPage(
      backgroundPath: 'assets/images/background.png',
      logoPath: 'assets/images/logo.png',
      titleLabel: 'BUCK  🐺',
      welcomeLabel:
          'Old longings nomadic leap, Chafing at custom\'s chain; Again from its brumal sleep Wakens the ferine stain.',
      loginAction: customLoginAction);
  runApp(BasicApp(homeTitle: HOME_TITLE, loginPage: loginPage));
}

/// 假登录
Future<bool> Function(BuildContext context, String userName, String password)
    customLoginAction = (context, userName, password) async {
  String json = await DefaultAssetBundle.of(context)
      .loadString('data/response_data.json');
  Map<String, dynamic> responseData = jsonDecode(json);
  buck.cacheControl.setToken(responseData['token']);
  Map<String, dynamic> userMap = responseData['userView'];
  buck.cacheControl.setUserInfo(jsonEncode(userMap));

  /// 提取可访问的功能点
  Set<String> bundleIds = new Set();
  Map<String, dynamic> departmentServiceUserAuthorityViewMap =
      userMap['departmentServiceUserAuthorityViewMap'];
  if (departmentServiceUserAuthorityViewMap
      .containsKey(userMap['businessDepartmentUuid'])) {
    Map<String, dynamic> serviceUserAuthorityViewMap =
        departmentServiceUserAuthorityViewMap[
            userMap['businessDepartmentUuid']];
    String applicationName = buck.appId.toUpperCase();
    if (serviceUserAuthorityViewMap.containsKey(applicationName)) {
      List userAuthorityViewList = serviceUserAuthorityViewMap[applicationName];
      if (userAuthorityViewList != null) {
        bundleIds.addAll(userAuthorityViewList.map((item) => item['bundleId']));
      }
    }
  }
  userMap['bundleIds'] = bundleIds;

  buck.userInfo = UserInfo.fromMap(userMap);
  await buck.socketClient.connect();
  TipsTool.info('登录成功').show();
  Navigator.of(context).pop();
  return true;
};
