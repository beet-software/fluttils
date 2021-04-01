import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttils/fluttils.dart';

import 'utils.dart';

abstract class TestCase {
  void run();
}

class WidgetCase<T extends Widget, W extends T> implements TestCase {
  final Map<String, Comparison<T>> comparisons;
  final void Function(T, T) compare;

  const WidgetCase(this.comparisons, {this.compare});

  @override
  void run() {
    group(W.toString(), () {
      comparisons.forEach((description, comparison) {
        testWidgets(description, (tester) async {
          await tester.pumpWidget(createApp(comparison.actual));
          final Iterable<Element> elements =
              find.byWidgetPredicate((widget) => widget is W).evaluate();

          final T widget = elements.single.widget as T;
          compare(widget, comparison.expected);
        });
      });
    });
  }
}

class SimpleBuildersCase implements TestCase {
  @override
  void run() {
    testWidgets("SimpleFutureBuilder", (tester) async {
      final Completer<int> completer = Completer();
      await tester.pumpWidget(createApp(SimpleFutureBuilder<int>(
        completer.future,
        builder: (_, data) => Text("$data"),
      )));

      expect(
        find.byWidgetPredicate((widget) {
          return widget is Center && widget.child is CircularProgressIndicator;
        }),
        findsOneWidget,
      );
      completer.complete(42);
      await tester.pump();
      expect(find.text("42"), findsOneWidget);
    });

    testWidgets("SimpleStreamBuilder", (tester) async {
      final StreamController<int> controller = StreamController();

      await tester.pumpWidget(createApp(SimpleStreamBuilder<int>(
        controller.stream,
        builder: (_, data) => Text("$data"),
      )));

      expect(
        find.byWidgetPredicate((widget) {
          return widget is Center && widget.child is CircularProgressIndicator;
        }),
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
    });
  }
}

class ListViewCase implements TestCase {
  @override
  void run() {
    group("OnDemandListView", () {
      testWidgets("indexed", (tester) async {
        await tester.pumpWidget(
          createApp(
            OnDemandListView.indexed(
                [1, 2, 3, 4, 5], (_, i, v) => Text("${i + v}"),
                shrinkWrap: true),
          ),
        );

        for (int i = 1; i <= 7; i += 2) expect(find.text("$i"), findsOneWidget);
      });

      testWidgets("mapped", (tester) async {
        await tester.pumpWidget(
          createApp(
            OnDemandListView.mapped([6, 8, 10, 12, 14], (_, v) => Text("$v"),
                shrinkWrap: true),
          ),
        );

        for (int i = 6; i <= 14; i += 2)
          expect(find.text("$i"), findsOneWidget);
      });

      testWidgets("from", (tester) async {
        await tester.pumpWidget(
          createApp(OnDemandListView.from(
              [Text("10"), Text("20"), Text("30"), Text("40"), Text("50")],
              shrinkWrap: true)),
        );

        for (int i = 10; i <= 50; i += 10)
          expect(find.text("$i"), findsOneWidget);
      });
    });
  }
}

class TapOutsideCase implements TestCase {
  void _test(String name, Widget Function(Widget) builder, bool expected) {
    testWidgets(name, (tester) async {
      bool isFocused = false;

      final FocusNode node = FocusNode();
      node.addListener(() => isFocused = node.hasFocus);

      final Text text = Text(data);
      final TextFormField field = TextFormField(focusNode: node);
      await tester.pumpWidget(createApp(builder(
        Column(mainAxisSize: MainAxisSize.min, children: [text, field]),
      )));

      await tester.tap(find.byWidget(field));
      await tester.pumpAndSettle();
      expect(isFocused, true);

      await tester.tap(find.byWidget(text));
      await tester.pump();
      expect(isFocused, expected);
    });
  }

  @override
  void run() {
    group("TapOutsideToUnfocus", () {
      _test("disabled", (widget) => Container(child: widget), true);
      _test("enabled", (widget) => TapOutsideToUnfocus(child: widget), false);
    });
  }
}

class NavigationCase implements TestCase {
  @override
  void run() {
    group("BuildContextUtils", () {
      testWidgets("screenSize", (tester) async {
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
      });
      testWidgets("push", (tester) async {
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
      });
      testWidgets("pushNamed", (tester) async {
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
      });
      testWidgets("pushReplacement", (tester) async {
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
      });
      testWidgets("pushReplacementNamed", (tester) async {
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
      });
      testWidgets("pop", (tester) async {
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
      });
      testWidgets("pop value", (tester) async {
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
      });
      testWidgets("maybePop", (tester) async {
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
      });
    });
  }
}

class SplashScreenCase implements TestCase {
  @override
  void run() {
    group("SplashScreen", () {
      testWidgets("shorter", (tester) async {
        final Future<void> init = Future.delayed(Duration(seconds: 1));

        final Widget first = Scaffold(body: Text(data + data));
        final Widget splash = SplashScreen(
            content: Text(data), builder: (_) => first, init: init);

        await tester.pumpWidget(createApp(splash));

        await tester.pump(Duration(seconds: 1));
        expect(find.text(data), findsOneWidget);
        expect(find.text(data + data), findsNothing);

        await tester.pump(Duration(seconds: 2));
        expect(find.text(data), findsOneWidget);
        expect(find.text(data + data), findsNothing);

        await tester.pumpAndSettle();
        expect(find.text(data), findsNothing);
        expect(find.text(data + data), findsOneWidget);
      });
      testWidgets("longer", (tester) async {
        final Future<void> init = Future.delayed(Duration(seconds: 5));

        final Widget first = Scaffold(body: Text(data + data));
        final Widget splash = SplashScreen(
            content: Text(data), builder: (_) => first, init: init);

        await tester.pumpWidget(createApp(splash));

        await tester.pump(Duration(seconds: 3));
        expect(find.text(data), findsOneWidget);
        expect(find.text(data + data), findsNothing);

        await tester.pump(Duration(seconds: 2));
        expect(find.text(data), findsOneWidget);
        expect(find.text(data + data), findsNothing);

        await tester.pumpAndSettle();
        expect(find.text(data), findsNothing);
        expect(find.text(data + data), findsOneWidget);
      });
      testWidgets("custom", (tester) async {
        final Future<void> init = Future.delayed(Duration(seconds: 3));

        final Widget first = Scaffold(body: Text(data + data));
        final Widget splash = SplashScreen(
            duration: Duration(seconds: 1),
            content: Text(data),
            builder: (_) => first,
            init: init);

        await tester.pumpWidget(createApp(splash));

        await tester.pump(Duration(seconds: 1));
        expect(find.text(data), findsOneWidget);
        expect(find.text(data + data), findsNothing);

        await tester.pump(Duration(seconds: 2));
        expect(find.text(data), findsOneWidget);
        expect(find.text(data + data), findsNothing);

        await tester.pumpAndSettle();
        expect(find.text(data), findsNothing);
        expect(find.text(data + data), findsOneWidget);
      });
    });
    group("SimpleSplashScreen", () {
      testWidgets("default", (tester) async {
        final Widget first = Scaffold(body: Text(data + data));
        final Widget splash =
            SimpleSplashScreen(content: Text(data), builder: (_) => first);

        await tester.pumpWidget(createApp(splash));

        await tester.pump(Duration(seconds: 3));
        expect(find.text(data), findsOneWidget);
        expect(find.text(data + data), findsNothing);

        await tester.pumpAndSettle();
        expect(find.text(data), findsNothing);
        expect(find.text(data + data), findsOneWidget);
      });
      testWidgets("custom", (tester) async {
        final Widget first = Scaffold(body: Text(data + data));
        final Widget splash = SimpleSplashScreen(
          duration: Duration(seconds: 1),
          content: Text(data),
          builder: (_) => first,
        );

        await tester.pumpWidget(createApp(splash));

        await tester.pump(Duration(seconds: 1));
        expect(find.text(data), findsOneWidget);
        expect(find.text(data + data), findsNothing);

        await tester.pumpAndSettle();
        expect(find.text(data), findsNothing);
        expect(find.text(data + data), findsOneWidget);
      });
    });
  }
}

class DialogsCase implements TestCase {
  @override
  void run() {
    group("showSimpleDialog", () {
      testWidgets("default", (tester) async {
        await tester.pumpWidget(createApp(
          Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                child: Text(data),
                onPressed: () =>
                    showSimpleDialog(context, Text(data * 2), Text(data * 3)),
              ),
            ),
          ),
        ));

        await tester.tap(find.text(data));
        await tester.pumpAndSettle();

        expect(find.text(data * 2), findsOneWidget);
        expect(find.text(data * 3), findsOneWidget);
        expect(find.text("OK"), findsOneWidget);

        await tester.tap(find.text("OK"));
        await tester.pumpAndSettle();
      });
      testWidgets("custom", (tester) async {
        await tester.pumpWidget(createApp(
          Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                child: Text(data),
                onPressed: () => showSimpleDialog(
                    context, Text(data * 2), Text(data * 3),
                    positiveText: data * 4),
              ),
            ),
          ),
        ));

        await tester.tap(find.text(data));
        await tester.pumpAndSettle();

        expect(find.text(data * 2), findsOneWidget);
        expect(find.text(data * 3), findsOneWidget);
        expect(find.text(data * 4), findsOneWidget);

        await tester.tap(find.text(data * 4));
        await tester.pumpAndSettle();
      });
    });
    group("showBinaryDialog", () {
      testWidgets("default", (tester) async {
        bool popResult;
        await tester.pumpWidget(createApp(
          Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                child: Text(data),
                onPressed: () async {
                  popResult = await showBinaryDialog(
                      context, Text(data * 2), Text(data * 3));
                },
              ),
            ),
          ),
        ));

        await tester.tap(find.text(data));
        await tester.pumpAndSettle();

        expect(popResult, null);
        expect(find.text(data * 2), findsOneWidget);
        expect(find.text(data * 3), findsOneWidget);
        expect(find.text("YES"), findsOneWidget);
        expect(find.text("NO"), findsOneWidget);

        await tester.tap(find.text("NO"));
        await tester.pumpAndSettle();
        expect(popResult, false);

        popResult = null;
        await tester.tap(find.text(data));
        await tester.pumpAndSettle();

        expect(popResult, null);
        await tester.tap(find.text("YES"));
        await tester.pumpAndSettle();
        expect(popResult, true);
      });
      testWidgets("custom", (tester) async {
        bool popResult;
        await tester.pumpWidget(createApp(
          Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                child: Text(data),
                onPressed: () async {
                  popResult = await showBinaryDialog(
                      context, Text(data * 2), Text(data * 3),
                      positiveText: data * 4, negativeText: data * 5);
                },
              ),
            ),
          ),
        ));

        await tester.tap(find.text(data));
        await tester.pumpAndSettle();

        expect(popResult, null);
        expect(find.text(data * 2), findsOneWidget);
        expect(find.text(data * 3), findsOneWidget);
        expect(find.text(data * 4), findsOneWidget);
        expect(find.text(data * 5), findsOneWidget);

        await tester.tap(find.text(data * 5));
        await tester.pumpAndSettle();
        expect(popResult, false);

        popResult = null;
        await tester.tap(find.text(data));
        await tester.pumpAndSettle();

        expect(popResult, null);
        await tester.tap(find.text(data * 4));
        await tester.pumpAndSettle();
        expect(popResult, true);
      });
    });
  }
}

class AsapCase implements TestCase {
  @override
  void run() {
    test("asap", () {
      expect(asap(() => print("ok")).then((_) => true).catchError((_) => false),
          completion(isTrue));
    });
  }
}
