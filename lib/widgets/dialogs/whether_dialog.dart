import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// @author wujianchuan
/// @date 2019/12/28 17:01
class WhetherDialog extends StatelessWidget {
  final String title;
  final String content;
  final String trueText;
  final String falseText;
  final double width;
  final double height;

  WhetherDialog({
    @required this.title,
    @required this.content,
    this.trueText = '是',
    this.falseText = '否',
    this.width = 280,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          children: <Widget>[
            Text(title, style: TextStyle(color: Theme.of(context).textTheme.title.color, fontSize: 18, decoration: TextDecoration.none, fontFamily: 'pinshang')),
            Divider(),
            Expanded(
              child: SizedBox(
                width: width - 20,
                child: SingleChildScrollView(
                  child: Text(content, style: TextStyle(color: Theme.of(context).textTheme.body1.color, fontSize: 15, decoration: TextDecoration.none, fontWeight: FontWeight.normal)),
                ),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  color: Colors.orange,
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    falseText,
                    style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'pinshang'),
                  ),
                ),
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    trueText,
                    style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'pinshang'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
