import 'package:buck/message/message_body.dart';
import 'package:flutter/material.dart';

/// @author wujianchuan
/// @date 2019/12/18 15:12
class NewsItem extends StatelessWidget {
  final MessageBody messageBody;

  NewsItem(this.messageBody);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10, left: 20),
          child: SizedBox(
            height: 65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(messageBody.senderName ?? '', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), maxLines: 1),
                    Text('${messageBody.sendTime.month}/${messageBody.sendTime.day} ${messageBody.sendTime.hour}:${messageBody.sendTime.minute}',
                        style: TextStyle(fontSize: 13, color: Theme.of(context).hintColor), maxLines: 1),
                  ],
                ),
                Text(messageBody.title ?? '', style: TextStyle(fontSize: 14), maxLines: 1),
                Text(
                  messageBody.content ?? '',
                  style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 6,
          left: 5,
          child: Opacity(
            child: Container(
              height: 7,
              width: 7,
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            opacity: messageBody.unread ? 1 : 0,
          ),
        )
      ],
    );
  }
}
