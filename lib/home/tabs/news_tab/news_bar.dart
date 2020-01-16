/// @author wujianchuan
/// @date 2019/12/18 15:12
import 'package:flutter/material.dart';

class NewsBar extends StatelessWidget {
  final String title;
  final double height;

  const NewsBar({Key key, @required this.title, @required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(color: Theme.of(context).hintColor),
          height: height,
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          leading: Navigator.canPop(context)
              ? GestureDetector(
                  child: Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
                  onTap: () => Navigator.of(context).pop(),
                )
              : Container(),
          title: Text(title, style: TextStyle(fontFamily: 'pinshang', fontWeight: FontWeight.bold, color: Theme.of(context).cardColor)),
        ),
      ],
    );
  }
}
