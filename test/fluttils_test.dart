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
    WidgetTest<Text, StyledText>({
      "empty": Comparison(StyledText(data, []), Text(data, style: TextStyle())),
      "color": Comparison(StyledText(data, [Colors.red]), Text(data, style: TextStyle(color: Colors.red))),
      "fontWeight": Comparison(StyledText(data, [FontWeight.bold]), Text(data, style: TextStyle(fontWeight: FontWeight.bold))),
      "fontSize:double": Comparison(StyledText(data, [34.0]), Text(data, style: TextStyle(fontSize: 34))),
      "fontSize:int": Comparison(StyledText(data, [34]), Text(data, style: TextStyle(fontSize: 34))),
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
    WidgetTest<Padding, SimplePadding>({
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
    WidgetTest<SizedBox, Width>({
      "null": Comparison(Width(), SizedBox()),
      "value": Comparison(Width(10), SizedBox(width: 10)),
    }, compare: (actual, expected) {
      expect(actual.width, expected.width);
      expect(actual.height, expected.height);
    }),
    WidgetTest<SizedBox, Height>({
      "null": Comparison(Height(), SizedBox()),
      "value": Comparison(Height(10), SizedBox(height: 10)),
    }, compare: (actual, expected) {
      expect(actual.width, expected.width);
      expect(actual.height, expected.height);
    }),
    WidgetTest<Stack, SimpleStack>({
      "empty": Comparison(SimpleStack({}), Stack()),
      "center": Comparison(SimpleStack({Alignment.center: Text(data)}), Stack(children: [Align(alignment: Alignment.center, child: Text(data))])),
      "multiple": Comparison(SimpleStack({Alignment.topLeft: Text(data), Alignment.bottomRight: Text(data + data)}), Stack(children: [Align(alignment: Alignment.topLeft, child: Text(data)), Align(alignment: Alignment.bottomRight, child: Text(data + data))])),
    }, compare: (actual, expected) {
      expect(decodeStack(actual), decodeStack(expected));
    }),
    WidgetTest<SafeArea, SafeScaffold>({
      "empty": Comparison(SafeScaffold(), SafeArea(child: Scaffold())),
      "with body": Comparison(SafeScaffold(body: Text(data)), SafeArea(child: Scaffold(body: Text(data)))),
    }, compare: (actual, expected) {
      expect(decodeSafeScaffold(actual), decodeSafeScaffold(expected));
    }),
    WidgetTest<Visibility, SimpleVisibility>({
      "visible": Comparison(SimpleVisibility(child: dummy, isVisible: true), Visibility(child: dummy, maintainState: true, maintainSize: true, maintainAnimation: true)),
      "invisible": Comparison(SimpleVisibility(child: dummy, isVisible: false), Visibility(child: dummy, visible: false, maintainState: true, maintainSize: true, maintainAnimation: true)),
    }, compare: (actual, expected) {
      expect(actual.visible, expected.visible);
      expect(actual.maintainState, expected.maintainState);
      expect(actual.maintainSize, expected.maintainSize);
      expect(actual.maintainAnimation, expected.maintainAnimation);
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
        Size screenSize;
        Size mediaSize;

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
        bool popResult;
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
        bool popResult;
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
    UnitTest("asap", () => expect(asap(() => print("ok")).then((_) => true).catchError((_) => false), completion(isTrue)))
  ];
  // @formatter:on

  cases.forEach((c) => c.run());
}
