import 'package:buck/bundle/menu.dart';
import 'package:buck/constant/icon_constant.dart';
import 'package:buck/widgets/dynamic_list.dart';
import 'package:flutter/material.dart';

class BundleList extends StatefulMenu {
  @override
  Widget get icon => Icon(MyIcons.shopping, color: Colors.pink);

  @override
  String get id => 'shopping';

  @override
  int get sort => 2;

  @override
  String get cnName => 'List';

  @override
  State<StatefulWidget> createState() => BundleListState();
}

class BundleListState extends State<BundleList> {
  DynamicListController _dynamicListController = DynamicListController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: widget.icon,
        title: Text('shopping',
            style: TextStyle(color: Colors.black, fontFamily: 'pinshang')),
      ),
      body: Container(
        child: DynamicList.build(
          controller: _dynamicListController,
          itemBuilder: _itemBuilder,
          dataRequester: _dataRequester,
          initRequester: _initRequester,
        ),
      ),
      persistentFooterButtons: <Widget>[
        MaterialButton(
            onPressed: () => this._dynamicListController.fireRefresh(),
            child: Icon(Icons.refresh)),
        MaterialButton(
            onPressed: () => this._dynamicListController.toTop(),
            child: Icon(Icons.vertical_align_top))
      ],
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
}
