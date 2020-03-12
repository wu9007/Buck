import 'package:buck/widgets/form/constant/style_constant.dart';
import 'package:buck/widgets/tips/tips_tool.dart';
import 'package:flutter/material.dart';

class SingleElection extends StatefulWidget {
  final Widget leading;
  final String label;
  final List<SingleElectionItem> list;
  final OnPressedFunction onPressed;
  final MaterialColor color;
  final Color selectedColor;
  final dynamic value;
  final bool disabled;
  final String disabledHind;

  @override
  State<StatefulWidget> createState() => new SingleElectionState();

  SingleElection.build({
    Key key,
    this.leading,
    this.label,
    @required this.list,
    @required this.value,
    @required this.onPressed,
    this.color,
    this.selectedColor,
    this.disabled = false,
    this.disabledHind = 'The current item is not available',
  }) : super(key: key);
}

class SingleElectionState extends State<SingleElection> {
  MaterialColor _selectedColor;
  Color _unSelectedColor;

  @override
  void initState() {
    super.initState();
    if (widget.selectedColor != null) {
      _selectedColor = widget.selectedColor;
    } else {
      _selectedColor = Colors.blue;
    }
    if (widget.color != null) _unSelectedColor = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.color == null)
      _unSelectedColor = Theme.of(context).iconTheme.color;
    return Opacity(
      opacity: widget.disabled ? 0.5 : 1,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTitle(),
            SizedBox(height: 6),
            _buildItems(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: <Widget>[
        widget.leading == null
            ? Container()
            : Padding(
                padding: EdgeInsets.only(right: 32),
                child: widget.leading,
              ),
        widget.leading == null
            ? Container()
            : Padding(
                padding: EdgeInsets.only(right: 5, bottom: 3),
                child: Text(widget.label ?? '', style: CustomStyle.labelStyle),
              ),
      ],
    );
  }

  Widget _buildItems() {
    return widget.list != null
        ? Wrap(
            children: List<Widget>.generate(
              widget.list.length,
              (index) {
                bool selected = widget.list[index].value == widget.value;
                return Container(
                  height: 30,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: FlatButton(
                    color: selected ? _selectedColor[50] : Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        side: BorderSide(
                            color:
                                selected ? _selectedColor : _unSelectedColor)),
                    child: Text(
                      widget.list[index].label,
                      style: new TextStyle(
                          color: selected ? _selectedColor : _unSelectedColor),
                    ),
                    onPressed: widget.disabled
                        ? () => TipsTool.warning(widget.disabledHind)
                        : () => widget.onPressed(widget.list[index]),
                  ),
                );
              },
            ),
          )
        : Container();
  }
}

class SingleElectionItem {
  String label;
  dynamic value;
  dynamic sourceBody;

  SingleElectionItem(this.label, this.value);

  SingleElectionItem.fromMap(Map<String, dynamic> map, {labelName, valueName})
      : label = map[labelName ?? 'label'] ?? '',
        value = map[valueName ?? 'value'] ?? '',
        sourceBody = map;

  static List<SingleElectionItem> allFromMap(List mapList,
      {labelName, valueName}) {
    return mapList != null
        ? mapList
            .map((map) => SingleElectionItem.fromMap(map,
                labelName: labelName, valueName: valueName))
            .toList()
        : [];
  }
}

typedef void OnPressedFunction(SingleElectionItem item);
