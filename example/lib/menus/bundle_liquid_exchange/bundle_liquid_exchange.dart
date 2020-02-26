import 'package:buck/bundle/menu.dart';
import 'package:buck_example/menus/bundle_liquid_exchange/steps/material_step.dart';
import 'package:flutter/material.dart';

class BundleLiquidExchange extends StatelessMenu {
  @override
  Widget get icon => Icon(Icons.wifi_tethering);

  @override
  String get id => 'liquid_exchange';

  @override
  int get sort => 2;

  @override
  String get cnName => 'Exchange';

  @override
  Widget build(BuildContext context) {
    return MaterialStep();
  }
}
