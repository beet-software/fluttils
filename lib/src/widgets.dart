import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A text that provides a [TextStyle] from a list of attributes.
///
/// The available attributes are color, fontWeight, fontSize, fontStyle,
/// locale and decoration.
///
/// The following usages are equivalent:
///
/// ```
/// Text text;
///
/// text = Text("weight", style: TextStyle(fontWeight: FontWeight.bold));
/// text = StyledText("weight", [FontWeight.bold]);
///
/// text = Text("color and size", style: TextStyle(color: Colors.red, fontSize: 24));
/// text = StyledText("color and size", [Colors.red, 24]);
/// ```
class StyledText extends Text {
  static TextStyle _styleFrom(List<Object> attributes) {
    final List<Object> args = List.generate(5, (_) => null);
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
      else
        continue;

      args[i] = attribute;
    }

    return TextStyle(
      fontWeight: args[0] as FontWeight,
      color: args[1] as Color,
      fontSize: args[2] as num,
      decoration: args[3] as TextDecoration,
      locale: args[4] as Locale,
    );
  }

  /// Creates a [StyledText].
  ///
  /// If there are duplicated types in [attributes], the last one will be used.
  /// If there are unsupported types in [attributes] (such as boolean), they
  /// will be ignored.
  StyledText(String text, List<Object> attributes)
      : super(text, style: _styleFrom(attributes));
}

/// A [FutureBuilder] that displays a progress indicator while its connection
/// state is not done.
///
/// The widget provided by [builder] will only be displayed when the connection
/// state is equal to [ConnectionState.done].
///
/// The progress indicator can be changed using the [indicator] parameter
/// (defaults to [CircularProgressIndicator]).
class SimpleFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final T initialData;
  final Widget Function(T) builder;
  final Widget indicator;

  const SimpleFutureBuilder(
      {Key key,
      @required this.future,
      @required this.builder,
      this.indicator = const CircularProgressIndicator(),
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
        return builder(data);
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
/// (defaults to [CircularProgressIndicator]).
class SimpleStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final T initialData;
  final Widget Function(T) builder;
  final Widget indicator;

  const SimpleStreamBuilder(
      {Key key,
      @required this.stream,
      @required this.builder,
      this.initialData,
      this.indicator = const CircularProgressIndicator()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initialData,
      builder: (context, snapshot) {
        if (snapshot.data == ConnectionState.waiting) return indicator;
        final T data = snapshot.data;
        return builder(data);
      },
    );
  }
}

/// A widget that hides or show a [child] widget.
///
/// If [isVisible] is false, the size, state and animation of the widget will be
/// maintained.
class SimpleVisibility extends StatelessWidget {
  final Widget child;
  final bool isVisible;

  SimpleVisibility({Key key, this.isVisible = true, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isVisible) return child;
    return Visibility(
      child: child,
      visible: false,
      maintainSize: true,
      maintainState: true,
      maintainAnimation: true,
    );
  }
}

/// A widget that hides the soft keyboard by clicking outside of a [TextField]
/// or anywhere on the screen.
class TapOutsideToUnfocus extends StatelessWidget {
  final Widget child;

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
/// A simple [ListView.builder].
class OnDemandListView<T> extends StatelessWidget {
  /// The original values to be transformed into children of this list.
  final List<T> values;

  /// The transform to be applied to each value in the [values], where
  /// its arguments are the context, the index and the value.
  final Widget Function(BuildContext, int, T) onBuild;

  /// See `shrinkWrap` parameter of [ListView.builder].
  final bool shrinkWrap;

  /// Creates a on-demand [ListView] from a list of widgets.
  static OnDemandListView<Widget> from(List<Widget> widgets,
          {bool shrinkWrap = false}) =>
      OnDemandListView._(widgets,
          onBuild: (_, __, widget) => widget, shrinkWrap: shrinkWrap);

  /// Creates a on-demand [ListView] using each index and value from [values].
  const OnDemandListView._(this.values,
      {Key key, this.onBuild, this.shrinkWrap = false})
      : super(key: key);

  /// Creates a on-demand [ListView] using each index and value from [values].
  const OnDemandListView.indexed(List<T> values,
      Widget Function(BuildContext, int, T) onBuild, {bool shrinkWrap = false})
      : this._(values, onBuild: onBuild, shrinkWrap: shrinkWrap);

  /// Creates a on-demand [ListView] using each value from [values].
  OnDemandListView.mapped(List<T> values,
      Widget Function(BuildContext, T) onBuild, {bool shrinkWrap = false})
      : this._(values,
            onBuild: (context, _, value) => onBuild(context, value),
            shrinkWrap: shrinkWrap);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      itemCount: values.length,
      itemBuilder: (context, i) => onBuild(context, i, values[i]),
    );
  }
}
