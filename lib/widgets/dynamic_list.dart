import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 下拉刷新，上拉加载更多数据
class DynamicList extends StatefulWidget {
  DynamicList.build({
    Key key,
    @required this.itemBuilder,
    @required this.dataRequester,
    @required this.initRequester,
    this.initLoadingWidget,
    this.moreLoadingWidget,
    this.controller,
    this.scrollDirection = Axis.vertical,
  })  : assert(itemBuilder != null),
        assert(dataRequester != null),
        assert(initRequester != null),
        separated = false,
        super(key: key);

  DynamicList.separated({
    Key key,
    @required this.itemBuilder,
    @required this.dataRequester,
    @required this.initRequester,
    this.initLoadingWidget,
    this.moreLoadingWidget,
    this.controller,
    this.scrollDirection = Axis.vertical,
  })  : assert(itemBuilder != null),
        assert(dataRequester != null),
        assert(initRequester != null),
        separated = true,
        super(key: key);

  final Function itemBuilder;
  final Function dataRequester;
  final Function initRequester;
  final Widget initLoadingWidget;
  final Widget moreLoadingWidget;
  final bool separated;
  final DynamicListController controller;
  final Axis scrollDirection;

  @override
  State createState() => new DynamicListState();
}

class DynamicListState extends State<DynamicList> {
  bool isPerformingRequest = false;
  ScrollController _controller = new ScrollController();
  List _dataList;

  @override
  void initState() {
    super.initState();
    this._onRefresh();
    if (this.widget.controller != null) {
      this.widget.controller.refresh = () => _onRefresh();
    }
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color loadingColor = Theme.of(context).primaryColor;
    return this._dataList == null
        ? loadingProgress(
            loadingColor,
            initLoadingWidget: this.widget.initLoadingWidget,
          )
        : RefreshIndicator(
            displacement: 20,
            color: loadingColor,
            onRefresh: this._onRefresh,
            child: this.widget.separated
                ? ListView.separated(
                    scrollDirection: widget.scrollDirection,
                    separatorBuilder: (BuildContext context, int index) => Divider(height: 1.0, color: Theme.of(context).hintColor),
                    itemCount: _dataList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _dataList.length) {
                        return opacityLoadingProgress(
                          isPerformingRequest,
                          loadingColor,
                          loadingWidget: this.widget.moreLoadingWidget,
                        );
                      } else {
                        return widget.itemBuilder(_dataList, context, index);
                      }
                    },
                    controller: _controller,
                  )
                : ListView.builder(
                    scrollDirection: widget.scrollDirection,
                    itemCount: _dataList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _dataList.length) {
                        return opacityLoadingProgress(
                          isPerformingRequest,
                          loadingColor,
                          loadingWidget: this.widget.moreLoadingWidget,
                        );
                      } else {
                        return widget.itemBuilder(_dataList, context, index);
                      }
                    },
                    controller: _controller,
                  ),
          );
  }

  /// 刷新 数据初始化
  Future<Null> _onRefresh() async {
    List initDataList = await widget.initRequester();
    if (mounted) this.setState(() => this._dataList = initDataList);
    return;
  }

  /// 加载更多数据
  _loadMore() async {
    if (mounted) this.setState(() => isPerformingRequest = true);
    List newDataList = await widget.dataRequester();
    if (newDataList != null) {
      if (newDataList.length == 0) {
        double edge = 50.0;
        double offsetFromBottom = _controller.position.maxScrollExtent - _controller.position.pixels;
        if (offsetFromBottom < edge) {
          _controller.animateTo(_controller.offset - (edge - offsetFromBottom), duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
        }
      } else {
        _dataList.addAll(newDataList);
      }
    }
    if (mounted) this.setState(() => isPerformingRequest = false);
  }
}

Widget loadingProgress(loadingColor, {Widget initLoadingWidget}) {
  if (initLoadingWidget == null) {
    initLoadingWidget = Loading();
  }
  return Center(
    child: initLoadingWidget,
  );
}

Widget opacityLoadingProgress(isPerformingRequest, loadingColor, {Widget loadingWidget}) {
  if (loadingWidget == null) {
    loadingWidget = Loading();
  }
  return new Padding(
    padding: const EdgeInsets.all(8.0),
    child: new Center(
      child: new Opacity(
        opacity: isPerformingRequest ? 1.0 : 0.0,
        child: loadingWidget,
      ),
    ),
  );
}

class DynamicListController {
  Function refresh;

  fireRefresh() {
    if (refresh != null) {
      refresh();
    }
  }
}

class Loading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoadingState();
}

class LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    final CurvedAnimation curve = CurvedAnimation(parent: controller, curve: Curves.easeInOutBack);
    animation = Tween(begin: 0.0, end: 2 * math.pi).animate(curve)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
          controller.forward();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Transform.rotate(
        angle: animation.value,
        child: Icon(
          Icons.donut_large,
          color: Theme.of(context).primaryColor,
          size: 30,
        ),
      ),
    );
  }
}
