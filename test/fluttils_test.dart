import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttils/fluttils.dart';
import 'package:fluttils/src/widgets.dart';

import 'cases.dart';
import 'utils.dart';

void main() {
  // @formatter:off
  final List<RunnableTest> cases = [
    WidgetTypeTest<Text, StyledText>({
      "empty": TypeComparison(StyledText(data, []), Text(data, style: TextStyle())),
      "color": TypeComparison(StyledText(data, [Colors.red]), Text(data, style: TextStyle(color: Colors.red))),
      "fontWeight": TypeComparison(StyledText(data, [FontWeight.bold]), Text(data, style: TextStyle(fontWeight: FontWeight.bold))),
      "fontSize:double": TypeComparison(StyledText(data, [34.0]), Text(data, style: TextStyle(fontSize: 34))),
      "fontSize:int": TypeComparison(StyledText(data, [34]), Text(data, style: TextStyle(fontSize: 34))),
      "fontStyle": TypeComparison(StyledText(data, [FontStyle.italic]), Text(data, style: TextStyle(fontStyle: FontStyle.italic))),
      "locale": TypeComparison(StyledText(data, [Locale("en")]), Text(data, style: TextStyle(locale: Locale("en")))),
      "decoration": TypeComparison(StyledText(data, [TextDecoration.lineThrough]), Text(data, style: TextStyle(decoration: TextDecoration.lineThrough))),
      "color, fontWeight": TypeComparison(StyledText(data, [Colors.blue, FontWeight.w100]), Text(data, style: TextStyle(fontWeight: FontWeight.w100, color: Colors.blue))),
      "fontStyle, fontStyle": TypeComparison(StyledText(data, [FontStyle.italic, FontStyle.normal]), Text(data, style: TextStyle(fontStyle: FontStyle.normal))),
      "color, fontStyle, fontWeight, color, fontWeight": TypeComparison(StyledText(data, [Colors.red, FontStyle.italic, FontWeight.w100, Colors.redAccent, FontWeight.bold]), Text(data,style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
    }, compare: (actual, expected) {
      expect(actual.data, expected.data);
      expect(actual.style, expected.style);
      expect(actual.textAlign, expected.textAlign);
    }),
    TypeTest<EdgeInsets, SimpleEdgeInsets>({
      "all": TypeComparison(SimpleEdgeInsets(all: 5), EdgeInsets.all(5)),
      "symmetric": TypeComparison(SimpleEdgeInsets(width: 2, height: 3), EdgeInsets.symmetric(horizontal: 2, vertical: 3)),
      "only": TypeComparison(SimpleEdgeInsets(left: 1, top: 4), EdgeInsets.only(left: 1, top: 4)),
      "all, symmetric": TypeComparison(SimpleEdgeInsets(all: 5, right: 3), EdgeInsets.only(left: 5, right: 3, top: 5, bottom: 5)),
      "all, only": TypeComparison(SimpleEdgeInsets(all: 1, top: 2), EdgeInsets.only(left: 1, right: 1, top: 2, bottom: 1)),
      "symmetric, only": TypeComparison(SimpleEdgeInsets(width: 10, top: 5), EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 0)),
      "symmetric, symmetric, only": TypeComparison(SimpleEdgeInsets(width: 1, height: 15, top: 5), EdgeInsets.only(left: 1, right: 1, top: 5, bottom: 15)),
      "all, symmetric, only": TypeComparison(SimpleEdgeInsets(all: 10, width: 20, top: 5), EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 10)),
    }, compare: (actual, expected) {
      Comparator(actual, expected)
        ..compareBy((insets) => insets.top)
        ..compareBy((insets) => insets.bottom)
        ..compareBy((insets) => insets.left)
        ..compareBy((insets) => insets.right);
    }),
    WidgetTypeTest<Padding, SimplePadding>({
      "all": TypeComparison(SimplePadding(all: 5, child: dummy), Padding(padding: EdgeInsets.all(5), child: dummy)),
      "symmetric": TypeComparison(SimplePadding(width: 2, height: 3, child: dummy), Padding(padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3), child: dummy)),
      "only": TypeComparison(SimplePadding(left: 1, top: 4, child: dummy), Padding(padding: EdgeInsets.only(left: 1, top: 4))),
      "all, symmetric": TypeComparison(SimplePadding(all: 5, right: 3, child: dummy), Padding(padding: EdgeInsets.only(left: 5, right: 3, top: 5, bottom: 5))),
      "all, only": TypeComparison(SimplePadding(all: 1, top: 2, child: dummy), Padding(padding: EdgeInsets.only(left: 1, right: 1, top: 2, bottom: 1))),
      "symmetric, only": TypeComparison(SimplePadding(width: 10, top: 5, child: dummy), Padding(padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 0))),
      "symmetric, symmetric, only": TypeComparison(SimplePadding(width: 1, height: 15, top: 5, child: dummy), Padding(padding: EdgeInsets.only(left: 1, right: 1, top: 5, bottom: 15))),
      "all, symmetric, only": TypeComparison(SimplePadding(all: 10, width: 20, top: 5, child: dummy), Padding(padding: EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 10))),
    }, compare: (actual, expected) {
      expect(actual.padding, expected.padding);
    }),
    WidgetTypeTest<SizedBox, Width>({
      "null": TypeComparison(Width(), SizedBox()),
      "value": TypeComparison(Width(10), SizedBox(width: 10)),
    }, compare: (actual, expected) {
      expect(actual.width, expected.width);
      expect(actual.height, expected.height);
    }),
    WidgetTypeTest<SizedBox, Height>({
      "null": TypeComparison(Height(), SizedBox()),
      "value": TypeComparison(Height(10), SizedBox(height: 10)),
    }, compare: (actual, expected) {
      expect(actual.width, expected.width);
      expect(actual.height, expected.height);
    }),
    WidgetTypeTest<Stack, SimpleStack>({
      "empty": TypeComparison(SimpleStack({}), Stack()),
      "center": TypeComparison(SimpleStack({Alignment.center: Text(data)}), Stack(children: [Align(alignment: Alignment.center, child: Text(data))])),
      "multiple": TypeComparison(SimpleStack({Alignment.topLeft: Text(data), Alignment.bottomRight: Text(data + data)}), Stack(children: [Align(alignment: Alignment.topLeft, child: Text(data)), Align(alignment: Alignment.bottomRight, child: Text(data + data))])),
    }, compare: (actual, expected) {
      expect(decodeStack(actual), decodeStack(expected));
    }),
    WidgetTypeTest<SafeArea, SafeScaffold>({
      "empty": TypeComparison(SafeScaffold(), SafeArea(child: Scaffold())),
      "with body": TypeComparison(SafeScaffold(body: Text(data)), SafeArea(child: Scaffold(body: Text(data)))),
    }, compare: (actual, expected) {
      expect(decodeSafeScaffold(actual), decodeSafeScaffold(expected));
    }),
    WidgetTypeTest<Visibility, SimpleVisibility>({
      "visible": TypeComparison(SimpleVisibility(child: dummy, isVisible: true), Visibility(child: dummy, maintainState: true, maintainSize: true, maintainAnimation: true)),
      "invisible": TypeComparison(SimpleVisibility(child: dummy, isVisible: false), Visibility(child: dummy, visible: false, maintainState: true, maintainSize: true, maintainAnimation: true)),
    }, compare: (actual, expected) {
      Comparator(actual, expected)
        ..compareBy((visibility) => visibility.visible)
        ..compareBy((visibility) => visibility.maintainState)
        ..compareBy((visibility) => visibility.maintainSize)
        ..compareBy((visibility) => visibility.maintainAnimation);
    }),
    WidgetTypeTest<Group, Separated>({
      "col:none": TypeComparison(Separated.col([], Divider()), Group.col([])),
      "col:one": TypeComparison(Separated.col([Text("A")], Divider()), Group.col([Text("A")])),
      "col:two": TypeComparison(Separated.col([Text("A"), Text("B")], Divider()), Group.col([Text("A"), Divider(), Text("B")])),
      "col:three": TypeComparison(Separated.col([Text("A"), Text("B"), Text("C")], Divider()), Group.col([Text("A"), Divider(), Text("B"), Divider(), Text("C")])),
      "row:none": TypeComparison(Separated.row([], Divider()), Group.row([])),
      "row:one": TypeComparison(Separated.row([Text("A")], Divider()), Group.row([Text("A")])),
      "row:two": TypeComparison(Separated.row([Text("A"), Text("B")], Divider()), Group.row([Text("A"), Divider(), Text("B")])),
      "row:three": TypeComparison(Separated.row([Text("A"), Text("B"), Text("C")], Divider()), Group.row([Text("A"), Divider(), Text("B"), Divider(), Text("C")])),
    }, compare: (actual, expected) {
      Comparator(actual, expected)
        ..compareBy((group) => group.direction)
        ..compareBy((group) => group.children.length)
        ..compareBy((group) => group.children.whereType<Divider>().length)
        ..compareBy((group) => group.children.whereType<Text>().length);
    }),
    WidgetValueTest<Column, Group>({
      "axis:attributes:empty": ValueComparison(Group([], direction: Axis.vertical, attrs: []), Column()),
      "axis:attributes:mainAxisAlignment": ValueComparison(Group([], direction: Axis.vertical, attrs: MainAxisAlignment.center), Column(mainAxisAlignment: MainAxisAlignment.center)),
      "axis:attributes:mainAxisSize": ValueComparison(Group([], direction: Axis.vertical, attrs: MainAxisSize.min), Column(mainAxisSize: MainAxisSize.min)),
      "axis:attributes:crossAxisAlignment": ValueComparison(Group([], direction: Axis.vertical, attrs: CrossAxisAlignment.end), Column(crossAxisAlignment: CrossAxisAlignment.end)),
      "axis:attributes:textDirection": ValueComparison(Group([], direction: Axis.vertical, attrs: TextDirection.rtl), Column(textDirection: TextDirection.rtl)),
      "axis:attributes:verticalDirection": ValueComparison(Group([], direction: Axis.vertical, attrs: VerticalDirection.up), Column(verticalDirection: VerticalDirection.up)),
      "axis:attributes:textBaseline": ValueComparison(Group([], direction: Axis.vertical, attrs: TextBaseline.ideographic), Column(textBaseline: TextBaseline.ideographic)),
      "axis:attributes:multiple": ValueComparison(Group([], direction: Axis.vertical, attrs: [MainAxisAlignment.center, MainAxisSize.min]), Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min)),
      "axis:attributes:multiple:sameAttribute": ValueComparison(Group([], direction: Axis.vertical, attrs: [CrossAxisAlignment.stretch, TextDirection.rtl, CrossAxisAlignment.end]), Column(crossAxisAlignment: CrossAxisAlignment.end, textDirection: TextDirection.rtl)),
      "axis:attributes:multiple:sameType": ValueComparison(Group([], direction: Axis.vertical, attrs: [CrossAxisAlignment.end, TextDirection.rtl, CrossAxisAlignment.end]), Column(crossAxisAlignment: CrossAxisAlignment.end, textDirection: TextDirection.rtl)),
      "axis:children:empty": ValueComparison(Group([], direction: Axis.vertical, attrs: []), Column()),
      "axis:children:notEmpty": ValueComparison(Group([Text("A"), Text("B")], direction: Axis.vertical, attrs: []), Column(children: [Text("A"), Text("B")])),
      "axis:children:singleAttribute": ValueComparison(Group([Text("A"), Text("B")], direction: Axis.vertical, attrs: MainAxisSize.min), Column(mainAxisSize: MainAxisSize.min, children: [Text("A"), Text("B")])),
      "axis:children:multipleAttributes": ValueComparison(Group([Text("A"), Text("B")], direction: Axis.vertical, attrs: [MainAxisSize.min, CrossAxisAlignment.end]), Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [Text("A"), Text("B")])),
      "col:attributes:empty": ValueComparison(Group.col([]), Column()),
      "col:attributes:mainAxisAlignment": ValueComparison(Group.col([], attrs: MainAxisAlignment.center), Column(mainAxisAlignment: MainAxisAlignment.center)),
      "col:attributes:mainAxisSize": ValueComparison(Group.col([], attrs: MainAxisSize.min), Column(mainAxisSize: MainAxisSize.min)),
      "col:attributes:crossAxisAlignment": ValueComparison(Group.col([], attrs: CrossAxisAlignment.end), Column(crossAxisAlignment: CrossAxisAlignment.end)),
      "col:attributes:textDirection": ValueComparison(Group.col([], attrs: TextDirection.rtl), Column(textDirection: TextDirection.rtl)),
      "col:attributes:verticalDirection": ValueComparison(Group.col([], attrs: VerticalDirection.up), Column(verticalDirection: VerticalDirection.up)),
      "col:attributes:textBaseline": ValueComparison(Group.col([], attrs: TextBaseline.ideographic), Column(textBaseline: TextBaseline.ideographic)),
      "col:attributes:multiple": ValueComparison(Group.col([], attrs: [MainAxisAlignment.center, MainAxisSize.min]), Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min)),
      "col:attributes:multiple:sameAttribute": ValueComparison(Group.col([], attrs: [CrossAxisAlignment.stretch, TextDirection.rtl, CrossAxisAlignment.end]), Column(crossAxisAlignment: CrossAxisAlignment.end, textDirection: TextDirection.rtl)),
      "col:attributes:multiple:sameType": ValueComparison(Group.col([], attrs: [CrossAxisAlignment.end, TextDirection.rtl, CrossAxisAlignment.end]), Column(crossAxisAlignment: CrossAxisAlignment.end, textDirection: TextDirection.rtl)),
      "col:children:empty": ValueComparison(Group.col([], attrs: []), Column()),
      "col:children:notEmpty": ValueComparison(Group.col([Text("A"), Text("B")], attrs: []), Column(children: [Text("A"), Text("B")])),
      "col:children:singleAttribute": ValueComparison(Group.col([Text("A"), Text("B")], attrs: MainAxisSize.min), Column(mainAxisSize: MainAxisSize.min, children: [Text("A"), Text("B")])),
      "col:children:multipleAttributes": ValueComparison(Group.col([Text("A"), Text("B")], attrs: [MainAxisSize.min, CrossAxisAlignment.end]), Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [Text("A"), Text("B")])),
    }, compare: (actual, expected) {
      Comparator(actual, expected)
        ..compareBy((column) => column.direction)
        ..compareBy((column) => column.mainAxisAlignment)
        ..compareBy((column) => column.mainAxisSize)
        ..compareBy((column) => column.crossAxisAlignment)
        ..compareBy((column) => column.textDirection)
        ..compareBy((column) => column.verticalDirection)
        ..compareBy((column) => column.textBaseline)
        ..compareBy((column) => column.children.length);
    }),
    WidgetValueTest<Row, Group>({
      "axis:attributes:empty": ValueComparison(Group([], direction: Axis.horizontal), Row()),
      "axis:attributes:mainAxisAlignment": ValueComparison(Group([], direction: Axis.horizontal, attrs: MainAxisAlignment.center), Row(mainAxisAlignment: MainAxisAlignment.center)),
      "axis:attributes:mainAxisSize": ValueComparison(Group([], direction: Axis.horizontal, attrs: MainAxisSize.min), Row(mainAxisSize: MainAxisSize.min)),
      "axis:attributes:crossAxisAlignment": ValueComparison(Group([], direction: Axis.horizontal, attrs: CrossAxisAlignment.end), Row(crossAxisAlignment: CrossAxisAlignment.end)),
      "axis:attributes:textDirection": ValueComparison(Group([], direction: Axis.horizontal, attrs: TextDirection.rtl), Row(textDirection: TextDirection.rtl)),
      "axis:attributes:verticalDirection": ValueComparison(Group([], direction: Axis.horizontal, attrs: VerticalDirection.up), Row(verticalDirection: VerticalDirection.up)),
      "axis:attributes:textBaseline": ValueComparison(Group([], direction: Axis.horizontal, attrs: TextBaseline.ideographic), Row(textBaseline: TextBaseline.ideographic)),
      "axis:attributes:multiple": ValueComparison(Group([], direction: Axis.horizontal, attrs: [MainAxisAlignment.center, MainAxisSize.min]), Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min)),
      "axis:attributes:multiple:sameAttribute": ValueComparison(Group([], direction: Axis.horizontal, attrs: [CrossAxisAlignment.stretch, TextDirection.rtl, CrossAxisAlignment.end]), Row(crossAxisAlignment: CrossAxisAlignment.end, textDirection: TextDirection.rtl)),
      "axis:attributes:multiple:sameType": ValueComparison(Group([], direction: Axis.horizontal, attrs: [CrossAxisAlignment.end, TextDirection.rtl, CrossAxisAlignment.end]), Row(crossAxisAlignment: CrossAxisAlignment.end, textDirection: TextDirection.rtl)),
      "axis:children:empty": ValueComparison(Group([], direction: Axis.horizontal, attrs: []), Row()),
      "axis:children:notEmpty": ValueComparison(Group([Text("A"), Text("B")], direction: Axis.horizontal, attrs: []), Row(children: [Text("A"), Text("B")])),
      "axis:children:singleAttribute": ValueComparison(Group([Text("A"), Text("B")], direction: Axis.horizontal, attrs: MainAxisSize.min), Row(mainAxisSize: MainAxisSize.min, children: [Text("A"), Text("B")])),
      "axis:children:multipleAttributes": ValueComparison(Group([Text("A"), Text("B")], direction: Axis.horizontal, attrs: [MainAxisSize.min, CrossAxisAlignment.end]), Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [Text("A"), Text("B")])),
      "row:attributes:empty": ValueComparison(Group.row([]), Row()),
      "row:attributes:mainAxisAlignment": ValueComparison(Group.row([], attrs: MainAxisAlignment.center), Row(mainAxisAlignment: MainAxisAlignment.center)),
      "row:attributes:mainAxisSize": ValueComparison(Group.row([], attrs: MainAxisSize.min), Row(mainAxisSize: MainAxisSize.min)),
      "row:attributes:crossAxisAlignment": ValueComparison(Group.row([], attrs: CrossAxisAlignment.end), Row(crossAxisAlignment: CrossAxisAlignment.end)),
      "row:attributes:textDirection": ValueComparison(Group.row([], attrs: TextDirection.rtl), Row(textDirection: TextDirection.rtl)),
      "row:attributes:verticalDirection": ValueComparison(Group.row([], attrs: VerticalDirection.up), Row(verticalDirection: VerticalDirection.up)),
      "row:attributes:textBaseline": ValueComparison(Group.row([], attrs: TextBaseline.ideographic), Row(textBaseline: TextBaseline.ideographic)),
      "row:attributes:multiple": ValueComparison(Group.row([], attrs: [MainAxisAlignment.center, MainAxisSize.min]), Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min)),
      "row:attributes:multiple:sameAttribute": ValueComparison(Group.row([], attrs: [CrossAxisAlignment.stretch, TextDirection.rtl, CrossAxisAlignment.end]), Row(crossAxisAlignment: CrossAxisAlignment.end, textDirection: TextDirection.rtl)),
      "row:attributes:multiple:sameType": ValueComparison(Group.row([], attrs: [CrossAxisAlignment.end, TextDirection.rtl, CrossAxisAlignment.end]), Row(crossAxisAlignment: CrossAxisAlignment.end, textDirection: TextDirection.rtl)),
      "row:children:empty": ValueComparison(Group.row([], attrs: []), Row()),
      "row:children:notEmpty": ValueComparison(Group.row([Text("A"), Text("B")], attrs: []), Row(children: [Text("A"), Text("B")])),
      "row:children:singleAttribute": ValueComparison(Group.row([Text("A"), Text("B")], attrs: MainAxisSize.min), Row(mainAxisSize: MainAxisSize.min, children: [Text("A"), Text("B")])),
      "row:children:multipleAttributes": ValueComparison(Group.row([Text("A"), Text("B")], attrs: [MainAxisSize.min, CrossAxisAlignment.end]), Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [Text("A"), Text("B")])),
    }, compare: (actual, expected) {
      Comparator(actual, expected)
        ..compareBy((row) => row.direction)
        ..compareBy((row) => row.mainAxisAlignment)
        ..compareBy((row) => row.mainAxisSize)
        ..compareBy((row) => row.crossAxisAlignment)
        ..compareBy((row) => row.textDirection)
        ..compareBy((row) => row.verticalDirection)
        ..compareBy((row) => row.textBaseline)
        ..compareBy((row) => row.children.length);
    }),
    SimpleTestCase({
      "SimpleFutureBuilder": (tester) async {
        final Completer<int> completer = Completer();
        await tester.pumpWidget(createApp(SimpleFutureBuilder<int>(
          completer.future,
          builder: (_, data) => Text("$data"),
        )));

        expect(
          find.byWidgetPredicate((widget) => widget is Center && widget.child is CircularProgressIndicator),
          findsOneWidget,
        );
        completer.complete(42);
        await tester.pump();
        expect(find.text("42"), findsOneWidget);
      },
      "SimpleStreamBuilder": (tester) async {
        final StreamController<int> controller = StreamController();

        await tester.pumpWidget(createApp(SimpleStreamBuilder<int>(
          controller.stream,
          builder: (_, data) => Text("$data"),
        )));

        expect(
          find.byWidgetPredicate((widget) => widget is Center && widget.child is CircularProgressIndicator),
          findsOneWidget,
        );
        controller.add(4);
        await tester.pump(Duration.zero);
        expect(find.text("4"), findsOneWidget);

        controller.add(16);
        await tester.pump(Duration.zero);
        expect(find.text("4"), findsNothing);
        expect(find.text("16"), findsOneWidget);

        controller.add(64);
        await tester.pump(Duration.zero);
        expect(find.text("4"), findsNothing);
        expect(find.text("16"), findsNothing);
        expect(find.text("64"), findsOneWidget);

        await controller.close();
      }
    }),
    OnDemandListViewTest({
      "indexed": OnDemandListViewSetup((values) => OnDemandListView.indexed(values, (_, i, v) => Text("${values[i]}$v"), shrinkWrap: true), onText: (v) => "$v$v"),
      "mapped": OnDemandListViewSetup((values) => OnDemandListView.mapped(values, (_, v) => Text("$v"), shrinkWrap: true)),
      "from": OnDemandListViewSetup((values) => OnDemandListView.from(values.map((v) => Text("$v")).toList(), shrinkWrap: true)),
    }),
    TapOutsideToUnfocusTest({
      "disabled": TapOutsideCaseSetup((w) => Container(child: w), focusOnEnd: true),
      "enabled": TapOutsideCaseSetup((w) => TapOutsideToUnfocus(child: w), focusOnEnd: false),
    }),
    TestCaseGroup("BuildContextUtils", {
      "screenSize": (tester) async {
        Size? screenSize;
        Size? mediaSize;

        // @formatter:off
        final Widget first = Scaffold(body: Builder(builder: (context) {
          screenSize = context.screenSize;
          mediaSize = MediaQuery.of(context).size;
          return Text(data);
        }));
        // @formatter:on

        expect(screenSize, null);
        expect(mediaSize, null);
        await tester.pumpWidget(createApp(first));
        expect(find.text(data), findsOneWidget);

        expect(screenSize, isNotNull);
        expect(screenSize, mediaSize);
      },
      "push": (tester) async {
        int replaceCount = 0;
        int pushCount = 0;

        // @formatter:off
        final Widget second = Scaffold(body: Builder(builder: (context) => TextButton(child: Text(data + data), onPressed: () {})));
        final Widget first = Scaffold(body: Builder(builder: (context) => TextButton(child: Text(data), onPressed: () => context.push(second))));
        final TestObserver observer = TestObserver(onPushed: (_, __) => ++pushCount, onReplaced: (_, __) => ++replaceCount);
        // @formatter:on

        await tester.pumpWidget(createApp(first, observer));
        expect(pushCount, 1);
        expect(replaceCount, 0);
        expect(find.text(data), findsOneWidget);
        expect(find.text(data + data), findsNothing);

        await tester.tap(find.text(data));
        await tester.pumpAndSettle();

        expect(pushCount, 2);
        expect(replaceCount, 0);
        expect(find.text(data), findsNothing);
        expect(find.text(data + data), findsOneWidget);
      },
      "pushNamed": (tester) async {
        int replaceCount = 0;
        int pushCount = 0;

        // @formatter:off
        final Widget second = Scaffold(body: Builder(builder: (context) => TextButton(child: Text(data + data), onPressed: () {})));
        final Widget first = Scaffold(body: Builder(builder: (context) => TextButton(child: Text(data), onPressed: () => context.pushNamed("/second"))));
        final TestObserver observer = TestObserver(onPushed: (_, __) => ++pushCount, onReplaced: (_, __) => ++replaceCount);
        // @formatter:on

        await tester.pumpWidget(MaterialApp(initialRoute: "/first", routes: {
          "/first": (_) => first,
          "/second": (_) => second,
        }, navigatorObservers: [
          observer
        ]));

        expect(pushCount, 1);
        expect(replaceCount, 0);
        expect(find.text(data), findsOneWidget);
        expect(find.text(data + data), findsNothing);

        await tester.tap(find.text(data));
        await tester.pumpAndSettle();

        expect(pushCount, 2);
        expect(replaceCount, 0);
        expect(find.text(data), findsNothing);
        expect(find.text(data + data), findsOneWidget);
      },
      "pushReplacement": (tester) async {
        int replaceCount = 0;
        int pushCount = 0;

        // @formatter:off
        final Widget second = Scaffold(body: Builder(builder: (context) => TextButton(child: Text(data + data), onPressed: () {})));
        final Widget first = Scaffold(body: Builder(builder: (context) => TextButton(child: Text(data), onPressed: () => context.push(second, replace: true))));
        final TestObserver observer = TestObserver(onPushed: (_, __) => ++pushCount, onReplaced: (_, __) => ++replaceCount);
        // @formatter:on

        await tester.pumpWidget(createApp(first, observer));
        expect(pushCount, 1);
        expect(replaceCount, 0);
        expect(find.text(data), findsOneWidget);
        expect(find.text(data + data), findsNothing);

        await tester.tap(find.text(data));
        await tester.pumpAndSettle();

        expect(pushCount, 1);
        expect(replaceCount, 1);
        expect(find.text(data), findsNothing);
        expect(find.text(data + data), findsOneWidget);
      },
      "pushReplacementNamed": (tester) async {
        int replaceCount = 0;
        int pushCount = 0;

        // @formatter:off
        final Widget second = Scaffold(body: Builder(builder: (context) => TextButton(child: Text(data + data), onPressed: () {})));
        final Widget first = Scaffold(body: Builder(builder: (context) => TextButton(child: Text(data), onPressed: () => context.pushNamed("/second", replace: true))));
        final TestObserver observer = TestObserver(onPushed: (_, __) => ++pushCount, onReplaced: (_, __) => ++replaceCount);
        // @formatter:on

        await tester.pumpWidget(MaterialApp(initialRoute: "/first", routes: {
          "/first": (_) => first,
          "/second": (_) => second,
        }, navigatorObservers: [
          observer
        ]));

        expect(pushCount, 1);
        expect(replaceCount, 0);
        expect(find.text(data), findsOneWidget);
        expect(find.text(data + data), findsNothing);

        await tester.tap(find.text(data));
        await tester.pumpAndSettle();

        expect(pushCount, 1);
        expect(replaceCount, 1);
        expect(find.text(data), findsNothing);
        expect(find.text(data + data), findsOneWidget);
      },
      "pop": (tester) async {
        int pushCount = 0;
        int popCount = 0;

        // @formatter:off
        final Widget second = Scaffold(body: Builder(builder: (context) => TextButton(child: Text(data + data), onPressed: () => context.pop())));
        final Widget first = Scaffold(body: Builder(builder: (context) => TextButton(child: Text(data), onPressed: () => context.push(second))));
        final TestObserver observer = TestObserver(onPushed: (_, __) => ++pushCount, onPopped: (_, __) => ++popCount);
        // @formatter:on

        await tester.pumpWidget(createApp(first, observer));
        expect(popCount, 0);
        expect(pushCount, 1);
        expect(find.text(data), findsOneWidget);
        expect(find.text(data + data), findsNothing);

        await tester.tap(find.text(data));
        await tester.pumpAndSettle();

        expect(popCount, 0);
        expect(pushCount, 2);
        expect(find.text(data), findsNothing);
        expect(find.text(data + data), findsOneWidget);

        await tester.tap(find.text(data + data));
        await tester.pumpAndSettle();

        expect(popCount, 1);
        expect(pushCount, 2);
        expect(find.text(data), findsOneWidget);
        expect(find.text(data + data), findsNothing);
      },
      "pop:value": (tester) async {
        bool? popResult;
        int pushCount = 0;
        int popCount = 0;

        // @formatter:off
        final Widget second = Scaffold(body: Builder(builder: (context) => TextButton(child: Text(data + data), onPressed: () => context.pop(true))));
        final Widget first = Scaffold(body: Builder(builder: (context) => TextButton(child: Text(data), onPressed: () async => popResult = await context.push(second))));
        final TestObserver observer = TestObserver(onPushed: (_, __) => ++pushCount, onPopped: (_, __) => ++popCount);
        // @formatter:on

        await tester.pumpWidget(createApp(first, observer));
        expect(popCount, 0);
        expect(pushCount, 1);
        expect(popResult, null);
        expect(find.text(data), findsOneWidget);
        expect(find.text(data + data), findsNothing);

        await tester.tap(find.text(data));
        await tester.pumpAndSettle();

        expect(popCount, 0);
        expect(pushCount, 2);
        expect(popResult, null);
        expect(find.text(data), findsNothing);
        expect(find.text(data + data), findsOneWidget);

        await tester.tap(find.text(data + data));
        await tester.pumpAndSettle();

        expect(popCount, 1);
        expect(pushCount, 2);
        expect(popResult, true);
        expect(find.text(data), findsOneWidget);
        expect(find.text(data + data), findsNothing);
      },
      "maybePop": (tester) async {
        bool? popResult;
        int pushCount = 0;
        int popCount = 0;
        int maybePopCount = 0;

        // @formatter:off
        final Widget second = Scaffold(body: WillPopScope(onWillPop: () async {
          ++maybePopCount;
          return false;
        }, child: Builder(builder: (context) => TextButton(child: Text(data + data), onPressed: () => context.maybePop(true)))));
        final Widget first = Scaffold(body: Builder(builder: (context) => TextButton(child: Text(data), onPressed: () async => popResult = await context.push(second))));
        final TestObserver observer = TestObserver(onPushed: (_, __) => ++pushCount, onPopped: (_, __) => ++popCount);
        // @formatter:on

        await tester.pumpWidget(createApp(first, observer));
        expect(popCount, 0);
        expect(maybePopCount, 0);
        expect(pushCount, 1);
        expect(popResult, null);
        expect(find.text(data), findsOneWidget);
        expect(find.text(data + data), findsNothing);

        await tester.tap(find.text(data));
        await tester.pumpAndSettle();

        expect(popCount, 0);
        expect(maybePopCount, 0);
        expect(pushCount, 2);
        expect(popResult, null);
        expect(find.text(data), findsNothing);
        expect(find.text(data + data), findsOneWidget);

        await tester.tap(find.text(data + data));
        await tester.pumpAndSettle();

        expect(popCount, 0);
        expect(maybePopCount, 1);
        expect(pushCount, 2);
        expect(popResult, null);
        expect(find.text(data), findsNothing);
        expect(find.text(data + data), findsOneWidget);
      },
    }),
    SplashScreenTest({
      "default:shorter": SplashCaseSetup(init: 1),
      "default:longer": SplashCaseSetup(init: 5),
      "custom:shorter": SplashCaseSetup(init: 1, splash: 2),
      "custom:longer": SplashCaseSetup(splash: 2, init: 5),
    }),
    SimpleSplashScreenTest({"default": null, "custom": 1}),
    SimpleDialogTest({"default": null, "custom": "ABCDE"}),
    BinaryDialogTest({
      "default": BinaryDialogCaseSetup(),
      "custom": BinaryDialogCaseSetup(positiveText: "ABC", negativeText: "DEF"),
    }),
    UnitTest(
        "asap",
        () => expect(
            asap(() => print("ok")).then((_) => true).catchError((_) => false),
            completion(isTrue))),
  ];
  // @formatter:on

  cases.forEach((c) => c.run());
}
