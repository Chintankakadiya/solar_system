import 'package:flutter/material.dart';

class MyPageRoute extends MaterialPageRoute {
  final Duration transDuation;
  MyPageRoute({
    this.transDuation = const Duration(milliseconds: 1000),
    WidgetBuilder? builder,
    RouteSettings? settings,
  }) : super(builder: builder!, settings: settings);

  @override
  Duration get transitionDuration => transDuation;
}
