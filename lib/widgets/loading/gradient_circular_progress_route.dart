/// @author wujianchuan
/// @date 2019/12/28 15:03
import 'package:buck/widgets/loading/loading_progress.dart';
import 'package:flutter/material.dart';

class GradientCircularProgressRoute extends StatefulWidget {
  GradientCircularProgressRoute({
    this.stokeWidth = 4.0,
    this.radius = 20.0,
    this.colors,
    this.stokeBackgroundColor = const Color(0xFFEEEEEE),
    this.backgroundColor = const Color(0xFFEEEFFF),
    this.label,
  });

  final double stokeWidth;

  final double radius;

  final Color stokeBackgroundColor;

  final Color backgroundColor;

  final List<Color> colors;

  final Widget label;

  @override
  GradientCircularProgressRouteState createState() {
    return new GradientCircularProgressRouteState();
  }
}

class GradientCircularProgressRouteState extends State<GradientCircularProgressRoute> with TickerProviderStateMixin {
  AnimationController _animationController;
  List<Color> _colors;

  @override
  void initState() {
    super.initState();
    if (widget.colors == null || widget.colors.length <= 0) {
      _colors = [Colors.blue, Colors.blue[100]];
    } else {
      _colors = widget.colors;
    }
    _animationController = new AnimationController(vsync: this, duration: Duration(seconds: 1));
    bool isForward = true;
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        isForward = true;
      } else if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        if (isForward) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
      } else if (status == AnimationStatus.reverse) {
        isForward = false;
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LoadingProgress(
                colors: _colors,
                radius: widget.radius,
                stokeWidth: widget.stokeWidth,
                strokeCapRound: true,
                value: _animationController.value,
                backgroundColor: widget.stokeBackgroundColor,
              ),
              SizedBox(height: 17),
              widget.label != null ? widget.label : Container()
            ],
          );
        },
      ),
    );
  }
}
