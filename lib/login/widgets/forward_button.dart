import 'package:buck/login/utility/color_utility.dart';
import 'package:flutter/material.dart';

class ForwardButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  ForwardButton({this.onPressed, this.label});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(50.0)),
      child: MaterialButton(
        elevation: 12.0,
        minWidth: 70.0,
        color: Color(getColorHexFromStr('#667898')),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
