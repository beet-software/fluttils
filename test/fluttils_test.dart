import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttils/fluttils.dart' as f;

import 'cases.dart';
import 'utils.dart';

void main() {
  // @formatter:off
  final List<RunnableTest> cases = [
    WidgetValueTest<Text, f.Text>({
      "data": ValueComparison(f.Text(data), Text(data)),
      "empty": ValueComparison(f.Text(data, []), Text(data, style: TextStyle())),
      "color": ValueComparison(f.Text(data, [Colors.red]), Text(data, style: TextStyle(color: Colors.red))),
      "fontWeight": ValueComparison(f.Text(data, [FontWeight.bold]), Text(data, style: TextStyle(fontWeight: FontWeight.bold))),
      "textAlign": ValueComparison(f.Text(data, [TextAlign.center]), Text(data, textAlign: TextAlign.center)),
      "fontSize:double": ValueComparison(f.Text(data, [34.0]), Text(data, style: TextStyle(fontSize: 34))),
      "fontSize:int": ValueComparison(f.Text(data, [34]), Text(data, style: TextStyle(fontSize: 34))),
      "fontStyle": ValueComparison(f.Text(data, [FontStyle.italic]), Text(data, style: TextStyle(fontStyle: FontStyle.italic))),
      "locale": ValueComparison(f.Text(data, [Locale("en")]), Text(data, style: TextStyle(locale: Locale("en")))),
      "decoration": ValueComparison(f.Text(data, [TextDecoration.lineThrough]), Text(data, style: TextStyle(decoration: TextDecoration.lineThrough))),
      "color, fontWeight": ValueComparison(f.Text(data, [Colors.blue, FontWeight.w100]), Text(data, style: TextStyle(fontWeight: FontWeight.w100, color: Colors.blue))),
      "fontStyle, fontStyle": ValueComparison(f.Text(data, [FontStyle.italic, FontStyle.normal]), Text(data, style: TextStyle(fontStyle: FontStyle.normal))),
      "color, fontStyle, fontWeight, color, fontWeight": ValueComparison(f.Text(data, [Colors.red, FontStyle.italic, FontWeight.w100, Colors.redAccent, FontWeight.bold]), Text(data,style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
    }, compare: (actual, expected) {
      expect(actual.data, expected.data);
      expect(actual.style, expected.style);
      expect(actual.textAlign, expected.textAlign);
    }),
    TypeTest<EdgeInsets, f.EdgeInsets>({
      "all": TypeComparison(f.EdgeInsets(all: 5), EdgeInsets.all(5)),
      "symmetric": TypeComparison(f.EdgeInsets(width: 2, height: 3), EdgeInsets.symmetric(horizontal: 2, vertical: 3)),
      "only": TypeComparison(f.EdgeInsets(left: 1, top: 4), EdgeInsets.only(left: 1, top: 4)),
      "all, symmetric": TypeComparison(f.EdgeInsets(all: 5, right: 3), EdgeInsets.only(left: 5, right: 3, top: 5, bottom: 5)),
      "all, only": TypeComparison(f.EdgeInsets(all: 1, top: 2), EdgeInsets.only(left: 1, right: 1, top: 2, bottom: 1)),
      "symmetric, only": TypeComparison(f.EdgeInsets(width: 10, top: 5), EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 0)),
      "symmetric, symmetric, only": TypeComparison(f.EdgeInsets(width: 1, height: 15, top: 5), EdgeInsets.only(left: 1, right: 1, top: 5, bottom: 15)),
      "all, symmetric, only": TypeComparison(f.EdgeInsets(all: 10, width: 20, top: 5), EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 10)),
    }, compare: (actual, expected) {
      Comparator(actual, expected)
        ..compareBy((insets) => insets.top)
        ..compareBy((insets) => insets.bottom)
        ..compareBy((insets) => insets.left)
        ..compareBy((insets) => insets.right);
    }),
    WidgetValueTest<Padding, f.Padding>({
      "all": ValueComparison(f.Padding(all: 5, child: dummy), Padding(padding: EdgeInsets.all(5), child: dummy)),
      "symmetric": ValueComparison(f.Padding(width: 2, height: 3, child: dummy), Padding(padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3), child: dummy)),
      "only": ValueComparison(f.Padding(left: 1, top: 4, child: dummy), Padding(padding: EdgeInsets.only(left: 1, top: 4))),
      "all, symmetric": ValueComparison(f.Padding(all: 5, right: 3, child: dummy), Padding(padding: EdgeInsets.only(left: 5, right: 3, top: 5, bottom: 5))),
      "all, only": ValueComparison(f.Padding(all: 1, top: 2, child: dummy), Padding(padding: EdgeInsets.only(left: 1, right: 1, top: 2, bottom: 1))),
      "symmetric, only": ValueComparison(f.Padding(width: 10, top: 5, child: dummy), Padding(padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 0))),
      "symmetric, symmetric, only": ValueComparison(f.Padding(width: 1, height: 15, top: 5, child: dummy), Padding(padding: EdgeInsets.only(left: 1, right: 1, top: 5, bottom: 15))),
      "all, symmetric, only": ValueComparison(f.Padding(all: 10, width: 20, top: 5, child: dummy), Padding(padding: EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 10))),
    }, compare: (actual, expected) {
      expect(actual.padding, expected.padding);
    }),
    WidgetTypeTest<SizedBox, f.Width>({
      "null": TypeComparison(f.Width(), SizedBox(width: 0)),
      "value": TypeComparison(f.Width(10), SizedBox(width: 10)),
    }, compare: (actual, expected) {
      expect(actual.width, expected.width);
      expect(actual.height, expected.height);
    }),
    WidgetTypeTest<SizedBox, f.Height>({
      "null": TypeComparison(f.Height(), SizedBox(height: 0)),
      "value": TypeComparison(f.Height(10), SizedBox(height: 10)),
    }, compare: (actual, expected) {
      expect(actual.width, expected.width);
      expect(actual.height, expected.height);
    }),
    WidgetValueTest<Stack, f.MapStack>({
      "empty": ValueComparison(f.MapStack({}), Stack()),
      "center": ValueComparison(f.MapStack({Alignment.center: Text(data)}), Stack(children: [Align(alignment: Alignment.center, child: Text(data))])),
      "multiple": ValueComparison(f.MapStack({Alignment.topLeft: Text(data), Alignment.bottomRight: Text(data + data)}), Stack(children: [Align(alignment: Alignment.topLeft, child: Text(data)), Align(alignment: Alignment.bottomRight, child: Text(data + data))])),
    }, compare: (actual, expected) {
      expect(decodeStack(actual), decodeStack(expected));
    }),
    WidgetValueTest<SafeArea, f.SafeScaffold>({
      "empty": ValueComparison(f.SafeScaffold(), SafeArea(child: Scaffold())),
      "with body": ValueComparison(f.SafeScaffold(body: Text(data)), SafeArea(child: Scaffold(body: Text(data)))),
    }, compare: (actual, expected) {
      expect(decodeSafeScaffold(actual), decodeSafeScaffold(expected));
    }),
    WidgetValueTest<Visibility, f.Visibility>({
      "invisible:none": ValueComparison(f.Visibility(child: dummy, visible: false, level: f.VisibilityLevel.none()), Visibility(child: dummy, visible: false)),
      "invisible:state": ValueComparison(f.Visibility(child: dummy, visible: false, level: f.VisibilityLevel.state()), Visibility(child: dummy, visible: false, maintainState: true)),
      "invisible:animation": ValueComparison(f.Visibility(child: dummy, visible: false, level: f.VisibilityLevel.animation()), Visibility(child: dummy, visible: false, maintainState: true, maintainAnimation: true)),
      "invisible:size": ValueComparison(f.Visibility(child: dummy, visible: false, level: f.VisibilityLevel.size()), Visibility(child: dummy, visible: false, maintainState: true, maintainAnimation: true, maintainSize: true)),
      "invisible:semantics": ValueComparison(f.Visibility(child: dummy, visible: false, level: f.VisibilityLevel.size(maintainSemantics: true)), Visibility(child: dummy, visible: false, maintainState: true, maintainAnimation: true, maintainSize: true, maintainSemantics: true)),
      "invisible:interactivity": ValueComparison(f.Visibility(child: dummy, visible: false, level: f.VisibilityLevel.size(maintainInteractivity: true)), Visibility(child: dummy, visible: false, maintainState: true, maintainAnimation: true, maintainSize: true, maintainInteractivity: true)),
    }, compare: (actual, expected) {
      Comparator(actual, expected)
        ..compareBy((visibility) => visibility.visible)
        ..compareBy((visibility) => visibility.maintainState)
        ..compareBy((visibility) => visibility.maintainSize)
        ..compareBy((visibility) => visibility.maintainAnimation)
        ..compareBy((visibility) => visibility.maintainSemantics)
        ..compareBy((visibility) => visibility.maintainInteractivity);
    }),
    WidgetValueTest<Flex, f.Separated>({
      "col:none": ValueComparison(f.Separated.col([], separator: Divider()), Column()),
      "col:one": ValueComparison(f.Separated.col([Text("A")], separator: Divider()), Column(children: [Text("A")])),
      "col:two": ValueComparison(f.Separated.col([Text("A"), Text("B")], separator: Divider()), Column(children: [Text("A"), Divider(), Text("B")])),
      "col:three": ValueComparison(f.Separated.col([Text("A"), Text("B"), Text("C")], separator: Divider()), Column(children: [Text("A"), Divider(), Text("B"), Divider(), Text("C")])),
      "row:none": ValueComparison(f.Separated.row([], separator: Divider()), Row()),
      "row:one": ValueComparison(f.Separated.row([Text("A")], separator: Divider()), Row(children: [Text("A")])),
      "row:two": ValueComparison(f.Separated.row([Text("A"), Text("B")], separator: Divider()), Row(children: [Text("A"), Divider(), Text("B")])),
      "row:three": ValueComparison(f.Separated.row([Text("A"), Text("B"), Text("C")], separator: Divider()), Row(children: [Text("A"), Divider(), Text("B"), Divider(), Text("C")])),
    }, compare: (actual, expected) {
      Comparator(actual, expected)
        ..compareBy((group) => group.direction)
        ..compareBy((group) => group.children.length)
        ..compareBy((group) => group.children.whereType<Divider>().length)
        ..compareBy((group) => group.children.whereType<Text>().length);
    }),
    SimpleTestCase({
      "SimpleFutureBuilder": (tester) async {
        final Completer<int> completer = Completer();
        await tester.pumpWidget(createApp(f.FutureBuilder<int>(
          completer.future,
          onDone: (_, data) => Text("$data"),
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

        await tester.pumpWidget(createApp(f.StreamBuilder<int>(
          controller.stream,
          onData: (_, data) => Text("$data"),
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
      "mapped": OnDemandListViewSetup((values) => f.MappedListView(values, builder: (_, v) => Text("$v"), shrinkWrap: true)),
    }),
    TapOutsideToUnfocusTest({
      "disabled": TapOutsideCaseSetup((w) => Scaffold(body: Container(child: w)), focusOnEnd: true),
      "enabled": TapOutsideCaseSetup((w) => Scaffold(body: f.ContextUnfocuser(child: w)), focusOnEnd: false),
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
      "custom:longer": SplashCaseSetup(init: 5, splash: 2),
    }),
    SimpleDialogTest({"custom": "ABCDE"}),
    BinaryDialogTest({"custom": BinaryDialogCaseSetup(positiveText: "ABC", negativeText: "DEF")}),
  ];
  // @formatter:on

  cases.forEach((c) => c.run());
}
