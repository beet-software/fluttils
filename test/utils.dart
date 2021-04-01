import 'package:flutter/material.dart';

typedef VoidBuilderCallback = void Function(BuildContext);

class TestObserver extends NavigatorObserver {
  final void Function(Route, Route) onPushed;
  final void Function(Route, Route) onPopped;
  final void Function(Route, Route) onRemoved;
  final void Function(Route, Route) onReplaced;

  TestObserver({this.onPushed, this.onPopped, this.onRemoved, this.onReplaced});

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) =>
      onPushed?.call(route, previousRoute);

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) =>
      onPopped?.call(route, previousRoute);

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) =>
      onRemoved?.call(route, previousRoute);

  @override
  void didReplace({Route<dynamic> oldRoute, Route<dynamic> newRoute}) =>
      onReplaced?.call(newRoute, oldRoute);
}

class Pair<F, S> {
  final F first;
  final S second;

  const Pair(this.first, this.second);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;
}

class Comparison<T> {
  final T actual;
  final T expected;

  const Comparison(this.actual, this.expected);
}

const String data = "a";

Widget get dummy => SizedBox.shrink();

Widget createApp(Widget child, [NavigatorObserver observer]) => MaterialApp(
    home: Scaffold(body: child),
    navigatorObservers: [if (observer != null) observer]);

Set<Pair<Alignment, String>> decodeStack(Stack stack) {
  return stack.children.whereType<Align>().map((align) {
    return Pair(align.alignment as Alignment, (align.child as Text).data);
  }).toSet();
}

String decodeSafeScaffold(SafeArea area) {
  final Scaffold child = area.child as Scaffold;
  final Text grandchild = child.body as Text;
  return grandchild?.data;
}
