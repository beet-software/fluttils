import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttils/fluttils.dart';

import 'utils.dart';

@visibleForTesting
abstract class Case {
  void run();
}

@visibleForTesting
class WidgetCase<T extends Widget, W extends T> implements Case {
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

@visibleForTesting
class SimpleBuildersCase implements Case {
  @override
  void run() {
    group("Simple*Builder", () {
      testWidgets("SimpleFutureBuilder", (tester) async {
        final Completer<int> completer = Completer();
        await tester.pumpWidget(createApp(SimpleFutureBuilder<int>(
          completer.future,
          builder: (_, data) => Text("$data"),
        )));

        expect(
          find.byWidgetPredicate((widget) {
            return widget is Center &&
                widget.child is CircularProgressIndicator;
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
            return widget is Center &&
                widget.child is CircularProgressIndicator;
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
    });
  }
}

@visibleForTesting
class ListViewCase implements Case {
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

@visibleForTesting
class TapOutsideCase implements Case {
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
