import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef ValueChanged<T> = void Function(T value);

/// 数字操作框
/// Created by Shusheng.
class NumberField extends StatefulWidget {
  final int miniValue;
  final int maxValue;
  final int initValue;
  final double width;
  final ValueChanged<int> onChange;

  NumberField.build({
    Key key,
    @required this.miniValue,
    @required this.maxValue,
    @required this.initValue,
    @required this.onChange,
    this.width = 40.0,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => NumberFieldState();
}

class NumberFieldState extends State<NumberField> {
  int _value;

  @override
  void initState() {
    super.initState();
    if (this.widget.initValue < this.widget.miniValue) this._value = this.widget.miniValue;
    if (this.widget.initValue > this.widget.maxValue) this._value = this.widget.maxValue;
    if (this.widget.initValue >= this.widget.miniValue && this.widget.initValue <= this.widget.maxValue) this._value = this.widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 0.1, color: Colors.black26),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            onTap: () {
              if (this._value > widget.miniValue) {
                this.setState(() => this._value = this._value - 1);
              } else {
                this.setState(() => this._value = widget.miniValue);
              }
              this.widget.onChange(this._value);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
              ),
              child: Icon(
                Icons.remove,
                color: Colors.black54,
              ),
            ),
          ),
          Container(
            width: widget.width,
            height: 25,
            alignment: Alignment.center,
            child: TextField(
              onChanged: (content) {
                if (content == null || content.toString().length == 0) {
                  this.setState(() => this._value = this.widget.miniValue);
                } else {
                  int inputValue = int.parse(content);
                  if (inputValue > widget.maxValue) {
                    this.setState(() => this._value = widget.maxValue);
                  } else if (inputValue < widget.miniValue) {
                    this.setState(() => this._value = widget.miniValue);
                  } else {
                    this.setState(() => this._value = inputValue);
                  }
                }
                this.widget.onChange(this._value);
              },
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: this._value.toString(),
                  selection: TextSelection.fromPosition(
                    TextPosition(affinity: TextAffinity.downstream, offset: this._value.toString().length),
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9]"))],
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
          InkWell(
            borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
            onTap: () {
              if (this._value < widget.maxValue) {
                this.setState(() => this._value = this._value + 1);
              } else {
                this.setState(() => this._value = widget.maxValue);
              }
              this.widget.onChange(this._value);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
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
    super.dispose();
  }
}
