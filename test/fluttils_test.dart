import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttils/fluttils.dart';

class _Comparison<T> {
  final String description;
  final T actual;
  final T expected;

  const _Comparison(this.description, this.actual, this.expected);
}

const String _data = "a";

Widget get _dummy => SizedBox.shrink();

void main() {
  group("StyledText", () {
    final List<_Comparison<Text>> comparisons = [
      _Comparison(
          "empty", StyledText(_data, []), Text(_data, style: TextStyle())),
      _Comparison("color", StyledText(_data, [Colors.red]),
          Text(_data, style: TextStyle(color: Colors.red))),
      _Comparison("fontWeight", StyledText(_data, [FontWeight.bold]),
          Text(_data, style: TextStyle(fontWeight: FontWeight.bold))),
      _Comparison("fontSize (double)", StyledText(_data, [34.0]),
          Text(_data, style: TextStyle(fontSize: 34))),
      _Comparison("fontSize (int)", StyledText(_data, [34]),
          Text(_data, style: TextStyle(fontSize: 34))),
      _Comparison("fontStyle", StyledText(_data, [FontStyle.italic]),
          Text(_data, style: TextStyle(fontStyle: FontStyle.italic))),
      _Comparison("locale", StyledText(_data, [Locale("en")]),
          Text(_data, style: TextStyle(locale: Locale("en")))),
      _Comparison(
          "decoration",
          StyledText(_data, [TextDecoration.lineThrough]),
          Text(_data,
              style: TextStyle(decoration: TextDecoration.lineThrough))),
      _Comparison(
          "color, fontWeight",
          StyledText(_data, [Colors.blue, FontWeight.w100]),
          Text(_data,
              style:
                  TextStyle(fontWeight: FontWeight.w100, color: Colors.blue))),
      _Comparison(
          "fontStyle, fontStyle",
          StyledText(_data, [FontStyle.italic, FontStyle.normal]),
          Text(_data, style: TextStyle(fontStyle: FontStyle.normal))),
      _Comparison(
        "color, fontStyle, fontWeight, color, fontWeight",
        StyledText(_data, [
          Colors.red,
          FontStyle.italic,
          FontWeight.w100,
          Colors.redAccent,
          FontWeight.bold
        ]),
        Text(_data,
            style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic)),
      ),
      _Comparison(
          "color, fontStyle, fontWeight, color, fontWeight, textAlign",
          StyledText(
            _data,
            [
              Colors.red,
              FontStyle.italic,
              FontWeight.w100,
              Colors.redAccent,
              FontWeight.bold
            ],
            align: TextAlign.center,
          ),
          Text(
            _data,
            style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          )),
    ];

    for (_Comparison<Text> comparison in comparisons) {
      testWidgets(
        comparison.description,
        (tester) async {
          await tester
              .pumpWidget(MaterialApp(home: Scaffold(body: comparison.actual)));
          expect(find.text(_data), findsOneWidget);

          final Text text = find
              .byWidgetPredicate((widget) => widget is Text)
              .evaluate()
              .single
              .widget as Text;

          expect(text.data, comparison.expected.data);
          expect(text.style, comparison.expected.style);
          expect(text.textAlign, comparison.expected.textAlign);
        },
      );
    }
  });

  group("SimplePadding", () {
    final List<_Comparison<Padding>> comparisons = [
      _Comparison("all", SimplePadding(all: 5, child: _dummy),
          Padding(padding: EdgeInsets.all(5), child: _dummy)),
      _Comparison(
          "symmetric",
          SimplePadding(width: 2, height: 3, child: _dummy),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3),
              child: _dummy)),
      _Comparison("only", SimplePadding(left: 1, top: 4, child: _dummy),
          Padding(padding: EdgeInsets.only(left: 1, top: 4))),
      _Comparison(
          "all, symmetric",
          SimplePadding(all: 5, right: 3, child: _dummy),
          Padding(
              padding: EdgeInsets.only(left: 5, right: 3, top: 5, bottom: 5))),
      _Comparison(
          "all, only",
          SimplePadding(all: 1, top: 2, child: _dummy),
          Padding(
              padding: EdgeInsets.only(left: 1, right: 1, top: 2, bottom: 1))),
      _Comparison(
          "symmetric, only",
          SimplePadding(width: 10, top: 5, child: _dummy),
          Padding(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 0))),
      _Comparison(
          "symmetric, symmetric, only",
          SimplePadding(width: 1, height: 15, top: 5, child: _dummy),
          Padding(
              padding: EdgeInsets.only(left: 1, right: 1, top: 5, bottom: 15))),
      _Comparison(
          "all, symmetric, only",
          SimplePadding(all: 10, width: 20, top: 5, child: _dummy),
          Padding(
              padding:
                  EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 10))),
    ];

    for (_Comparison<Padding> comparison in comparisons) {
      testWidgets(
        comparison.description,
        (tester) async {
          await tester
              .pumpWidget(MaterialApp(home: Scaffold(body: comparison.actual)));

          final Padding padding = find
              .byWidgetPredicate((widget) => widget is Padding)
              .evaluate()
              .single
              .widget as Padding;

          expect(padding.padding, comparison.expected.padding);
        },
      );
    }
  });

  group("Width, Height", () {
    final List<_Comparison<SizedBox>> comparisons = [
      _Comparison("width, null", Width(), SizedBox()),
      _Comparison("height, null", Height(), SizedBox()),
      _Comparison("width, value", Width(10), SizedBox(width: 10)),
      _Comparison("height, value", Height(20), SizedBox(height: 20)),
    ];

    for (_Comparison<SizedBox> comparison in comparisons) {
      testWidgets(
        comparison.description,
        (tester) async {
          await tester
              .pumpWidget(MaterialApp(home: Scaffold(body: comparison.actual)));

          final SizedBox box = find
              .byWidgetPredicate((widget) => widget is SizedBox)
              .evaluate()
              .single
              .widget as SizedBox;

          expect(box.width, comparison.expected.width);
          expect(box.height, comparison.expected.height);
        },
      );
    }
  });
}
