import 'package:buck/basic_app.dart';
import 'package:buck/service/message_box.dart';
import 'package:buck/service/version_control.dart';
import 'package:buck/home/tabs/menu_tab/menu_center.dart';
import 'package:buck/home/tabs/news_tab/news_center.dart';
import 'package:buck/home/tabs/news_tab/news_detail.dart';
import 'package:buck/home/tabs/person_tab/person_center.dart';
import 'package:buck/home/widgets/bottom_navy_bar.dart';
import 'package:buck/message/notifier.dart';
import 'package:buck/widgets/dialogs/whether_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pda_scanner/pda_listener_mixin.dart';
import 'package:rxdart/subjects.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with PdaListenerMixin<HomePage> {
  PageController _pageController;
  int _currentIndex = 0;
  int _newsNum;
  bool detailIsOpen = false;

  @override
  void initState() {
    super.initState();
    buck.messageBox.loadMessage();
    _pageController = PageController();
    _newsNum = buck.messageBox.unreadMessage().length;
    messageBoxSubject.stream.listen((values) {
      if (mounted) this.setState(() => _newsNum = buck.messageBox.unreadMessage().length);
    });

    notifierSubject.stream.listen((uuid) {
      if (mounted && !detailIsOpen) {
        detailIsOpen = true;
        this.setState(() => _currentIndex = 1);
        _pageController.jumpToPage(_currentIndex);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsDetail(uuid))).then((value) => detailIsOpen = false);
      }
    });

    upgradeSubject = PublishSubject<VersionUpgradeInfo>();

    upgradeSubject.stream.listen((versionUpgradeInfo) {
      buck.versionControl.upgradeVersion(context, versionUpgradeInfo);
    });

    buck.versionControl.checkVersion();
  }

  @override
  void dispose() {
    upgradeSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            MenuCenter(widget.title),
            NewsCenter(),
            PersonCenter(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(title: Text('Menus'), icon: Icon(Icons.apps)),
          BottomNavyBarItem(title: Text('Messages'), icon: Icon(Icons.message), news: _newsNum),
          BottomNavyBarItem(title: Text('Person'), icon: Icon(Icons.person_pin)),
        ],
      ),
    );
  }

  @override
  Future<void> onEvent(Object code) async {
    bool result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WhetherDialog(
          trueText: '同意',
          falseText: '不同意',
          title: '扫描解析条码号',
          content: '条码号为：$code，\n是否进行审核操作',
        );
      },
    );
    print(result);
  }

  @override
  void onError(Object error) {
    if (error is Exception) {
      throw error;
    }
    throw Exception(error);
  }
}
