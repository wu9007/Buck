import 'package:buck/bundle/menu.dart';
import 'package:buck/constant/icon_constant.dart';
import 'package:buck/widgets/dialogs/expound_dialog.dart';
import 'package:buck/widgets/dialogs/upgrade_dialog.dart';
import 'package:buck/widgets/dialogs/whether_dialog.dart';
import 'package:flutter/material.dart';

class BundleService extends StatelessMenu {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: icon,
        title: Text('service',
            style: TextStyle(color: Colors.black, fontFamily: 'pinshang')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            color: Colors.orange,
            onPressed: () => _showExpoundDialogDemo(context),
            child: Text('expond dialog test'),
          ),
          MaterialButton(
            color: Colors.orange,
            onPressed: () => _showWhetherDialogDemo(context),
            child: Text('whether dialog test'),
          ),
          MaterialButton(
            color: Colors.orange,
            onPressed: () => _showUpgradeDialogDemo(context),
            child: Text('upgrade dialog test'),
          ),
        ],
      ),
    );
  }

  _showExpoundDialogDemo(BuildContext context) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ExpoundDialog(
          title: 'Expound Dialog Demo',
          content: 'Abandon the ship or abandon hope, don\'t repeat yourself.',
        );
      },
    );
  }

  _showWhetherDialogDemo(BuildContext context) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WhetherDialog(
          trueText: 'YES',
          falseText: 'NO',
          title: 'Whether Dialog Demo',
          content: 'Abandon the ship or abandon hope, don\'t repeat yourself.',
        );
      },
    );
  }

  _showUpgradeDialogDemo(BuildContext context) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return UpgradeDialog(
          url:
              'https://qd.myapp.com/myapp/qqteam/AndroidQQi/qq_6.0.1.6600_android_r25029_GuanWang_537057608_release.apk',
          path: '/qq_6.0.1.6600_android_r25029_GuanWang_537057608_release.apk',
          title: 'Upgrade Dialog Demo',
          content:
              'There is a new version that can be updated. Would you like to update?',
        );
      },
    );
  }

  @override
  Widget get icon => Icon(MyIcons.service, color: Colors.blueGrey);

  @override
  String get id => 'service';

  @override
  int get sort => 3;

  @override
  String get cnName => 'service';
}
