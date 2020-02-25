import 'package:buck/bundle/menu.dart';
import 'package:flutter/material.dart';
import 'package:buck/utils/dio_client.dart';

/// @author wujianchuan
/// @date 2020/2/21 11:27
class DepartmentUserSyncInfo extends StatelessMenu {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          child: Text('request'),
          onPressed: () {
            DioClient().get('/setting/departmentusersyncinfo/servers');
          },
        ),
      ),
    );
  }

  @override
  String get cnName => '部门用户持久化设置';

  @override
  Widget get icon => Icon(Icons.send);

  @override
  String get id => 'departmentusersyncinfo';

  @override
  int get sort => 0;
}
