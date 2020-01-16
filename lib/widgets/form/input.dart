import 'package:buck/widgets/form/constant/style_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatelessWidget {
  final Widget leading;
  final String label;
  final String hint;
  final Widget trailing;
  final bool autofocus;
  final bool hidden;
  final bool enabled;
  final List<TextInputFormatter> inputFormatters;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onSubmitted;

  Input({
    this.leading,
    this.label,
    this.hint,
    this.trailing,
    this.autofocus = false,
    this.hidden = false,
    this.enabled = true,
    this.inputFormatters,
    this.controller,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return hidden
        ? Container()
        : Opacity(
            opacity: enabled ? 1 : 0.5,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              height: 55,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 32),
                    child: leading,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5, bottom: 3),
                    child: Text(label ?? '', style: CustomStyle.labelStyle),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: TextField(
                        controller: controller,
                        autofocus: autofocus,
                        enabled: enabled,
                        onChanged: onChanged,
                        onEditingComplete: onEditingComplete,
                        onSubmitted: onChanged,
                        cursorColor: Colors.orangeAccent,
                        cursorWidth: 1.5,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        inputFormatters: inputFormatters,
                        decoration: InputDecoration(
                          hintText: hint,
                          hintStyle: CustomStyle.hintStyle,
                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  trailing != null
                      ? Container(
                          width: 44,
                          padding: EdgeInsets.only(left: 3, bottom: 3),
                          child: trailing,
                        )
                      : Container(),
                ],
              ),
            ),
          );
  }
}
