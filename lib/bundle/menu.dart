import 'package:flutter/material.dart';

abstract class Menu extends Widget {
  int get sort;

  Widget get icon;

  String get id;

  String get cnName;
}

abstract class StatelessMenu extends StatelessWidget implements Menu {
  const StatelessMenu({ Key key }) : super(key: key);
}

abstract class StatefulMenu extends StatefulWidget implements Menu {
  const StatefulMenu({ Key key }) : super(key: key);
}
