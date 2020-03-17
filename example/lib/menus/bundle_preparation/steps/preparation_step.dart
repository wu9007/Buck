import 'package:buck_example/menus/bundle_preparation/widgets/step_button.dart';
import 'package:buck/widgets/form/constant/formatter_constant.dart';
import 'package:buck/widgets/form/constant/style_constant.dart';
import 'package:buck/widgets/form/headline.dart';
import 'package:buck/widgets/form/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreparationStep extends StatefulWidget {
  final BoxConstraints viewportConstraints;
  final GestureTapCallback preTap;
  final GestureTapCallback onComplete;

  PreparationStep(this.viewportConstraints, this.preTap, this.onComplete);

  @override
  State<StatefulWidget> createState() => PreparationStepState();
}

class PreparationStepState extends State<PreparationStep> {
  double _alcoholDisinfectConsume;
  double _disinfectDuration;
  int _cleaningTimes;
  double _cleaningConsume;
  double _whartonJellyVolume;
  double _cutVolume;
  String _incubatorNum;
  DateTime _startTrainingTime;
  TextEditingController _alcoholDisinfectConsumeController = new TextEditingController();
  TextEditingController _disinfectDurationController = new TextEditingController();
  TextEditingController _cleaningTimesController = new TextEditingController();
  TextEditingController _cleaningConsumeController = new TextEditingController();
  TextEditingController _whartonJellyVolumeController = new TextEditingController();
  TextEditingController _cutVolumeController = new TextEditingController();
  TextEditingController _incubatorNumController = new TextEditingController();
  TextEditingController _startTrainingTimeController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _alcoholDisinfectConsume = 10.0;
    _disinfectDuration = 5.0;
    _cleaningTimes = 6;
    _cleaningConsume = 7.0;
    _whartonJellyVolume = 18.0;
    _cutVolume = 10.0;
    _incubatorNum = 'I056HF8971';
    _startTrainingTime = DateTime.now();
    _alcoholDisinfectConsumeController.text = _alcoholDisinfectConsume.toString();
    _disinfectDurationController.text = _disinfectDuration.toString();
    _cleaningTimesController.text = _cleaningTimes.toString();
    _cleaningConsumeController.text = _cleaningConsume.toString();
    _whartonJellyVolumeController.text = _whartonJellyVolume.toString();
    _cutVolumeController.text = _cutVolume.toString();
    _incubatorNumController.text = _incubatorNum;
    _startTrainingTimeController.text = _startTrainingTime.toLocal().toString().substring(0, 19);
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Headline('Immersion Disinfection'),
          Input(
            controller: _alcoholDisinfectConsumeController,
            leading: Icon(Icons.format_color_fill, color: Colors.black45),
            label: 'Alcohol Use',
            hint: 'input alcohol dosage',
            trailing: Text('ml', style: CustomStyle.unitStyle),
            onChanged: (v) {
              this.setState(() => _alcoholDisinfectConsume = double.parse(v));
            },
            inputFormatters: [Formatter.floatOnly],
          ),
          Divider(height: 1),
          Input(
            controller: _disinfectDurationController,
            leading: Icon(Icons.timer, color: Colors.black45),
            label: 'Total Time',
            hint: 'enter disinfection time',
            trailing: Text('Min', style: CustomStyle.unitStyle),
            onChanged: (v) {
              this.setState(() => _disinfectDuration = double.parse(v));
            },
            inputFormatters: [Formatter.floatOnly],
          ),
          Divider(height: 1),
          Headline('Clean Cut Up'),
          Input(
            controller: _cleaningTimesController,
            leading: Icon(Icons.settings_input_svideo, color: Colors.black45),
            label: 'Washing Time',
            hint: 'enter cleaning times',
            trailing: Text('Times', style: CustomStyle.unitStyle),
            onChanged: (v) {
              this.setState(() => _cleaningTimes = int.parse(v));
            },
            inputFormatters: [Formatter.digitsOnly],
          ),
          Divider(height: 1),
          Input(
            controller: _cleaningConsumeController,
            leading: Icon(Icons.local_drink, color: Colors.black45),
            label: 'Alcohol Use',
            hint: 'input alcohol dosage',
            trailing: Text('ml/times', style: CustomStyle.unitStyle),
            onChanged: (v) {
              this.setState(() => _cleaningConsume = double.parse(v));
            },
            inputFormatters: [Formatter.floatOnly],
          ),
          Divider(height: 1),
          Input(
            controller: _whartonJellyVolumeController,
            leading: Icon(Icons.polymer, color: Colors.black45),
            label: 'Huatong Colloidal Product',
            hint: 'input huatong colloidal product',
            trailing: Text('ml', style: CustomStyle.unitStyle),
            onChanged: (v) {
              this.setState(() => _whartonJellyVolume = double.parse(v));
            },
            inputFormatters: [Formatter.floatOnly],
          ),
          Divider(height: 1),
          Input(
            controller: _cleaningTimesController,
            leading: Icon(Icons.settings_input_svideo, color: Colors.black45),
            label: 'Washing Times',
            hint: 'enter cleaning times',
            trailing: Text('times', style: CustomStyle.unitStyle),
            onChanged: (v) {
              this.setState(() => _cleaningTimes = int.parse(v));
            },
            inputFormatters: [Formatter.digitsOnly],
          ),
          Divider(height: 1),
          Input(
            controller: _cleaningConsumeController,
            leading: Icon(Icons.local_drink, color: Colors.black45),
            label: 'Alcohol Use',
            hint: 'input alcohol dosage',
            trailing: Text('ml/times', style: CustomStyle.unitStyle),
            onChanged: (v) {
              this.setState(() => _cleaningConsume = double.parse(v));
            },
            inputFormatters: [Formatter.floatOnly],
          ),
          Divider(height: 1),
          Input(
            controller: _cutVolumeController,
            leading: Icon(Icons.content_cut, color: Colors.black45),
            label: 'Volume After Shearing',
            hint: 'enter the cut volume',
            trailing: Text('ml', style: CustomStyle.unitStyle),
            onChanged: (v) {
              this.setState(() => _cutVolume = double.parse(v));
            },
            inputFormatters: [Formatter.floatOnly],
          ),
          Divider(height: 1),
          Headline('Split Charging'),
          Input(
            controller: _incubatorNumController,
            leading: Icon(Icons.local_laundry_service, color: Colors.black45),
            label: 'Incubator Number',
            onChanged: (v) {
              this.setState(() => _incubatorNum = v);
            },
          ),
          Divider(height: 1),
          Input(
            controller: _startTrainingTimeController,
            leading: Icon(Icons.access_time, color: Colors.black45),
            label: 'Start Time',
          ),
          Divider(height: 1),
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
          StepButton(
            stepButtonType: StepButtonType.pre,
            backgroundColor: Colors.orange,
            text: Text('Back', style: TextStyle(color: Colors.white, fontFamily: 'shouji', fontSize: 18)),
            onTap: widget.preTap,
          ),
          StepButton(
            stepButtonType: StepButtonType.next,
            text: Text('Next ', style: TextStyle(color: Colors.white, fontFamily: 'shouji', fontSize: 18)),
            onTap: widget.onComplete,
            icon: Icon(Icons.verified_user, color: Colors.white, size: 20),
            disabled: true,
          ),
        ],
      ),
    );
  }
}
