import 'dart:convert';

import 'package:buck/basic_app.dart';
import 'package:buck/model/user_info.dart';
import 'package:buck/utils/dio_client.dart';
import 'package:buck/widgets/tips/tips_tool.dart';

class LoginClient {
  LoginClient._();

  static LoginClient _instance;

  static LoginClient getInstance() {
    if (_instance == null) {
      _instance = LoginClient._();
    }
    return _instance;
  }

  Future<bool> login(String userName, String password) async {
    Map<String, String> params = {'userName': userName, 'password': password, 'serialNo': buck.androidInfo.androidId};
    ResponseBody<Map<String, dynamic>> response = await DioClient<Map<String, dynamic>>().post(buck.commonApiInstance.loginApi, params: params);
    if (response.success) {
      Map<String, dynamic> userMap = response.data;
      buck.cacheControl.setUserInfo(jsonEncode(userMap));
      buck.userInfo = UserInfo.fromMap(userMap);
      await buck.socketClient.connect();
      TipsTool.info(response.message).show();
      return true;
    } else {
      TipsTool.warning(response.message).show();
    }
    return false;
  }

  void logOut() {
    buck.cacheControl.clear();
    buck.messageBox.clear();
    buck.userInfo = null;
    buck.socketClient.closeSocket();
    buck.navigatorKey.currentState.pushNamedAndRemoveUntil('loginPage', (route) => route == null);
  }
}
