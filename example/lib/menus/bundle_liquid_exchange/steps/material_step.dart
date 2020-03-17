import 'package:buck_example/menus/bundle_liquid_exchange/steps/exchange_list_step.dart';
import 'package:buck/widgets/form/selector.dart';
import 'package:buck/widgets/scaffold/chromatic_app_bar.dart';
import 'package:buck/widgets/scaffold/chromatic_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

class MaterialStep extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MaterialStepState();
}

class MaterialStepState extends State<MaterialStep> {
  String _mediaBatch;
  String _pipetteBatch;

  @override
  void initState() {
    super.initState();
    _mediaBatch = '003';
    _pipetteBatch = '001';
  }

  @override
  Widget build(BuildContext context) {
    return ChromaticScaffold(
      chromaticAppBar: ChromaticAppBar(
        'Preparation',
        height: 80,
        colors: [Colors.blue[600], Colors.blue[200]],
      ),
      body: Center(
        child: Card(
          child: Container(
            height: 390,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: <Widget>[
                Container(height: 30),
                Selector(
                  value: _mediaBatch,
                  label: 'DMEM',
                  hint: 'select the medium batch number',
                  store: menuItems,
                  onChange: (item) => this.setState(() => _mediaBatch = item),
                ),
                Selector(
                  value: _pipetteBatch,
                  label: 'Pipette',
                  hint: 'select pipette lot number',
                  store: menuItems,
                  onChange: (item) => this.setState(() => _pipetteBatch = item),
                ),
                Container(height: 100),
                Divider(height: 20),
                MaterialButton(
                  height: 50,
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExchangeListStep())),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[Text(' Next Step', style: TextStyle(color: Colors.white, fontFamily: 'shouji', fontSize: 18))],
                  ),
                  color: Colors.grey,
                ),
                Container(height: 10),
                MaterialButton(
                  height: 50,
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[Icon(Icons.replay, color: Colors.white, size: 27), Text(' 重    置', style: TextStyle(color: Colors.white, fontFamily: 'shouji', fontSize: 18))],
                  ),
                  color: Colors.orange,
                ),
              ],
            ),
          ),
          elevation: 6,
        ),
      ),
    );
  }
}
