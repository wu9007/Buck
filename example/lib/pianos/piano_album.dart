import 'package:buck/bundle/piano.dart';
import 'package:buck/constant/icon_constant.dart';
import 'package:flutter/material.dart';

class PianoAlbum extends StatelessPiano {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(tag: id, child: leading),
        title: Text('Album'),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () => Navigator.of(context).pushNamed('card'),
          child: Text('Go To Card'),
        ),
      ),
    );
  }

  @override
  Widget get leading => Icon(MyIcons.picture, color: Colors.blueAccent[200]);

  @override
  String get id => 'album';

  @override
  int get sort => 3;

  @override
  String get cnName => '相册';

  @override
  bool get auth => false;
}
