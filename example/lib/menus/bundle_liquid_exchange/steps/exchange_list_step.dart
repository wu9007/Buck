import 'package:buck_example/menus/bundle_liquid_exchange/widgets/exchange_item.dart';
import 'package:buck/widgets/dynamic_list.dart';
import 'package:buck/widgets/form/single_election.dart';
import 'package:buck/widgets/scaffold/chromatic_app_bar.dart';
import 'package:buck/widgets/scaffold/chromatic_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<Map> items = [
  {
    'code': 'EC0220191130',
    'startTime': DateTime(2019, 01, 09, 09, 20),
    'times': 3,
    'location': '7号柜1-1',
    'advanceNextTime': DateTime(2019, 01, 13, 09, 20),
    'percentage': 0.9,
  },
  {
    'code': 'EC0220010121',
    'startTime': DateTime(2019, 01, 01, 14, 20),
    'times': 0,
    'location': '7号柜1-2',
    'advanceNextTime': DateTime(2019, 01, 08, 14, 20),
    'percentage': 0.7,
  },
  {
    'code': 'EC0220187686',
    'startTime': DateTime(2019, 01, 19, 09, 20),
    'times': 1,
    'location': '7号柜3-2',
    'advanceNextTime': DateTime(2019, 01, 23, 09, 20),
    'percentage': 0.5,
  },
  {
    'code': 'EC022019326',
    'startTime': DateTime(2019, 01, 11, 09, 20),
    'times': 1,
    'location': '7号柜2-2',
    'advanceNextTime': DateTime(2019, 01, 14, 09, 20),
    'percentage': 0.2,
  },
  {
    'code': 'EC0220191112',
    'startTime': DateTime(2019, 01, 21, 09, 20),
    'times': 2,
    'location': '6号柜1-2',
    'advanceNextTime': DateTime(2019, 01, 24, 09, 20),
    'percentage': 0.1,
  },
  {
    'code': 'EC0220191321',
    'startTime': DateTime(2019, 01, 16, 09, 20),
    'times': 5,
    'location': '7号柜1-2',
    'advanceNextTime': DateTime(2019, 01, 20, 09, 20),
    'percentage': 0.1,
  },
];

class ExchangeListStep extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ExchangeListStepState();
}

class ExchangeListStepState extends State<ExchangeListStep> {
  int _timesFilter;
  DynamicListController _dynamicListController = new DynamicListController();

  @override
  Widget build(BuildContext context) {
    return ChromaticScaffold(
      marginTop: 130,
      backgroundColor: Colors.grey[200],
      body: Container(
        child: DynamicList.build(
          controller: _dynamicListController,
          itemBuilder: _itemBuilder,
          dataRequester: _dataRequester,
          initRequester: _initRequester,
        ),
      ),
      stackChildren: <Widget>[
        Positioned(
          top: 70,
          right: 10,
          left: 10,
          child: Card(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            elevation: 2,
            child: SingleChildScrollView(
              child: Center(
                child: SingleElection.build(
                  value: this._timesFilter,
                  color: Colors.orange,
                  list: List.generate(3, (index) => SingleElectionItem('$index 次', index)),
                  onPressed: (item) {
                    if (item.value != this._timesFilter) {
                      this.setState(() => this._timesFilter = item.value);
                    } else {
                      this.setState(() => this._timesFilter = null);
                    }
                    _dynamicListController.fireRefresh();
                  },
                ),
              ),
            ),
          ),
        )
      ],
      chromaticAppBar: ChromaticAppBar('Exchange', height: 130),
    );
  }

  Function _itemBuilder = (List dataList, BuildContext context, int index) {
    Map item = dataList[index];
    return ExchangeItem.fromMap(item);
  };

  Future<List> _initRequester() async {
    return Future.value(List<Map<String, dynamic>>.generate(
      items.length,
      (index) => Map<String, dynamic>.from(items[index]),
      growable: true,
    ).where((map) => _timesFilter != null ? map['times'] == _timesFilter : true).toList());
  }

  Future<List> _dataRequester() async {
    return Future.delayed(Duration(seconds: 2), () {
      return List<Map<String, dynamic>>.generate(
        items.length,
        (index) => Map<String, dynamic>.from(items[index]),
        growable: true,
      ).where((map) => _timesFilter != null ? map['times'] == _timesFilter : true).toList();
    });
  }
}
