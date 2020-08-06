import 'package:buck/buck.dart';
import 'package:buck/basic_app.dart';
import 'package:buck/bundle/menu.dart';
import 'package:buck/model/user_info.dart';
import 'package:buck/widgets/bundle_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:vibrate/vibrate.dart';

class MenuBoss {
  static Map<String, Map<String, Menu>> _pool = {};
  static Map<String, Menu> allMenus = {};

  static Menu register(String groupName, Menu menu) {
    allMenus.putIfAbsent(menu.id, () => menu);
    Map<String, Menu> bundleMap = _pool.putIfAbsent(groupName, () => {});
    return bundleMap.putIfAbsent(menu.id, () => menu);
  }

  static Map<String, List<Menu>> get group {
    UserInfo _userInfo = Buck.getInstance().userInfo;
    Map<String, List<Menu>> groupingBundles = {};
    if (_userInfo != null) {
      Set bundleIds = _userInfo.bundleIds;
      _pool.entries.forEach((entry) {
        List<Menu> menus = entry.value.values
            .where((menu) => buck.menuFree ? true : bundleIds.contains(menu.id))
            .toList();
        menus.sort((menu1, menu2) => menu1.sort > menu2.sort ? 1 : -1);
        if (menus.length > 0)
          groupingBundles.putIfAbsent(entry.key, () => menus);
      });
    }
    return groupingBundles;
  }

  static List<Widget> groupingMenus(BuildContext context) {
    return MenuBoss.group.entries.map((entry) {
      List<Menu> menus = entry.value;
      String groupName = entry.key;
      return Container(
        margin: EdgeInsets.all(6),
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(5))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
              child: Text(groupName,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'pinshang',
                      color: Theme.of(context).primaryColorLight)),
            ),
            Divider(
              height: 20,
            ),
            Wrap(
              children: _buildMenuWidget(menus, context),
            ),
          ],
        ),
      );
    }).toList();
  }

  static List<Widget> shortcutMenus(BuildContext context) {
    List<Menu> _shortcutMenus = allMenus.entries
        .where(
            (entry) => buck.cacheControl.shortcutBundleIds.contains(entry.key))
        .map((entry) => entry.value)
        .toList();
    List<Widget> _shortcutMenusWidget =
        _buildMenuWidget(_shortcutMenus, context, shortcut: true);
    return _shortcutMenusWidget.length <= 0
        ? [
            Text('暂未加入快捷菜单',
                style: TextStyle(color: Colors.white, fontSize: 13))
          ]
        : _shortcutMenusWidget;
  }

  static List<Widget> _buildMenuWidget(List<Menu> menus, BuildContext context,
      {bool shortcut = false}) {
    Widget icon;
    return menus.map((menu) {
      icon = !shortcut && menu.key != null
          ? Hero(tag: menu.key, child: menu.icon)
          : menu.icon;
      double width = MediaQuery.of(context).size.width / 3 - 8;
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 3),
        child: BundleButton.build(
          width: width,
          id: menu.id,
          text: Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(menu.cnName,
                style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'pinshang',
                    color: Theme.of(context).primaryColorLight)),
          ),
          icon: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 2),
              child: icon),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => menu)),
          onLongPress: () {
            buck.cacheControl.operateShortcut(menu.id);
            Vibrate.feedback(FeedbackType.success);
          },
        ),
      );
    }).toList();
  }
}
