import 'package:buck/basic_app.dart';
import 'package:buck/service/message_box.dart';
import 'package:buck/constant/icon_constant.dart';
import 'package:buck/home/tabs/news_tab/news_bar.dart';
import 'package:buck/home/tabs/news_tab/news_detail.dart';
import 'package:buck/home/tabs/news_tab/news_item.dart';
import 'package:buck/message/message_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsCenter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewsCenterState();
}

class NewsCenterState extends State<NewsCenter> {
  ScrollController _controller = new ScrollController();
  List<dynamic> _allMessage = [];
  bool showToTopBtn = false;

  @override
  void initState() {
    super.initState();
    _allMessage = buck.messageBox.allMessage();
    messageBoxSubject.stream.listen((values) {
      if (mounted) this.setState(() => _allMessage = values);
    });
    _controller.addListener(() {
      if (_controller.offset < 500 && showToTopBtn) {
        setState(() => showToTopBtn = false);
      } else if (_controller.offset >= 500 && showToTopBtn == false) {
        setState(() => showToTopBtn = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          NewsBar(height: 75, title: '消  息'),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 50.0, bottom: 5),
              child: RefreshIndicator(
                onRefresh: () => buck.messageBox.loadMessage(),
                child: ListView.separated(
                    controller: _controller,
                    itemCount: _allMessage.length,
                    separatorBuilder: (BuildContext context, int index) => new Divider(),
                    itemBuilder: (context, index) {
                      MessageBody messageBody = _allMessage[index];
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetail(messageBody.uuid))),
                        child: NewsItem(messageBody),
                      );
                    }),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 12,
            child: !showToTopBtn
                ? Container()
                : GestureDetector(
                    child: Opacity(
                      opacity: 0.8,
                      child: Container(
                        padding: EdgeInsets.all(9),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white),
                        child: Icon(MyIcons.toTop, color: Colors.black, size: 32),
                      ),
                    ),
                    onTap: () {
                      _controller.animateTo(.0, duration: Duration(milliseconds: 500), curve: Curves.ease);
                    },
                  ),
          )
        ],
      ),
    );
  }
}
