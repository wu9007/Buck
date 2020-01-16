import 'package:buck/basic_app.dart';
import 'package:buck/home/tabs/news_tab/news_bar.dart';
import 'package:buck/message/message_body.dart';
import 'package:buck/message/notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsDetail extends StatefulWidget {
  final String uuid;

  NewsDetail(this.uuid);

  @override
  State<StatefulWidget> createState() => NewsDetailState();
}

class NewsDetailState extends State<NewsDetail> {
  MessageBody _messageBody;
  String _messageUuid;

  @override
  void initState() {
    super.initState();
    _messageUuid = widget.uuid;
    MessageBody messageBody = buck.messageBox.allMessage().singleWhere((item) => item.uuid == _messageUuid);
    this.setState(() => _messageBody = messageBody);

    if (messageBody.unread) {
      buck.messageBox.popUnreadMessage(_messageUuid);
      this.setState(() => _messageBody = messageBody);
      notifierSubject.stream.listen((uuid) {
        if (_messageUuid == null || _messageUuid != uuid) {
          if (mounted) {
            _messageUuid = uuid;
            buck.messageBox.popUnreadMessage(_messageUuid);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          NewsBar(height: 75, title: '来自${_messageBody.senderName}的消息'),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 50.0 + 10, bottom: 5, left: 15, right: 15),
              child: _messageBody != null
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _messageBody.title,
                            style: TextStyle(fontSize: 19, height: 1.5),
                          ),
                          Text(
                            '${_messageBody.sendTime.year}年${_messageBody.sendTime.month}月${_messageBody.sendTime.day}日 ${_messageBody.sendTime.hour}:${_messageBody.sendTime.minute}',
                            style: TextStyle(fontSize: 15, color: Theme.of(context).hintColor),
                          ),
                          Divider(height: 27),
                          Text(_messageBody.content, style: TextStyle(fontSize: 15, height: 1.7)),
                          Divider(),
                          _messageBody.bundleId != null
                              ? GestureDetector(
                                  child: Text('去处理', style: TextStyle(color: Colors.blue, fontSize: 15, decoration: TextDecoration.underline)),
                                  onTap: () => Navigator.of(context).pushNamed(_messageBody.bundleId),
                                )
                              : SizedBox(height: 10),
                        ],
                      ),
                    )
                  : Container(),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
