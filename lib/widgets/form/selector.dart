import 'package:buck/widgets/form/constant/style_constant.dart';
import 'package:flutter/material.dart';

class Selector<T> extends StatefulWidget {
  Selector({
    Key key,
    @required this.value,
    this.leading,
    @required this.label,
    @required this.hint,
    @required this.store,
    @required this.onChange,
    this.noUnderline = false,
    this.disabled = false,
  })  : assert(store == null || store.isEmpty || value == null || store.where((DropdownMenuItem<T> item) => item.value == value).length == 1),
        super(key: key);

  final T value;
  final Widget leading;
  final String label;
  final String hint;
  final List<DropdownMenuItem<T>> store;
  final Function onChange;
  final bool disabled;
  final bool noUnderline;

  @override
  State<StatefulWidget> createState() => new SelectorState();
}

class SelectorState<T> extends State<Selector<T>> {
  @override
  Widget build(BuildContext context) {
    dynamic disabledHint;
    if (widget.value != null && widget.store != null && widget.store.length > 0) {
      disabledHint = widget.store.singleWhere((item) => item.value == widget.value)?.child;
    }
    return Opacity(
      opacity: widget.disabled ? 0.5 : 1,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 3.0),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            widget.leading == null
                ? Container()
                : Padding(
                    padding: EdgeInsets.only(right: 32),
                    child: widget.leading,
                  ),
            Padding(
              padding: EdgeInsets.only(right: 5, bottom: 3),
              child: Text(widget.label ?? '', style: CustomStyle.labelStyle),
            ),
            Expanded(
              child: DropdownButton(
                disabledHint: disabledHint,
                hint: Container(
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(widget.hint, style: CustomStyle.hintStyle),
                  ),
                ),
                value: widget.value,
                items: widget.store,
                onChanged: widget.disabled ? null : widget.onChange,
                isExpanded: true,
                iconSize: 28,
                iconEnabledColor: Colors.grey[400],
                underline: widget.noUnderline
                    ? Container()
                    : Container(
                        height: 1.0,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFFBDBDBD),
                              width: 0.0,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
