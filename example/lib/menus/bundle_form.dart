import 'package:buck/bundle/menu.dart';
import 'package:buck/constant/icon_constant.dart';
import 'package:buck/utils/dio_client.dart';
import 'package:buck/widgets/form/constant/style_constant.dart';
import 'package:buck/widgets/form/headline.dart';
import 'package:buck/widgets/form/input.dart';
import 'package:buck/widgets/form/number_field.dart';
import 'package:buck/widgets/form/multi_election.dart';
import 'package:buck/widgets/form/selector.dart';
import 'package:buck/widgets/form/single_election.dart';
import 'package:buck/widgets/tips/tips_tool.dart';
import 'package:buck/widgets/button//sync_button.dart';
import 'package:flutter/material.dart';
import 'package:multiple_select/Item.dart';
import 'package:multiple_select/multi_drop_down.dart';
import 'package:multiple_select/multi_filter_select.dart';
import 'package:multiple_select/multiple_select.dart';

List<DropdownMenuItem> menuItems = [
  DropdownMenuItem(
    value: '001',
    child: Container(
      padding: EdgeInsets.only(left: 10),
      child: Text('B0220191128'),
    ),
  ),
  DropdownMenuItem(
    value: '002',
    child: Container(
      padding: EdgeInsets.only(left: 10),
      child: Text('B0220191129'),
    ),
  ),
  DropdownMenuItem(
    value: '003',
    child: Container(
      padding: EdgeInsets.only(left: 10),
      child: Text('B0220191130'),
    ),
  ),
];

List<Item<num, String, String>> items = List.generate(
  150,
  (index) => Item.build(
    value: index,
    display: '$index display',
    content: '$index content',
  ),
);

/// Simulate 15 data
List<MultipleSelectItem> elements = List.generate(
  15,
  (index) => MultipleSelectItem.build(
    value: index,
    display: '$index display',
    content: '$index content',
  ),
);

class BundleForm extends StatefulMenu {
  BundleForm({Key key}) : super(key: key);

  @override
  Widget get icon => Icon(MyIcons.deliver, color: Colors.brown);

  @override
  String get id => 'deliver';

  @override
  int get sort => 0;

  @override
  String get cnName => 'Form';

  @override
  State<StatefulWidget> createState() => BundleDeliverState();
}

class BundleDeliverState extends State<BundleForm> {
  double _length;
  String _mediaBatch;
  bool _swellingCheck;
  var _selectedValue;
  List _selectedValues = [];
  List<num> _initValue = [1, 2, 6];
  List _multipleSelectedValues = [];
  TextEditingController _disinfectDurationController =
      new TextEditingController();
  SyncButtonController _syncButtonController = new SyncButtonController();

  @override
  void initState() {
    super.initState();
    _length = 1.0;
    _disinfectDurationController.text = _length.toString();
    _mediaBatch = '003';
    _swellingCheck = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: Hero(tag: widget.key, child: widget.icon),
        title: Text('deliver',
            style: TextStyle(color: Colors.black, fontFamily: 'pinshang')),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Input(
              leading:
                  Icon(Icons.straighten, color: Theme.of(context).hintColor),
              label: 'Length',
              hint: 'enter the length of the umbilical cord',
//            enabled: false,
              trailing: Text('cm', style: CustomStyle.unitStyle),
              onChanged: (v) {
                this.setState(() => _length = double.parse(v));
              },
              controller: _disinfectDurationController,
            ),
            Divider(height: 1),
            CheckboxListTile(
              secondary: const Icon(Icons.bubble_chart, color: Colors.black45),
              title: const Text('Swelling'),
              value: this._swellingCheck,
              onChanged: (bool value) {
                setState(() {
                  this._swellingCheck = !this._swellingCheck;
                });
              },
            ),
            Divider(height: 1),
            NumberField.build(
                miniValue: -1,
                initValue: 20,
                onChange: (value) {
                  print(value);
                }),
            Divider(height: 1),
            Selector(
              leading:
                  Icon(Icons.straighten, color: Theme.of(context).hintColor),
              value: _mediaBatch,
              label: 'Alcohol',
              hint: 'select alcohol batch number',
              store: menuItems,
              onChange: (item) => this.setState(() => _mediaBatch = item),
              noUnderline: true,
//            disabled: true,
            ),
            Divider(height: 1),
            SingleElection.build(
              label: 'Inventory',
              leading:
                  Icon(Icons.shopping_cart, color: Theme.of(context).hintColor),
              value: _selectedValue,
              list: List.generate(
                  5,
                  (index) => SingleElectionItem(
                      'Inventory' + index.toString(), index.toString())),
              onPressed: (item) {
                this.setState(() => _selectedValue = item.value);
              },
            ),
            Divider(height: 1),
            MultiElection.build(
              label: 'Exception Type',
              leading: Icon(Icons.multiline_chart,
                  color: Theme.of(context).hintColor),
              value: _selectedValues,
              selectedColor: Colors.red,
              list: List.generate(
                  5,
                  (index) => MultiElectionItem(
                      'Exception Type' + index.toString(), index.toString())),
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
            Divider(height: 1),
            Headline('多选'),
            MultiFilterSelect(
              allItems: items,
              initValue: _initValue,
              selectCallback: (List selectedValue) =>
                  print(selectedValue.length),
            ),
            MultipleDropDown(
              placeholder: '请选择',
              disabled: false,
              values: _multipleSelectedValues,
              elements: elements,
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: SyncButton(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    '保    存',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                controller: _syncButtonController,
                textColor: Colors.white,
                color: Colors.orange,
                onPressed: () async {
                  _syncButtonController.disable();
                  ResponseBody body =
                      await Future.delayed(Duration(seconds: 2), () {})
                          .whenComplete(() => _syncButtonController.enable());
                  if (body.success) {
                    TipsTool.info('保存成功 - 批号为： ${body.data['butchNum']}')
                        .show();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
