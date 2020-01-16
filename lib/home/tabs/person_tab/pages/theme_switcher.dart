import 'package:buck/basic_app.dart';
import 'package:buck/service/theme_painter.dart';
import 'package:buck/widgets/form/constant/style_constant.dart';
import 'package:flutter/material.dart';

/// @author wujianchuan
/// @date 2019/12/28 19:04
class ThemeSwitcher extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ThemeSwitcherState();
}

class ThemeSwitcherState extends State<ThemeSwitcher> {
  String _themeType;

  @override
  void initState() {
    super.initState();
    _themeType = buck.cacheControl.themeType;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, ThemeData> themeMap = ThemePainter.getInstance().themeMap;
    return Scaffold(
      appBar: AppBar(title: Text('主题')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: themeMap.entries
              .map((entry) => CheckboxListTile(
                    secondary: const Icon(Icons.bubble_chart),
                    title: Text(entry.key, style: CustomStyle.labelStyle),
                    value: _themeType == entry.key,
                    onChanged: (value) {
                      this.setState(() => _themeType = entry.key);
                      buck.cacheControl.setThemeType(entry.key);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}
