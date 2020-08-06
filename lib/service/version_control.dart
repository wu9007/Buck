import 'package:buck/basic_app.dart';
import 'package:buck/utils/dio_client.dart';
import 'package:buck/widgets/dialogs/upgrade_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

const MANDATORY_UPGRADE = 'MandatoryUpgrade';
const SELECTIVE_UPGRADE = 'SelectiveUpgrade';

PublishSubject<VersionUpgradeInfo> upgradeSubject;

/// @author wujianchuan
/// @date 2020/1/13 9:27
class VersionControl {
  static VersionControl _instance = VersionControl._();

  VersionControl._();

  static VersionControl getInstance() {
    return _instance;
  }

  checkVersion() async {
    ResponseBody responseBody = await DioClient().get(
        buck.commonApiInstance.versionApi,
        queryParameters: {'appName': buck.appId});
    if (responseBody != null &&
        (responseBody.success ?? false) &&
        responseBody.data != null) {
      VersionUpgradeInfo versionUpgradeInfo =
          VersionUpgradeInfo.fromMap(responseBody.data);
      if (buck.cacheControl.version != versionUpgradeInfo.version) {
        upgradeSubject.add(versionUpgradeInfo);
        buck.cacheControl.setVersion(versionUpgradeInfo.version);
      }
    }
  }

  upgradeVersion(BuildContext context, VersionUpgradeInfo versionUpgradeInfo) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return UpgradeDialog(
          url: versionUpgradeInfo.url,
          path: versionUpgradeInfo.path,
          title: '发现新版本：${versionUpgradeInfo.version}',
          content: versionUpgradeInfo.description ?? '✨ 全新改版，带给你不一样的体验。',
          nextTime: '下次再说',
          upgradeNow: '现在升级',
          mandatory: versionUpgradeInfo.mandatory,
        );
      },
    );
  }
}

class VersionUpgradeInfo {
  final String version;
  final String url;
  final String path;
  final bool mandatory;
  final String description;

  VersionUpgradeInfo.fromMap(Map<String, dynamic> map)
      : version = map['version'],
        url = map['url'],
        path = map['path'],
        mandatory = map['mandatory'],
        description = map['description'];
}
