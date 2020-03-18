import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExchangeItem extends StatefulWidget {
  final String code;
  final DateTime startTime;
  final int times;
  final String location;
  final DateTime advanceNextTime;
  final double percentage;

  ExchangeItem({
    Key key,
    this.code,
    this.startTime,
    this.times,
    this.location,
    this.advanceNextTime,
    this.percentage,
  }) : super(key: Key(code));

  ExchangeItem.fromMap(Map map)
      : this.code = map['code'],
        this.startTime = map['startTime'],
        this.times = map['times'],
        this.location = map['location'],
        this.advanceNextTime = map['advanceNextTime'],
        this.percentage = map['percentage'],
        super(key: Key(map['code']));

  static List<ExchangeItem> allFromMap(List<Map> list) => list.map((map) => ExchangeItem.fromMap(map)).toList();

  @override
  State<StatefulWidget> createState() => ExchangeItemState();
}

class ExchangeItemState extends State<ExchangeItem> with SingleTickerProviderStateMixin {
  double _percentage;
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    this._percentage = widget.percentage;
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    double tipHeight = 80;
    double innerTipHeight = tipHeight * _percentage * _animation.value;
    Color tipColor = _percentage <= 0.6 ? Colors.cyan : _percentage <= 0.8 ? Colors.orange : Colors.redAccent;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), color: Colors.white),
      height: 110,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            child: Text(widget.times.toString(), style: TextStyle(fontSize: 25)),
            backgroundColor: tipColor,
            foregroundColor: Colors.white,
          ),
          Container(
            height: tipHeight,
            width: 6,
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: innerTipHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: tipColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(widget.code, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.golf_course, size: 20, color: Colors.black26),
                      SizedBox(width: 5),
                      Text('On ', style: TextStyle(fontSize: 15, color: Colors.black54)),
                      Text(widget.advanceNextTime.toLocal().toString().substring(0, 16), style: TextStyle(fontSize: 16)),
                      Text(' Inbox', style: TextStyle(fontSize: 15, color: Colors.black54)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.location_on, size: 20, color: Colors.black26),
                      SizedBox(width: 5),
                      Text('At ', style: TextStyle(fontSize: 15, color: Colors.black54)),
                      Text(widget.location, style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.timer, size: 20, color: Colors.black26),
                      Text('Next Time ', style: TextStyle(fontSize: 15, color: Colors.black54)),
                      SizedBox(width: 5),
                      Text(widget.advanceNextTime.toLocal().toString().substring(0, 16), style: TextStyle(color: tipColor, fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
