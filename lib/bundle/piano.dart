import 'package:flutter/material.dart';

abstract class Piano extends Widget {
  int get sort;

  Widget get leading;

  String get id;

  String get cnName;

  bool get auth;
}

abstract class StatelessPiano extends StatelessWidget implements Piano {}

abstract class StatefulPiano extends StatefulWidget implements Piano {}
