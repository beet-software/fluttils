import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttils/fluttils.dart';

/// A [Text] that creates its [TextStyle] from a list of attributes.
///
/// The available attributes are color, fontWeight, fontSize, fontStyle,
/// locale and decoration.
///
/// The following usages are equivalent:
///
/// ```dart
/// StyledText("weight", [FontWeight.bold]);
/// Text("weight", style: TextStyle(fontWeight: FontWeight.bold));
///
/// StyledText("color and size", [Colors.red, 24]);
/// Text("color and size", style: TextStyle(color: Colors.red, fontSize: 24));
///
/// StyledText("duplicated style", [FontStyle.italic, FontStyle.normal]);
/// Text("duplicated style", style: TextStyle(fontStyle: FontStyle.normal));
/// ```
class StyledText extends Text {
  static TextStyle _styleFrom(List<Object> attributes) {
    final List<Object> args = List.generate(6, (_) => null);
    for (Object attribute in attributes) {
      int i;
      if (attribute is FontWeight)
        i = 0;
      else if (attribute is Color)
        i = 1;
      else if (attribute is num)
        i = 2;
      else if (attribute is TextDecoration)
        i = 3;
      else if (attribute is Locale)
        i = 4;
      else if (attribute is FontStyle)
        i = 5;
      else
        continue;

      args[i] = attribute;
    }

    return TextStyle(
      fontWeight: args[0] as FontWeight,
      color: args[1] as Color,
      fontSize: (args[2] as num)?.toDouble(),
      decoration: args[3] as TextDecoration,
      locale: args[4] as Locale,
      fontStyle: args[5] as FontStyle,
    );
  }

  /// Creates a [StyledText].
  ///
  /// If there are duplicated types in [attributes], the last one will be used.
  /// If there are unsupported types in [attributes] (such as boolean), they
  /// will be ignored.
  StyledText(String text, List<Object> attributes, {TextAlign align})
      : super(text, style: _styleFrom(attributes), textAlign: align);
}

/// A [FutureBuilder] that displays a progress indicator while its connection
/// state is not done.
///
/// The widget provided by [builder] will only be displayed when the connection
/// state is equal to [ConnectionState.done].
///
/// The progress indicator can be changed using the [indicator] parameter
/// (defaults to a centered [CircularProgressIndicator]).
///
/// The following usage
///
/// ```dart
/// SimpleFutureBuilder<int>(
///   someFuture,
///   builder: (_, data) => Text("value: $data"),
/// );
/// ```
///
/// is equivalent to
///
/// ```dart
/// FutureBuilder<int>(
///   future: someFuture,
///   builder: (_, snapshot) {
///     if (snapshot.connectionState != ConnectionState.done)
///       return Center(child: CircularProgressIndicator());
///     final int data = snapshot.data;
///     return Text("value: $data");
///   },
/// );
/// ```
class SimpleFutureBuilder<T> extends StatelessWidget {
  /// The future this builder will listen to.
  final Future<T> future;

  /// The data that will be used to create the initial snapshot.
  final T initialData;

  /// The build strategy currently used by this builder.
  ///
  /// The widget returned by this builder will be displayed when the connection
  /// state is [ConnectionState.done]. Its parameter receives the value
  /// generated by [future].
  final Widget Function(BuildContext, T) builder;

  /// The widget to be displayed while the connection state is not
  /// [ConnectionState.done].
  final Widget indicator;

  const SimpleFutureBuilder(this.future,
      {Key key,
      @required this.builder,
      this.indicator = const Center(child: CircularProgressIndicator()),
      this.initialData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      initialData: initialData,
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return indicator;
        final T data = snapshot.data;
        return builder(context, data);
      },
    );
  }
}

/// A [StreamBuilder] that displays a progress indicator while its connection
/// state is waiting.
///
/// The widget provided by [builder] will only be displayed when the connection
/// state is equal to [ConnectionState.done], [ConnectionState.active] or
/// [ConnectionState.none].
///
/// The progress indicator can be changed using the [indicator] parameter
/// (defaults to a centered [CircularProgressIndicator]).
///
/// The following usage
///
/// ```dart
/// SimpleStreamBuilder<int>(
///   someStream,
///   builder: (_, data) => Text("value: $data"),
/// );
/// ```
///
/// is equivalent to
///
/// ```dart
/// StreamBuilder<int>(
///   stream: someStream,
///   builder: (_, snapshot) {
///     if (snapshot.connectionState == ConnectionState.waiting)
///       return Center(child: CircularProgressIndicator());
///     final int data = snapshot.data;
///     return Text("value: $data");
///   },
/// );
/// ```
class SimpleStreamBuilder<T> extends StatelessWidget {
  /// The stream this builder will listen to.
  final Stream<T> stream;

  /// The data that will be used to create the initial snapshot.
  final T initialData;

  /// The build strategy currently used by this builder.
  ///
  /// The widget returned by this builder will be displayed when the connection
  /// state is no longer [ConnectionState.waiting]. Its parameter receives the
  /// value generated by [stream].
  final Widget Function(BuildContext, T) builder;

  /// The widget to be displayed while the connection state is
  /// [ConnectionState.waiting].
  final Widget indicator;

  const SimpleStreamBuilder(this.stream,
      {Key key,
      @required this.builder,
      this.initialData,
      this.indicator = const Center(child: CircularProgressIndicator())})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initialData,
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.data == ConnectionState.waiting) return indicator;
        final T data = snapshot.data;
        return builder(context, data);
      },
    );
  }
}

/// A [Padding] that combines [EdgeInsets.only], [EdgeInsets.symmetric] and
/// [EdgeInsets.all] as values.
///
/// The following usages are equivalent:
///
/// ```dart
/// SimplePadding(all: 5);
/// Padding(padding: EdgeInsets.all(5));
///
/// SimplePadding(width: 2, height: 3);
/// Padding(padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3));
///
/// SimplePadding(left: 1, top: 4);
/// Padding(padding: EdgeInsets.only(left: 1, top: 4));
///
/// SimplePadding(all: 5, right: 3);
/// Padding(padding: EdgeInsets.only(left: 5, right: 3, top: 5, bottom: 5));
///
/// SimplePadding(all: 10, width: 20, top: 5);
/// Padding(padding: EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 10));
/// ```
class SimplePadding extends Padding {
  static EdgeInsetsGeometry _calculatePadding(List<double> heap) {
    assert(heap.length == 7);
    final List<double> values = [];
    for (int i = heap.length - 4; i < heap.length; i++) {
      int vi = i;
      while (vi >= 0 && heap[vi] == null) {
        if (vi == 0) {
          vi = null;
          break;
        }
        vi = (vi - 1) ~/ 2;
      }

      values.add(vi == null ? 0 : heap[vi]);
    }

    return EdgeInsets.only(
      left: values[0],
      right: values[1],
      top: values[2],
      bottom: values[3],
    );
  }

  /// Creates a [SimplePadding].
  ///
  /// Parameters work as a tree-like structure, where [all] is the root node,
  /// [width] and [height] are children of [all], [left] and [right] are children
  /// of [width] and [top] and [bottom] are children of [height].
  ///
  /// To get the padding of a parameter, its value will be checked. If it's not
  /// null, its value is returned, otherwise the padding of its parent will be
  /// returned. If this parameter has no parent, its padding will be zero.
  /// Using [left] as example:
  ///
  /// ```dart
  /// double padding;
  /// if (left == null) {
  ///   // width is left's parent
  ///   if (width == null) {
  ///     // all is width's parent
  ///     padding = all ?? 0;
  ///   } else {
  ///     padding = width;
  ///   }
  /// } else {
  ///   padding = left;
  /// }
  /// left = padding;
  /// ```
  SimplePadding(
      {@required Widget child,
      double all,
      double width,
      double height,
      double left,
      double right,
      double top,
      double bottom})
      : super(
            child: child,
            padding: _calculatePadding(
                [all, width, height, left, right, top, bottom]));
}

/// A widget that hides or show a [child] widget.
///
/// If [isVisible] is false, the size, state and animation of the widget will be
/// maintained.
///
/// The following usage
///
/// ```dart
/// SimpleVisibility(child: Text("hidden"), isVisible: false);
/// ```
///
/// is equivalent to
///
/// ```dart
/// Visibility(
///    child: Text("hidden"),
///    visible: false,
///    maintainSize: true,
///    maintainState: true,
///    maintainAnimation: true,
///  );
/// ```
class SimpleVisibility extends Visibility {
  const SimpleVisibility({bool isVisible = true, @required Widget child})
      : super(
            child: child,
            visible: isVisible,
            maintainSize: true,
            maintainState: true,
            maintainAnimation: true);
}

/// A [Stack] that can be created using a [Map].
///
/// The following usage
///
/// ```dart
/// SimpleStack({
///   Alignment.bottomRight: FloatingActionButton(),
///   Alignment.topCenter: Text("Title"),
///   Alignment.topLeft: IconButton(icon: Icon(Icons.arrow_back)),
/// });
/// ```
///
/// is equivalent to
///
/// ```dart
/// Stack(
///   children: [
///     Align(
///       alignment: Alignment.bottomRight,
///       child: FloatingActionButton(),
///     ),
///     Align(
///       alignment: Alignment.topCenter,
///       child: Text("Title"),
///     ),
///     Align(
///       alignment: Alignment.topLeft,
///       child: IconButton(icon: Icon(Icons.arrow_back)),
///     ),
///   ]
/// );
/// ```
class SimpleStack extends Stack {
  /// Creates a [SimpleStack].
  ///
  /// Each key of the map will be the alignment of its respective widget in the
  /// stack.
  SimpleStack(Map<Alignment, Widget> alignments)
      : super(
            children: alignments.entries
                .map((entry) => Align(alignment: entry.key, child: entry.value))
                .toList());
}

/// A splash screen used for loading purposes.
///
/// If [init] ends first than [duration], then the duration of the splash will
/// be [duration], otherwise it will be the execution time of [init].
///
/// To just show some content, use [SimpleSplashScreen].
class SplashScreen extends FutureBuilder<void> {
  /// Creates a [SplashScreen].
  ///
  /// The minimum [duration] of this splash defaults to the recommended three
  /// seconds.
  SplashScreen(
      {Duration duration = const Duration(seconds: 3),
      Widget content,
      WidgetBuilder builder,
      Future<void> init})
      : super(
            future: Future.wait([Future.delayed(duration), init]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                asap(() => Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: builder)));

              return content;
            });
}

/// A simple splash screen that shows some content.
///
/// To use a splash screen for loading purposes, use [SplashScreen].
class SimpleSplashScreen extends SplashScreen {
  /// Creates a [SimpleSplashScreen].
  SimpleSplashScreen(
      {Duration duration = const Duration(seconds: 3),
      @required Widget content,
      WidgetBuilder builder})
      : super(
            duration: duration,
            content: content,
            builder: builder,
            init: Future.delayed(Duration.zero));
}

/// A widget that hides the soft keyboard by clicking outside of a [TextField]
/// or anywhere on the screen.
///
/// The following usage
///
/// ```dart
/// TapOutsideToUnfocus(child: TextFormField());
/// ```
///
/// is equivalent to
///
/// ```dart
/// GestureDetector(
///   onTap: () => FocusScope.of(context).unfocus(),
///   child: TextFormField(),
/// );
/// ```
class TapOutsideToUnfocus extends StatelessWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// Creates a [TapOutsideToUnfocus].
  const TapOutsideToUnfocus({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: child,
    );
  }
}

/// A [ListView] that creates its children on demand.
///
/// It's equivalent to [ListView.builder].
class OnDemandListView<T> extends ListView {
  /// Creates a on-demand [ListView] from a list of widgets.
  static OnDemandListView<Widget> from(List<Widget> widgets,
          {bool shrinkWrap = false, ScrollPhysics physics}) =>
      OnDemandListView.mapped(widgets, (_, widget) => widget,
          shrinkWrap: shrinkWrap, physics: physics);

  /// Creates a on-demand [ListView] using each index and value from [values].
  ///
  /// [onBuild] is the transform to be applied to each value in [values],
  /// where its arguments are the context, the index and the value,
  /// respectively.
  OnDemandListView.indexed(List<T> values,
      {Key key,
      Widget Function(BuildContext, int, T) onBuild,
      bool shrinkWrap = false,
      ScrollPhysics physics})
      : super.builder(
            shrinkWrap: shrinkWrap,
            physics: physics,
            itemCount: values.length,
            itemBuilder: (context, i) => onBuild(context, i, values[i]));

  /// Creates a on-demand [ListView] using each value from [values].
  ///
  /// [onBuild] is the transform to be applied to each value in [values],
  /// where its arguments are the context and the value, respectively.
  OnDemandListView.mapped(
      List<T> values, Widget Function(BuildContext, T) onBuild,
      {bool shrinkWrap = false, ScrollPhysics physics})
      : this.indexed(values,
            onBuild: (context, _, value) => onBuild(context, value),
            shrinkWrap: shrinkWrap,
            physics: physics);
}

/// A [Scaffold] wrapped in a [SafeArea].
///
/// Useful when using [Scaffold] as root widget.
class SafeScaffold extends SafeArea {
  /// Creates a [SafeScaffold] with some commonly used [Scaffold] parameters.
  SafeScaffold(
      {PreferredSizeWidget appBar,
      Color backgroundColor,
      Widget body,
      FloatingActionButton floatingActionButton,
      Widget bottomNavigationBar})
      : super(
            child: Scaffold(
                appBar: appBar,
                backgroundColor: backgroundColor,
                body: body,
                floatingActionButton: floatingActionButton,
                bottomNavigationBar: bottomNavigationBar));
}

/// A [SizedBox] with only the height value set.
class Height extends SizedBox {
  /// Creates a [Height] with size [value].
  const Height([double value]) : super(height: value);
}

/// A [SizedBox] with only the width value set.
class Width extends SizedBox {
  /// Creates a [Width] with size [value].
  const Width([double value]) : super(width: value);
}
