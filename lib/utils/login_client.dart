import 'dart:convert';
import 'package:buck/basic_app.dart';
import 'package:buck/model/user_info.dart';
import 'package:buck/utils/dio_client.dart';
import 'package:buck/utils/rsa_helper.dart';
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

  Future<bool> checkUrl() async {
    String baseUrl = buck.cacheControl.baseUrl;
    String customBaseUrls = buck.cacheControl.customBaseUrls;
    String activeUrl = buck.cacheControl.activeBaseUrl;
    if (activeUrl == null) {
      activeUrl = baseUrl;
      buck.cacheControl.setActiveBaseUrl(activeUrl);
    }

    /// 测试当前使用的服务器地址是否通畅
    Map<String, dynamic> queryParameters = {
      'clientName': buck.appId,
      'publicKey': RsaHelper.getInstance().clientPublicKeyString
    };
    ResponseBody responseBody = await DioClient().post(
        buck.commonApiInstance.connectApi,
        queryParameters: queryParameters);

    /// 如果通畅，直接返回
    if (responseBody == null) {
      /// 当前使用的不通畅的地址如果不是系统内置的地址
      if (activeUrl != baseUrl) {
        /// 测试系统内置服务器地址是否通畅，如果通畅则将使用地址设置为系统内置地址并返回
        responseBody = await DioClient().post(buck.commonApiInstance.connectApi,
            queryParameters: queryParameters, customBaseUrl: baseUrl);
        if (responseBody != null) {
          buck.cacheControl.setActiveBaseUrl(baseUrl);
          RsaHelper.getInstance().setBackendPublicKey(
              '-----BEGIN PUBLIC KEY-----\n' +
                  responseBody.data +
                  '\n-----END PUBLIC KEY-----');
          return true;
        }
      }

      /// 测试自定义添加的地址
      if (customBaseUrls != null) {
        List<String> customBaseUrlList = customBaseUrls.split(',');
        for (var customBaseUrl in customBaseUrlList) {
          responseBody = await DioClient().post(
              buck.commonApiInstance.connectApi,
              queryParameters: queryParameters,
              customBaseUrl: customBaseUrl);
          if (responseBody != null) {
            buck.cacheControl.setActiveBaseUrl(customBaseUrl);
            RsaHelper.getInstance().setBackendPublicKey(
                '-----BEGIN PUBLIC KEY-----\n' +
                    responseBody.data +
                    '\n-----END PUBLIC KEY-----');
            return true;
          }
        }
      }
      return false;
    } else {
      RsaHelper.getInstance().setBackendPublicKey(
          '-----BEGIN PUBLIC KEY-----\n' +
              responseBody.data +
              '\n-----END PUBLIC KEY-----');
    }
    return true;
  }

  Future<bool> login(String userName, String password) async {
    Map<String, String> params = {
      'userName': userName,
      'password': password,
      'serialNo': buck.serialNumber
    };
    ResponseBody<Map<String, dynamic>> response =
        await DioClient<Map<String, dynamic>>()
            .post(buck.commonApiInstance.loginApi, data: params, encrypt: true);
    if (response != null && response.success && response.data != null) {
      buck.cacheControl.setToken(response.data['token']);
      Map<String, dynamic> userMap = response.data['userView'];
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
          List userAuthorityViewList =
              serviceUserAuthorityViewMap[applicationName];
          if (userAuthorityViewList != null) {
            bundleIds
                .addAll(userAuthorityViewList.map((item) => item['bundleId']));
          }
        }
      }
      userMap['bundleIds'] = bundleIds;

      buck.userInfo = UserInfo.fromMap(userMap);
      await buck.socketClient.connect();
      TipsTool.info(response.message).show();
      return true;
    } else {
      TipsTool.warning(response.message).show();
    }
    return false;
  }

  logOut() {
    /// 调用退出登录接口，无论成功失败都不应该影响程序正常使用
    DioClient().get(buck.commonApiInstance.logoutApi).then((responseBody) {
      if (responseBody == null || !responseBody.success)
        TipsTool.warning('网络异常');
    });
    buck.cacheControl.recycleAuth();
    buck.messageBox.clear();
    buck.userInfo = null;
    buck.socketClient.closeSocket();

    /// 调用退出登录方法后清空路由栈并推入登录界面
    /// buck.navigatorKey.currentState?.pushNamedAndRemoveUntil('loginPage', (route) => route == null);
  }
}
