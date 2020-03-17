import 'package:buck_example/menus/bundle_preparation/widgets/step_button.dart';
import 'package:buck/widgets/form/selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

List<DropdownMenuItem> alcoholMenuItems = [
  DropdownMenuItem(
    value: '001',
    child: Container(
      padding: EdgeInsets.only(left: 10),
      child: Text('B0220191128'),
    ),
  )
];

class MaterialStep extends StatefulWidget {
  final BoxConstraints viewportConstraints;
  final GestureTapCallback nextTap;

  MaterialStep(this.viewportConstraints, this.nextTap);

  @override
  _MaterialStepState createState() => _MaterialStepState();
}

class _MaterialStepState extends State<MaterialStep> {
  String _alcoholBatch;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: new ConstrainedBox(
          constraints: new BoxConstraints(
            minHeight: widget.viewportConstraints.maxHeight - 48.0,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: <Widget>[
                _buildForm(),
                Spacer(flex: 1),
                _buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: <Widget>[
          Selector(
            value: _alcoholBatch,
            label: 'Alcohol',
            hint: 'select alcohol batch number',
            store: alcoholMenuItems,
            onChange: (item) => this.setState(() => _alcoholBatch = item),
          ),
          Selector(
            value: _alcoholBatch,
            label: 'Normal Saline',
            hint: 'select normal saline batch number',
            store: alcoholMenuItems,
            onChange: (item) => this.setState(() => _alcoholBatch = item),
          ),
          Selector(
            value: _alcoholBatch,
            label: 'Double-antibody',
            hint: 'select the double anti batch number',
            store: alcoholMenuItems,
            onChange: (item) => this.setState(() => _alcoholBatch = item),
          ),
          Selector(
            value: _alcoholBatch,
            label: 'Centrifuge Bottle',
            hint: 'select batch number of centrifugal bottle',
            store: alcoholMenuItems,
            onChange: (item) => this.setState(() => _alcoholBatch = item),
          ),
          Selector(
            value: _alcoholBatch,
            label: 'Culture Bottle',
            hint: 'select batch number of culture bottle',
            store: alcoholMenuItems,
            onChange: (item) => this.setState(() => _alcoholBatch = item),
          ),
          Selector(
            value: _alcoholBatch,
            label: 'DMEM',
            hint: 'select the medium batch number',
            store: alcoholMenuItems,
            onChange: (item) => this.setState(() => _alcoholBatch = item),
          ),
          Selector(
            value: _alcoholBatch,
            label: 'Specimen',
            hint: 'select sample batch number',
            store: alcoholMenuItems,
            onChange: (item) => this.setState(() => _alcoholBatch = item),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(),
          StepButton(
            stepButtonType: StepButtonType.next,
            text: Text('Next Step', style: TextStyle(color: Colors.white, fontFamily: 'shouji', fontSize: 18)),

            /// TODO 使用PDA后按钮不可用
            onTap: widget.nextTap,
            disabled: false,
          ),
        ],
      ),
    );
  }
}
