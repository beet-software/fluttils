import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttils/fluttils.dart';

import 'utils.dart';

class Comparator<T> extends TypeComparison<T> {
  const Comparator(T actual, T expected) : super(actual, expected);

  void compareBy<R>(R Function(T) compare) =>
      expect(compare(actual), compare(expected));
}

abstract class RunnableTest {
  void run();
}

class UnitTest implements RunnableTest {
  final String name;
  final void Function() body;

  const UnitTest(this.name, this.body);

  @override
  void run() => test(name, body);
}

class SimpleTestCase implements RunnableTest {
  final Map<String, Future<void> Function(WidgetTester)> tests;

  const SimpleTestCase(this.tests);

  @override
  void run() {
    for (var entry in tests.entries) testWidgets(entry.key, entry.value);
  }
}

class TestCaseGroup extends SimpleTestCase {
  final String name;

  const TestCaseGroup(
      this.name, Map<String, Future<void> Function(WidgetTester p1)> tests)
      : super(tests);

  @override
  void run() => group(name, super.run);
}

abstract class TestCase<T> implements RunnableTest {
  static const bool _sanityCheck = false;

  final String name;
  final Map<String, T> cases;

  const TestCase(this.name, this.cases);

  @override
  void run() {
    group(name, () {
      cases.forEach((description, element) {
        testWidgets(description, (tester) async {
          if (_sanityCheck) expect(true, false);
          await onEntry(tester, element);
        });
      });
    });
  }

  Future<void> onEntry(WidgetTester tester, T element);
}

class TypeTest<F, U extends F> extends TestCase<TypeComparison<F>> {
  final void Function(F, F) compare;

  TypeTest(Map<String, TypeComparison<F>> cases, {required this.compare})
      : super("$U", cases);

  @override
  Future<void> onEntry(
      WidgetTester tester, TypeComparison<F> comparison) async {
    compare(comparison.actual, comparison.expected);
  }
}

class WidgetTypeTest<F extends Widget, U extends F> extends TypeTest<F, U> {
  WidgetTypeTest(Map<String, TypeComparison<F>> cases,
      {required void Function(F, F) compare})
      : super(cases, compare: compare);

  @override
  Future<void> onEntry(
      WidgetTester tester, TypeComparison<F> comparison) async {
    await tester.pumpWidget(createApp(comparison.actual));
    final Iterable<Element> elements =
        find.byWidgetPredicate((widget) => widget is U).evaluate();
    final F widget = elements.single.widget as F;
    compare(widget, comparison.expected);
  }
}

class WidgetValueTest<F extends Widget, U extends Widget>
    extends TestCase<ValueComparison<U, F>> {
  final void Function(F, F) compare;

  WidgetValueTest(Map<String, ValueComparison<U, F>> cases,
      {required this.compare})
      : super("$U:$F", cases);

  @override
  Future<void> onEntry(
      WidgetTester tester, ValueComparison<U, F> comparison) async {
    await tester.pumpWidget(createApp(comparison.actual));
    final Iterable<Element> elements =
        find.byWidgetPredicate((widget) => widget is F).evaluate();
    final F widget = elements.single.widget as F;
    compare(widget, comparison.expected);
  }
}

class OnDemandListViewSetup {
  final Widget Function(List<int>) builder;
  final String Function(int) onText;

  OnDemandListViewSetup(this.builder, {String Function(int)? onText})
      : onText = onText ?? ((v) => "$v");
}

class OnDemandListViewTest extends TestCase<OnDemandListViewSetup> {
  static final Random _random = Random();

  const OnDemandListViewTest(Map<String, OnDemandListViewSetup> cases)
      : super("OnDemandListView", cases);

  @override
  Future<void> onEntry(WidgetTester tester, OnDemandListViewSetup setup) async {
    final List<int> values =
        List.generate(10, (i) => 10 * i + _random.nextInt(10), growable: false);

    await tester.pumpWidget(createApp(setup.builder(values)));
    for (int value in values)
      expect(find.text(setup.onText(value)), findsOneWidget);
  }
}

class TapOutsideCaseSetup {
  final Widget Function(Widget) builder;
  final bool focusOnEnd;

  const TapOutsideCaseSetup(this.builder, {required this.focusOnEnd});
}

class TapOutsideToUnfocusTest extends TestCase<TapOutsideCaseSetup> {
  const TapOutsideToUnfocusTest(Map<String, TapOutsideCaseSetup> cases)
      : super("TapOutsideToUnfocus", cases);

  @override
  Future<void> onEntry(WidgetTester tester, TapOutsideCaseSetup setup) async {
    bool isFocused = false;

    final FocusNode node = FocusNode();
    node.addListener(() => isFocused = node.hasFocus);

    final Text text = Text(data);
    final TextFormField field = TextFormField(focusNode: node);
    await tester.pumpWidget(createApp(setup.builder(
      Column(mainAxisSize: MainAxisSize.min, children: [text, field]),
    )));

    await tester.tap(find.byWidget(field));
    await tester.pumpAndSettle();
    expect(isFocused, true);

    await tester.tap(find.byWidget(text));
    await tester.pump();
    expect(isFocused, setup.focusOnEnd);
  }
}

class SplashCaseSetup {
  static const int _defaultSplash = 3;

  final int init;
  final int? _splash;

  const SplashCaseSetup({required this.init, int? splash}) : _splash = splash;

  bool get isDefaultSplash => _splash == null;

  int get splash => _splash ?? _defaultSplash;

  Duration get initValue => Duration(seconds: init);

  Duration get splashValue => Duration(seconds: splash);
}

class SplashScreenTest extends TestCase<SplashCaseSetup> {
  const SplashScreenTest(Map<String, SplashCaseSetup> cases)
      : super("SplashScreen", cases);

  @override
  Future<void> onEntry(WidgetTester tester, SplashCaseSetup setup) async {
    final int df = min(setup.init, setup.splash);
    final int dl = max(setup.init, setup.splash);
    final int dr = dl - df;

    final Future<void> init = Future.delayed(setup.initValue);

    // @formatter:off
    final Widget first = Scaffold(body: Text(data + data));
    final Widget splash = setup.isDefaultSplash
        ? SplashScreen(content: Text(data), builder: (_) => first, init: init)
        : SplashScreen(
            duration: setup.splashValue,
            content: Text(data),
            builder: (_) => first,
            init: init);
    // @formatter:on

    await tester.pumpWidget(createApp(splash));

    await tester.pump(Duration(seconds: df));
    expect(find.text(data), findsOneWidget);
    expect(find.text(data + data), findsNothing);

    await tester.pump(Duration(seconds: dr));
    expect(find.text(data), findsOneWidget);
    expect(find.text(data + data), findsNothing);

    await tester.pumpAndSettle();
    expect(find.text(data), findsNothing);
    expect(find.text(data + data), findsOneWidget);
  }
}

class SimpleSplashScreenTest extends TestCase<int?> {
  const SimpleSplashScreenTest(Map<String, int?> cases)
      : super("SimpleSplashScreen", cases);

  @override
  Future<void> onEntry(WidgetTester tester, int? value) async {
    final Duration? duration = value == null ? null : Duration(seconds: value);
    final Widget first = Scaffold(body: Text(data + data));

    // @formatter:off
    final Widget splash = duration == null
        ? SimpleSplashScreen(content: Text(data), builder: (_) => first)
        : SimpleSplashScreen(
            duration: duration, content: Text(data), builder: (_) => first);
    // @formatter:on

    await tester.pumpWidget(createApp(splash));

    await tester.pump(duration ?? Duration(seconds: 3));
    expect(find.text(data), findsOneWidget);
    expect(find.text(data + data), findsNothing);

    await tester.pumpAndSettle();
    expect(find.text(data), findsNothing);
    expect(find.text(data + data), findsOneWidget);
  }
}

class SimpleDialogTest extends TestCase<String?> {
  const SimpleDialogTest(Map<String, String?> cases)
      : super("showSimpleDialog", cases);

  @override
  Future<void> onEntry(WidgetTester tester, String? positiveText) async {
    // @formatter:off
    await tester.pumpWidget(createApp(
      Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            child: Text(data),
            onPressed: () async {
              if (positiveText == null)
                await showSimpleDialog(context, Text(data * 2), Text(data * 3));
              else
                await showSimpleDialog(context, Text(data * 2), Text(data * 3),
                    positiveText: positiveText);
            },
          ),
        ),
      ),
    ));
    // @formatter:on

    positiveText ??= "OK";

    await tester.tap(find.text(data));
    await tester.pumpAndSettle();

    expect(find.text(data * 2), findsOneWidget);
    expect(find.text(data * 3), findsOneWidget);
    expect(find.text(positiveText), findsOneWidget);

    await tester.tap(find.text(positiveText));
    await tester.pumpAndSettle();
  }
}

class BinaryDialogCaseSetup {
  final String? positiveText;
  final String? negativeText;

  const BinaryDialogCaseSetup({this.positiveText, this.negativeText});
}

class BinaryDialogTest extends TestCase<BinaryDialogCaseSetup> {
  const BinaryDialogTest(Map<String, BinaryDialogCaseSetup> cases)
      : super("showBinaryDialog", cases);

  @override
  Future<void> onEntry(WidgetTester tester, BinaryDialogCaseSetup setup) async {
    bool? popResult;

    // @formatter:off
    await tester.pumpWidget(createApp(
      Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            child: Text(data),
            onPressed: () async {
              final bool cp = setup.positiveText == null;
              final bool cn = setup.negativeText == null;
              if (cp && cn)
                popResult = await showBinaryDialog(
                    context, Text(data * 2), Text(data * 3));
              else if (cp)
                popResult = await showBinaryDialog(
                    context, Text(data * 2), Text(data * 3),
                    negativeText: setup.negativeText);
              else if (cn)
                popResult = await showBinaryDialog(
                    context, Text(data * 2), Text(data * 3),
                    positiveText: setup.positiveText);
              else
                popResult = await showBinaryDialog(
                    context, Text(data * 2), Text(data * 3),
                    positiveText: setup.positiveText,
                    negativeText: setup.negativeText);
            },
          ),
        ),
      ),
    ));
    // @formatter:on

    final String positiveText = setup.positiveText ?? "YES";
    final String negativeText = setup.negativeText ?? "NO";

    await tester.tap(find.text(data));
    await tester.pumpAndSettle();

    expect(popResult, null);
    expect(find.text(data * 2), findsOneWidget);
    expect(find.text(data * 3), findsOneWidget);
    expect(find.text(positiveText), findsOneWidget);
    expect(find.text(negativeText), findsOneWidget);

    await tester.tap(find.text(negativeText));
    await tester.pumpAndSettle();
    expect(popResult, false);

    popResult = null;
    await tester.tap(find.text(data));
    await tester.pumpAndSettle();

    expect(popResult, null);
    await tester.tap(find.text(positiveText));
    await tester.pumpAndSettle();
    expect(popResult, true);
  }
}
