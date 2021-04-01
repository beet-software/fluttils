import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttils/fluttils.dart';

class _Pair<F, S> {
  final F first;
  final S second;

  const _Pair(this.first, this.second);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Pair &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;
}

class _Case<T extends Widget, W extends T> {
  final Map<String, _Comparison<T>> comparisons;
  final void Function(T, T) compare;

  const _Case(this.comparisons, {this.compare});

  void run() {
    group(W.toString(), () {
      comparisons.forEach((description, comparison) {
        testWidgets(description, (tester) async {
          await tester.pumpWidget(
            MaterialApp(home: Scaffold(body: comparison.actual)),
          );

          final Iterable<Element> elements =
              find.byWidgetPredicate((widget) => widget is W).evaluate();

          final T widget = elements.single.widget as T;
          compare(widget, comparison.expected);
        });
      });
    });
  }
}

class _Comparison<T> {
  final T actual;
  final T expected;

  const _Comparison(this.actual, this.expected);
}

const String _data = "a";

Widget get _dummy => SizedBox.shrink();

Set<_Pair<Alignment, String>> _decodeStack(Stack stack) {
  return stack.children
      .whereType<Align>()
      .map((align) {
        return _Pair(align.alignment as Alignment, (align.child as Text).data);
      })
      .toSet();
}

String _decodeSafeScaffold(SafeArea area) {
  final Scaffold child = area.child as Scaffold;
  final Text grandchild = child.body as Text;
  return grandchild?.data;
}

void main() {
  final List<_Case<Widget, Widget>> cases = [
    _Case<Text, StyledText>({
      "empty": _Comparison(StyledText(_data, []), Text(_data, style: TextStyle())),
      "color": _Comparison(StyledText(_data, [Colors.red]), Text(_data, style: TextStyle(color: Colors.red))),
      "fontWeight": _Comparison(StyledText(_data, [FontWeight.bold]), Text(_data, style: TextStyle(fontWeight: FontWeight.bold))),
      "fontSize (double)": _Comparison(StyledText(_data, [34.0]), Text(_data, style: TextStyle(fontSize: 34))),
      "fontSize (int)": _Comparison(StyledText(_data, [34]), Text(_data, style: TextStyle(fontSize: 34))),
      "fontStyle": _Comparison(StyledText(_data, [FontStyle.italic]), Text(_data, style: TextStyle(fontStyle: FontStyle.italic))),
      "locale": _Comparison(StyledText(_data, [Locale("en")]), Text(_data, style: TextStyle(locale: Locale("en")))),
      "decoration": _Comparison(StyledText(_data, [TextDecoration.lineThrough]), Text(_data, style: TextStyle(decoration: TextDecoration.lineThrough))),
      "color, fontWeight": _Comparison(StyledText(_data, [Colors.blue, FontWeight.w100]), Text(_data, style: TextStyle(fontWeight: FontWeight.w100, color: Colors.blue))),
      "fontStyle, fontStyle": _Comparison(StyledText(_data, [FontStyle.italic, FontStyle.normal]), Text(_data, style: TextStyle(fontStyle: FontStyle.normal))),
      "color, fontStyle, fontWeight, color, fontWeight": _Comparison(StyledText(_data, [Colors.red, FontStyle.italic, FontWeight.w100, Colors.redAccent, FontWeight.bold]), Text(_data,style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
    }, compare: (actual, expected) {
      expect(actual.data, expected.data);
      expect(actual.style, expected.style);
      expect(actual.textAlign, expected.textAlign);
    }),
    _Case<Padding, SimplePadding>({
      "all": _Comparison(SimplePadding(all: 5, child: _dummy), Padding(padding: EdgeInsets.all(5), child: _dummy)),
      "symmetric": _Comparison(SimplePadding(width: 2, height: 3, child: _dummy), Padding(padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3), child: _dummy)),
      "only": _Comparison(SimplePadding(left: 1, top: 4, child: _dummy), Padding(padding: EdgeInsets.only(left: 1, top: 4))),
      "all, symmetric": _Comparison(SimplePadding(all: 5, right: 3, child: _dummy), Padding(padding: EdgeInsets.only(left: 5, right: 3, top: 5, bottom: 5))),
      "all, only": _Comparison(SimplePadding(all: 1, top: 2, child: _dummy), Padding(padding: EdgeInsets.only(left: 1, right: 1, top: 2, bottom: 1))),
      "symmetric, only": _Comparison(SimplePadding(width: 10, top: 5, child: _dummy), Padding(padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 0))),
      "symmetric, symmetric, only": _Comparison(SimplePadding(width: 1, height: 15, top: 5, child: _dummy), Padding(padding: EdgeInsets.only(left: 1, right: 1, top: 5, bottom: 15))),
      "all, symmetric, only": _Comparison(SimplePadding(all: 10, width: 20, top: 5, child: _dummy), Padding(padding: EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 10))),
    }, compare: (actual, expected) {
      expect(actual.padding, expected.padding);
    }),
    _Case<SizedBox, Width>({
      "null": _Comparison(Width(), SizedBox()),
      "value": _Comparison(Width(10), SizedBox(width: 10)),
    }, compare: (actual, expected) {
      expect(actual.width, expected.width);
      expect(actual.height, expected.height);
    }),
    _Case<SizedBox, Height>({
      "null": _Comparison(Height(), SizedBox()),
      "value": _Comparison(Height(10), SizedBox(height: 10)),
    }, compare: (actual, expected) {
      expect(actual.width, expected.width);
      expect(actual.height, expected.height);
    }),
    _Case<Stack, SimpleStack>({
      "empty": _Comparison(SimpleStack({}), Stack()),
      "center": _Comparison(SimpleStack({Alignment.center: Text(_data)}), Stack(children: [Align(alignment: Alignment.center, child: Text(_data))])),
      "multiple": _Comparison(SimpleStack({Alignment.topLeft: Text(_data), Alignment.bottomRight: Text(_data + _data)}), Stack(children: [Align(alignment: Alignment.topLeft, child: Text(_data)), Align(alignment: Alignment.bottomRight, child: Text(_data + _data))])),
    }, compare: (actual, expected) {
      expect(_decodeStack(actual), _decodeStack(expected));
    }),
    _Case<SafeArea, SafeScaffold>({
      "empty": _Comparison(SafeScaffold(), SafeArea(child: Scaffold())),
      "with body": _Comparison(SafeScaffold(body: Text(_data)), SafeArea(child: Scaffold(body: Text(_data)))),
    }, compare: (actual, expected) {
      expect(_decodeSafeScaffold(actual), _decodeSafeScaffold(expected));
    }),
    _Case<Visibility, SimpleVisibility>({
      "visible": _Comparison(SimpleVisibility(child: _dummy, isVisible: true), Visibility(child: _dummy, maintainState: true, maintainSize: true, maintainAnimation: true)),
      "invisible": _Comparison(SimpleVisibility(child: _dummy, isVisible: false), Visibility(child: _dummy, visible: false, maintainState: true, maintainSize: true, maintainAnimation: true)),
    }, compare: (actual, expected) {
      expect(actual.visible, expected.visible);
      expect(actual.maintainState, expected.maintainState);
      expect(actual.maintainSize, expected.maintainSize);
      expect(actual.maintainAnimation, expected.maintainAnimation);
    }),
  ];

  cases.forEach((c) => c.run());
}
