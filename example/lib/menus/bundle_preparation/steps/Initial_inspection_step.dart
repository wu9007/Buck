import 'dart:io';

import 'package:buck_example/menus/bundle_preparation/widgets/step_button.dart';
import 'package:buck/widgets/form/constant/style_constant.dart';
import 'package:buck/widgets/form/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InitialInspectionStep extends StatefulWidget {
  final BoxConstraints viewportConstraints;
  final GestureTapCallback preTap;
  final GestureTapCallback nextTap;

  InitialInspectionStep(this.viewportConstraints, this.preTap, this.nextTap);

  @override
  State<StatefulWidget> createState() => InitialInspectionStepState();
}

class InitialInspectionStepState extends State<InitialInspectionStep> {
  bool _swellingCheck;
  bool _congestionCheck;
  double _umbilicalLength;
  List<File> _images;

  TextEditingController _umbilicalLengthController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _swellingCheck = true;
    _congestionCheck = false;
    _images = [];
    _umbilicalLength = 15.0;
    this._umbilicalLengthController.text = _umbilicalLength.toString();
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
          Input(
            controller: _umbilicalLengthController,
            leading: Icon(Icons.straighten, color: Colors.black45),
            label: '脐带长度',
            hint: '请输入脐带长度',
            trailing: Text('cm', style: CustomStyle.labelStyle),
            onChanged: (v) {
              this.setState(() => _umbilicalLength = double.parse(v));
            },
          ),
          Divider(height: 1),
          CheckboxListTile(
            secondary: const Icon(Icons.bubble_chart, color: Colors.black45),
            title: const Text('脐带肿胀'),
            value: this._swellingCheck,
            onChanged: (bool value) {
              setState(() {
                this._swellingCheck = !this._swellingCheck;
              });
            },
          ),
          Divider(height: 1),
          CheckboxListTile(
            secondary: const Icon(Icons.opacity, color: Colors.black45),
            title: const Text('脐带淤血'),
            value: this._congestionCheck,
            onChanged: (bool value) {
              setState(() {
                this._congestionCheck = !this._congestionCheck;
              });
            },
          ),
          Divider(height: 1),
          _images.length > 0
              ? Container(
                  padding: EdgeInsets.all(10),
                  height: 180,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _images.map((image) {
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Image.file(image, fit: BoxFit.fill),
                        );
                      }).toList(),
                    ),
                  ),
                )
              : SizedBox(height: 180, child: Center(child: Container(child: Text('图片预览区', style: CustomStyle.hintStyle)))),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: FlatButton.icon(
              padding: EdgeInsets.symmetric(vertical: 12),
              onPressed: () => this._getImage(),
              icon: Icon(
                Icons.camera,
                color: Colors.white,
                size: 20,
              ),
              color: Colors.cyan,
              label: Text('拍照上传', style: TextStyle(color: Colors.white, fontFamily: 'shouji', fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _images.add(image);
      setState(() {});
    }
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
            text: Text('上一步', style: TextStyle(color: Colors.white, fontFamily: 'shouji', fontSize: 18)),
            onTap: widget.preTap,
          ),
          StepButton(
            stepButtonType: StepButtonType.next,
            text: Text('下一步', style: TextStyle(color: Colors.white, fontFamily: 'shouji', fontSize: 18)),
            onTap: widget.nextTap,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    this._umbilicalLengthController.dispose();
    super.dispose();
  }
}
