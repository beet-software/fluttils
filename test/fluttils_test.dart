import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttils/fluttils.dart';

import 'cases.dart';
import 'utils.dart';

void main() {
  // @formatter:off
  final List<TestCase> cases = [
    WidgetCase<Text, StyledText>({
      "empty": Comparison(StyledText(data, []), Text(data, style: TextStyle())),
      "color": Comparison(StyledText(data, [Colors.red]), Text(data, style: TextStyle(color: Colors.red))),
      "fontWeight": Comparison(StyledText(data, [FontWeight.bold]), Text(data, style: TextStyle(fontWeight: FontWeight.bold))),
      "fontSize (double)": Comparison(StyledText(data, [34.0]), Text(data, style: TextStyle(fontSize: 34))),
      "fontSize (int)": Comparison(StyledText(data, [34]), Text(data, style: TextStyle(fontSize: 34))),
      "fontStyle": Comparison(StyledText(data, [FontStyle.italic]), Text(data, style: TextStyle(fontStyle: FontStyle.italic))),
      "locale": Comparison(StyledText(data, [Locale("en")]), Text(data, style: TextStyle(locale: Locale("en")))),
      "decoration": Comparison(StyledText(data, [TextDecoration.lineThrough]), Text(data, style: TextStyle(decoration: TextDecoration.lineThrough))),
      "color, fontWeight": Comparison(StyledText(data, [Colors.blue, FontWeight.w100]), Text(data, style: TextStyle(fontWeight: FontWeight.w100, color: Colors.blue))),
      "fontStyle, fontStyle": Comparison(StyledText(data, [FontStyle.italic, FontStyle.normal]), Text(data, style: TextStyle(fontStyle: FontStyle.normal))),
      "color, fontStyle, fontWeight, color, fontWeight": Comparison(StyledText(data, [Colors.red, FontStyle.italic, FontWeight.w100, Colors.redAccent, FontWeight.bold]), Text(data,style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
    }, compare: (actual, expected) {
      expect(actual.data, expected.data);
      expect(actual.style, expected.style);
      expect(actual.textAlign, expected.textAlign);
    }),
    WidgetCase<Padding, SimplePadding>({
      "all": Comparison(SimplePadding(all: 5, child: dummy), Padding(padding: EdgeInsets.all(5), child: dummy)),
      "symmetric": Comparison(SimplePadding(width: 2, height: 3, child: dummy), Padding(padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3), child: dummy)),
      "only": Comparison(SimplePadding(left: 1, top: 4, child: dummy), Padding(padding: EdgeInsets.only(left: 1, top: 4))),
      "all, symmetric": Comparison(SimplePadding(all: 5, right: 3, child: dummy), Padding(padding: EdgeInsets.only(left: 5, right: 3, top: 5, bottom: 5))),
      "all, only": Comparison(SimplePadding(all: 1, top: 2, child: dummy), Padding(padding: EdgeInsets.only(left: 1, right: 1, top: 2, bottom: 1))),
      "symmetric, only": Comparison(SimplePadding(width: 10, top: 5, child: dummy), Padding(padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 0))),
      "symmetric, symmetric, only": Comparison(SimplePadding(width: 1, height: 15, top: 5, child: dummy), Padding(padding: EdgeInsets.only(left: 1, right: 1, top: 5, bottom: 15))),
      "all, symmetric, only": Comparison(SimplePadding(all: 10, width: 20, top: 5, child: dummy), Padding(padding: EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 10))),
    }, compare: (actual, expected) {
      expect(actual.padding, expected.padding);
    }),
    WidgetCase<SizedBox, Width>({
      "null": Comparison(Width(), SizedBox()),
      "value": Comparison(Width(10), SizedBox(width: 10)),
    }, compare: (actual, expected) {
      expect(actual.width, expected.width);
      expect(actual.height, expected.height);
    }),
    WidgetCase<SizedBox, Height>({
      "null": Comparison(Height(), SizedBox()),
      "value": Comparison(Height(10), SizedBox(height: 10)),
    }, compare: (actual, expected) {
      expect(actual.width, expected.width);
      expect(actual.height, expected.height);
    }),
    WidgetCase<Stack, SimpleStack>({
      "empty": Comparison(SimpleStack({}), Stack()),
      "center": Comparison(SimpleStack({Alignment.center: Text(data)}), Stack(children: [Align(alignment: Alignment.center, child: Text(data))])),
      "multiple": Comparison(SimpleStack({Alignment.topLeft: Text(data), Alignment.bottomRight: Text(data + data)}), Stack(children: [Align(alignment: Alignment.topLeft, child: Text(data)), Align(alignment: Alignment.bottomRight, child: Text(data + data))])),
    }, compare: (actual, expected) {
      expect(decodeStack(actual), decodeStack(expected));
    }),
    WidgetCase<SafeArea, SafeScaffold>({
      "empty": Comparison(SafeScaffold(), SafeArea(child: Scaffold())),
      "with body": Comparison(SafeScaffold(body: Text(data)), SafeArea(child: Scaffold(body: Text(data)))),
    }, compare: (actual, expected) {
      expect(decodeSafeScaffold(actual), decodeSafeScaffold(expected));
    }),
    WidgetCase<Visibility, SimpleVisibility>({
      "visible": Comparison(SimpleVisibility(child: dummy, isVisible: true), Visibility(child: dummy, maintainState: true, maintainSize: true, maintainAnimation: true)),
      "invisible": Comparison(SimpleVisibility(child: dummy, isVisible: false), Visibility(child: dummy, visible: false, maintainState: true, maintainSize: true, maintainAnimation: true)),
    }, compare: (actual, expected) {
      expect(actual.visible, expected.visible);
      expect(actual.maintainState, expected.maintainState);
      expect(actual.maintainSize, expected.maintainSize);
      expect(actual.maintainAnimation, expected.maintainAnimation);
    }),
    SimpleBuildersCase(),
    ListViewCase(),
    TapOutsideCase(),
    NavigationCase(),
    SplashScreenCase(),
    DialogsCase(),
    AsapCase(),
  ];
  // @formatter:on

  cases.forEach((c) => c.run());
}
