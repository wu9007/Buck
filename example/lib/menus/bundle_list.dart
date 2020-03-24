import 'package:buck/bundle/menu.dart';
import 'package:buck/constant/icon_constant.dart';
import 'package:buck/widgets/dynamic_list.dart';
import 'package:flutter/material.dart';

class BundleList extends StatelessMenu {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: icon,
        title: Text('shopping',
            style: TextStyle(color: Colors.black, fontFamily: 'pinshang')),
      ),
      body: Container(
        child: DynamicList.build(
          itemBuilder: _itemBuilder,
          dataRequester: _dataRequester,
          initRequester: _initRequester,
        ),
      ),
    );
  }

  Future<List> _initRequester() async {
    return Future.value(List.generate(15, (i) => i));
  }

  Future<List> _dataRequester() async {
    return Future.delayed(Duration(seconds: 2), () {
      return List.generate(10, (i) => 15 + i);
    });
  }

  final Function _itemBuilder =
      (List dataList, BuildContext context, int index) {
    String title = dataList[index].toString();
    return ListTile(title: Text("Number $title"));
  };

  @override
  Widget get icon => Icon(MyIcons.shopping, color: Colors.pink);

  @override
  String get id => 'shopping';

  @override
  int get sort => 2;

  @override
  String get cnName => 'List';
}
