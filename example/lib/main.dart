import 'package:buck/buck.dart';
import 'package:buck/basic_app.dart';
import 'package:buck/utils/encrypt_helper.dart';
import 'package:buck_example/menus/bundle_deliver.dart';
import 'package:buck_example/menus/bundle_liquid_exchange/bundle_liquid_exchange.dart';
import 'package:buck_example/menus/bundle_preparation/bunlde_preparation.dart';
import 'package:buck_example/menus/bundle_rest.dart';
import 'package:buck_example/menus/bundle_service.dart';
import 'package:buck_example/menus/bundle_shopping.dart';
import 'package:buck_example/pianos/piano_album.dart';
import 'package:buck_example/pianos/piano_card.dart';
import 'package:buck_example/pianos/piano_collect.dart';
import 'package:buck_example/pianos/piano_earth.dart';
import 'package:buck_example/pianos/piano_expression.dart';
import 'package:buck_example/pianos/piano_setting.dart';
import 'package:flutter/material.dart';

const BASE_URL = 'http://192.168.1.3:8001';
//const BASE_URL = 'http://192.168.43.29:8001';

const CONNECT_API = '/connect';
const LOGIN_API = '/auth/guest/app_login';
const LIST_MESSAGE_API = '/notification/app/list_own';
const READ_MESSAGE_API = '/notification/app/read';
const VERSION_PATH_API = '/admin/app_version/latest';

const LOGO_PATH = "assets/images/logo.png";
const HOME_TITLE = "BUCK";
const TITLE_LABEL = "BUCK";
const BACKGROUND_PATH = "assets/images/background.png";
const WELCOME_LABEL = "Albert Einstein: Logic will get you from A to B. Imagination will take you everywhere.";

Future<void> main() async {
  Buck buck = Buck.getInstance();
  await buck.init(baseUrl: BASE_URL, connectTimeout: 20000, requestTimeout: 40000, menuFree: true);
  buck.settingCommonPath(connectApi: CONNECT_API, loginApi: LOGIN_API, listMessageApi: LIST_MESSAGE_API, readMessageApi: READ_MESSAGE_API, versionApi: VERSION_PATH_API);

  buck.installMenus('Alpha', [BundlePreparation(), BundleLiquidExchange()]);
  buck.installMenus('Beta', [BundleService(), BundleShopping()]);
  buck.installMenus('Gama', [BundleRest(), BundleDeliver(key: Key('c-Deliver')), BundleService(), BundleShopping()]);
  buck.installPianos('Piano Group A', [PianoEarth()]);
  buck.installPianos('Piano Group B', [PianoCollect(), PianoAlbum(), PianoCard(), PianoExpression()]);
  buck.installPianos('Piano Group C', [PianoSetting()]);

  await EncryptHelper.getInstance().init(
    clientPublicKeyPath: 'assets/rsa/public_key.pem',
    clientPrivateKeyPath: 'assets/rsa/private_key.pem',
  );
  runApp(BasicApp(homeTitle: HOME_TITLE));
}
