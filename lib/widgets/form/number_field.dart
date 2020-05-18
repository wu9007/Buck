import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef ValueChanged<T> = void Function(T value);

/// 数字操作框
/// Created by Shusheng.
class NumberField extends StatefulWidget {
  final num miniValue;
  final num maxValue;
  final num initValue;
  final num width;
  final int precision;
  final ValueChanged<num> onChange;

  NumberField.build({
    Key key,
    @required this.miniValue,
    this.maxValue,
    @required this.initValue,
    @required this.onChange,
    this.width = 40.0,
    this.precision = 0,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => NumberFieldState();
}

class NumberFieldState extends State<NumberField> {
  RegExp _intOrFloatExp;
  FocusNode _focusNode = FocusNode();
  TextEditingController _textEditingController = TextEditingController();
  String _value;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        this._textEditingController.text =
            num.parse(this._textEditingController.text).toString();
        this._value = this._textEditingController.text;
      }
    });
    if (this.widget.precision == 0) {
      _intOrFloatExp = new RegExp(r"^(-?\d+)$");
    } else {
      _intOrFloatExp = new RegExp(
          r"^(\-?\d+|\d+\.\d{0," + this.widget.precision.toString() + r"})$");
    }
    if (this.widget.initValue < this.widget.miniValue)
      this._value = this.widget.miniValue.toString();
    if (this.widget.maxValue != null &&
        this.widget.initValue > this.widget.maxValue)
      this._value = this.widget.maxValue.toString();
    if (this.widget.initValue >= this.widget.miniValue &&
        (widget.maxValue == null ||
            this.widget.initValue <= this.widget.maxValue))
      this._value = this.widget.initValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.value = TextEditingValue(
      text: this._value,
      selection: TextSelection.fromPosition(
        TextPosition(
            affinity: TextAffinity.downstream,
            offset: this._value.toString().length),
      ),
    );
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 0.1, color: Colors.black26),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            onTap: () {
              if (num.parse(this._value) - 1 > widget.miniValue) {
                this.setState(() => this._value = (num.parse(this._value) - 1)
                    .toStringAsFixed(this.widget.precision));
              } else {
                this.setState(() => this._value = widget.miniValue.toString());
              }
              this.widget.onChange(num.parse(this._value));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
              ),
              child: Icon(
                Icons.remove,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              height: 25,
              alignment: Alignment.center,
              child: TextField(
                focusNode: _focusNode,
                onChanged: (content) {
                  if (content == null || content.length == 0) {
                    this.setState(
                        () => this._value = this.widget.miniValue.toString());
                  } else {
                    if (_intOrFloatExp.hasMatch(content)) {
                      num inputValue = num.parse(content);
                      if (widget.maxValue != null &&
                          inputValue > widget.maxValue) {
                        this.setState(
                            () => this._value = widget.maxValue.toString());
                      } else if (inputValue < widget.miniValue) {
                        this.setState(
                            () => this._value = widget.miniValue.toString());
                      } else {
                        this._value = content;
                      }
                    } else {
                      this.setState(() {});
                    }
                  }
                  if (!content.endsWith('.')) {
                    this.widget.onChange(num.parse(this._value));
                  }
                },
                controller: _textEditingController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(style: BorderStyle.none, width: 0),
                  ),
                  contentPadding: EdgeInsets.only(),
                ),
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            onTap: () {
              if (widget.maxValue == null ||
                  num.parse(this._value) + 1 < widget.maxValue) {
                this.setState(() => this._value = (num.parse(this._value) + 1)
                    .toStringAsFixed(this.widget.precision));
              } else if (widget.maxValue != null) {
                this.setState(() => this._value = widget.maxValue.toString());
              }
              this.widget.onChange(num.parse(this._value));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Icon(
                Icons.add,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    this._textEditingController.dispose();
    this._focusNode.dispose();
    super.dispose();
  }
}
