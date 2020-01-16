import 'package:buck/bundle/menu.dart';
import 'package:buck/constant/icon_constant.dart';
import 'package:buck/widgets/form/constant/style_constant.dart';
import 'package:buck/widgets/form/input.dart';
import 'package:buck/widgets/form/multi_election.dart';
import 'package:buck/widgets/form/selector.dart';
import 'package:buck/widgets/form/single_election.dart';
import 'package:flutter/material.dart';

class BundleDeliver extends StatefulMenu {
  BundleDeliver({Key key}) : super(key: key);

  @override
  Widget get icon => Icon(MyIcons.deliver, color: Colors.brown);

  @override
  String get id => 'deliver';

  @override
  int get sort => 2;

  @override
  String get cnName => 'deliver';

  @override
  State<StatefulWidget> createState() => BundleDeliverState();
}

class BundleDeliverState extends State<BundleDeliver> {
  List _selectedValues = [];
  var _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: Hero(tag: widget.key, child: widget.icon),
        title: Text('deliver', style: TextStyle(color: Colors.black, fontFamily: 'pinshang')),
      ),
      body: Column(
        children: <Widget>[
          Input(
            leading: Icon(Icons.straighten, color: Theme.of(context).hintColor),
            label: '脐带长度',
            hint: '请输入脐带长度',
            enabled: false,
            trailing: Text('cm', style: CustomStyle.unitStyle),
          ),
          Divider(height: 1),
          CheckboxListTile(
            secondary: const Icon(Icons.bubble_chart, color: Colors.black45),
            title: Text('脐带肿胀', style: CustomStyle.labelStyle),
            value: false,
            onChanged: null,
          ),
          Divider(height: 1),
          Selector(
            leading: Icon(Icons.straighten, color: Theme.of(context).hintColor),
            value: null,
            label: '酒        精',
            hint: '请选择酒精批次号',
            store: [],
            onChange: () {},
            noUnderline: true,
            disabled: true,
          ),
          Divider(height: 1),
          SingleElection.build(
            label: '物品清单',
            leading: Icon(Icons.shopping_cart, color: Theme.of(context).hintColor),
            value: _selectedValue,
            list: List.generate(5, (index) => SingleElectionItem('物品清单' + index.toString(), index.toString())),
            onPressed: (item) {
              this.setState(() => _selectedValue = item.value);
            },
          ),
          Divider(height: 1),
          MultiElection.build(
            label: '异常类型',
            leading: Icon(Icons.multiline_chart, color: Theme.of(context).hintColor),
            value: _selectedValues,
            selectedColor: Colors.red,
            list: List.generate(5, (index) => MultiElectionItem('异常类型' + index.toString(), index.toString())),
            onPressed: (item) {
              var value = item.value;
              if (_selectedValues.contains(value)) {
                _selectedValues.remove(value);
              } else {
                _selectedValues.add(value);
              }
              this.setState(() => _selectedValues = _selectedValues);
            },
          ),
        ],
      ),
    );
  }
}
