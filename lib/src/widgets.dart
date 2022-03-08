import 'dart:async';

import 'package:flutter/material.dart' as f;
import 'package:fluttils/src/models/async_result.dart';
import 'package:provider/provider.dart';

class _TextAttrs {
  final f.TextStyle? style;
  final f.TextAlign? textAlign;

  const _TextAttrs.empty() : this(style: null, textAlign: null);

  const _TextAttrs({required this.style, required this.textAlign});
}

/// A [f.Text] that populates its attributes from a list of attributes.
///
/// The available attributes are color, fontWeight, fontSize, fontStyle,
/// locale, decoration and textAlign.
///
/// The following usages are equivalent:
///
/// ```dart
/// < Text("only text")
/// > Text("only text")
///
/// < Text("weight", [FontWeight.bold]);
/// > Text("weight", style: TextStyle(fontWeight: FontWeight.bold));
///
/// < Text("color and size", [Colors.red, 24]);
/// > Text("color and size", style: TextStyle(color: Colors.red, fontSize: 24));
///
/// < Text("duplicated style", [FontStyle.italic, FontStyle.normal]);
/// > Text("duplicated style", style: TextStyle(fontStyle: FontStyle.normal));
/// ```
class Text extends f.StatelessWidget {
  final String data;
  final List<Object>? attributes;

  /// Creates a [Text].
  ///
  /// If there are duplicated types in [attributes], the last one will be used.
  /// If there are unsupported types in [attributes] (such as boolean), they
  /// will be ignored.
  const Text(this.data, [this.attributes]);

  @override
  f.Widget build(f.BuildContext context) {
    return Provider<_TextAttrs>(
      create: (_) {
        final List<Object>? attrs = attributes;
        final List<Object?> args = List.generate(7, (_) => null);
        if (attrs == null) return _TextAttrs.empty();
        if (attrs.isEmpty)
          return _TextAttrs(style: f.TextStyle(), textAlign: null);

        for (Object attribute in attrs) {
          final int? i = () {
            if (attribute is f.FontWeight) return 0;
            if (attribute is f.Color) return 1;
            if (attribute is num) return 2;
            if (attribute is f.TextDecoration) return 3;
            if (attribute is f.Locale) return 4;
            if (attribute is f.FontStyle) return 5;
            if (attribute is f.TextAlign) return 6;
          }();
          if (i == null) continue;
          args[i] = attribute;
        }
        final bool hasTextStyle = args.sublist(0, 6).any((v) => v != null);
        return _TextAttrs(
          style: !hasTextStyle
              ? null
              : f.TextStyle(
                  fontWeight: args[0] as f.FontWeight?,
                  color: args[1] as f.Color?,
                  fontSize: (args[2] as num?)?.toDouble(),
                  decoration: args[3] as f.TextDecoration?,
                  locale: args[4] as f.Locale?,
                  fontStyle: args[5] as f.FontStyle?,
                ),
          textAlign: args[6] as f.TextAlign?,
        );
      },
      child: Consumer<_TextAttrs>(
        builder: (context, attrs, _) {
          final f.TextStyle? style = attrs.style;
          final f.TextAlign? align = attrs.textAlign;
          if (style == null && align == null) return f.Text(data);
          if (style == null) return f.Text(data, textAlign: align);
          if (align == null) return f.Text(data, style: style);
          return f.Text(data, style: style, textAlign: align);
        },
      ),
    );
  }
}

/// A [f.FutureBuilder] that displays a progress indicator while its connection
/// state is not done.
///
/// The widget provided by [onDone] will only be displayed when the connection
/// state is not [ConnectionState.waiting].
///
/// The progress indicator can be changed using the [indicator] parameter
/// (defaults to a centered [CircularProgressIndicator]).
///
/// The following usage
///
/// ```dart
/// // fluttils:
/// FutureBuilder<int>(
///   someFuture,
///   onDone: (_, data) => Text("value: $data"),
/// );
/// ```
///
/// is equivalent to
///
/// ```dart
/// // flutter:
/// FutureBuilder<int>(
///   future: someFuture,
///   builder: (_, snapshot) {
///     if (snapshot.connectionState == ConnectionState.waiting)
///       return Center(child: CircularProgressIndicator());
///     final int data = snapshot.data!;
///     return Text("value: $data");
///   },
/// );
/// ```
class FutureBuilder<T> extends f.StatelessWidget {
  static f.Widget _onErrorDefault(
    f.BuildContext context,
    Object error,
    StackTrace stackTrace,
  ) =>
      f.ErrorWidget(error);

  final Future<T> future;
  final f.Widget Function(f.BuildContext, T) onDone;
  final f.Widget Function(f.BuildContext, Object, StackTrace) onError;
  final f.Widget indicator;
  final T? initialData;

  /// Creates a [FutureBuilder] with some commonly used [f.FutureBuilder]
  /// parameters.
  ///
  /// The widget returned by [onDone] will be displayed when the connection
  /// state is [f.ConnectionState.done]. The [indicator] widget will be displayed
  /// while the connection state is [f.ConnectionState.waiting]. If not provided,
  /// a centered [f.CircularProgressIndicator] will be displayed. The widget
  /// returned by [onError] will be displayed when the future completes with an
  /// error. If not provided, an [f.ErrorWidget] will be displayed.
  const FutureBuilder(
    this.future, {
    required this.onDone,
    this.initialData,
    this.onError = _onErrorDefault,
    this.indicator = const f.Center(child: f.CircularProgressIndicator()),
  });

  @override
  f.Widget build(f.BuildContext context) {
    final T? initialData = this.initialData;
    return f.FutureBuilder<AsyncResult>(
      future: future
          .then<AsyncResult>((value) => AsyncResult.complete(value: value))
          .catchError((e, s) => AsyncResult.error(error: e, stackTrace: s)),
      initialData:
          initialData == null ? null : AsyncResult.complete(value: initialData),
      builder: (context, snapshot) {
        if (snapshot.connectionState == f.ConnectionState.waiting) {
          return indicator;
        }
        final AsyncResult result = snapshot.data!;
        return result.apply(AsyncResultWidgetBuilder(
          onComplete: (value) => onDone(context, value as T),
          onError: (e, s) => onError(context, e, s),
        ));
      },
    );
  }
}

/// A [f.StreamBuilder] that displays a progress indicator while its connection
/// state is waiting.
///
/// The widget provided by [onData] will only be displayed when the connection
/// state is equal to [f.ConnectionState.done] or [f.ConnectionState.active].
///
/// The progress indicator can be changed using the [indicator] parameter
/// (defaults to a centered [f.CircularProgressIndicator]).
///
/// The following usage
///
/// ```dart
/// // fluttils:
/// StreamBuilder<int>(
///   someStream,
///   builder: (_, data) => Text("value: $data"),
/// );
/// ```
///
/// is equivalent to
///
/// ```dart
/// // flutter:
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
class StreamBuilder<T> extends f.StatelessWidget {
  static f.Widget _onErrorDefault(
    f.BuildContext context,
    Object error,
    StackTrace stackTrace,
  ) =>
      f.ErrorWidget(error);

  final Stream<T> stream;
  final f.Widget Function(f.BuildContext, T) onData;
  final f.Widget Function(f.BuildContext, Object, StackTrace) onError;
  final f.Widget indicator;
  final T? initialData;

  /// Creates a [StreamBuilder] with some commonly used [f.StreamBuilder]
  /// parameters.
  ///
  /// The widget returned by [onData] will be displayed when the connection state
  /// is not [f.ConnectionState.waiting]. The [indicator] widget will be displayed
  /// while the connection state is [f.ConnectionState.waiting]. If not provided,
  /// a centered [f.CircularProgressIndicator] will be displayed. The widget
  /// returned by [onError] will be displayed when the future completes with an
  /// error. If not provided, an [f.ErrorWidget] will be displayed.
  const StreamBuilder(
    this.stream, {
    required this.onData,
    this.initialData,
    this.onError = _onErrorDefault,
    this.indicator = const f.Center(child: f.CircularProgressIndicator()),
  });

  @override
  f.Widget build(f.BuildContext context) {
    final T? initialData = this.initialData;
    return f.StreamBuilder<AsyncResult>(
      stream: stream
          .map<AsyncResult>((value) => AsyncResult.complete(value: value))
          .handleError((e, s) => AsyncResult.error(error: e, stackTrace: s)),
      initialData:
          initialData == null ? null : AsyncResult.complete(value: initialData),
      builder: (context, snapshot) {
        if (snapshot.connectionState == f.ConnectionState.waiting) {
          return indicator;
        }
        final AsyncResult result = snapshot.data!;
        return result.apply(AsyncResultWidgetBuilder(
          onComplete: (value) => onData(context, value as T),
          onError: (e, s) => onError(context, e, s),
        ));
      },
    );
  }
}

/// A [f.EdgeInsets] that combines the [f.EdgeInsets.only], [f.EdgeInsets.symmetric]
/// and [f.EdgeInsets.all] constructors.
///
/// The following usages are equivalent:
///
/// ```dart
/// // fluttils:
/// // flutter:
///
/// EdgeInsets(all: 5);
/// EdgeInsets.all(5);
///
/// EdgeInsets(width: 2, height: 3);
/// EdgeInsets.symmetric(horizontal: 2, vertical: 3);
///
/// EdgeInsets(left: 1, top: 4);
/// EdgeInsets.only(left: 1, top: 4);
///
/// EdgeInsets(all: 5, right: 3);
/// EdgeInsets.only(left: 5, right: 3, top: 5, bottom: 5);
///
/// EdgeInsets(all: 10, width: 20, top: 5);
/// EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 10);
/// ```
class EdgeInsets extends f.EdgeInsets {
  static List<double> _parseLRTB(List<double?> awhlrtb) {
    return List.generate(4, (i) {
      int vi;
      for (vi = i + 3; vi >= 0 && awhlrtb[vi] == null; vi = (vi - 1) ~/ 2) {
        if (vi == 0) return 0;
      }
      return awhlrtb[vi]!;
    });
  }

  EdgeInsets._(
    List<double> lrtb,
  ) : super.only(left: lrtb[0], right: lrtb[1], top: lrtb[2], bottom: lrtb[3]);

  /// Creates an [EdgeInsets].
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
  EdgeInsets({
    double? all,
    double? width,
    double? height,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) : this._(_parseLRTB([all, width, height, left, right, top, bottom]));
}

/// A [f.Padding] that combines [f.EdgeInsets.only], [f.EdgeInsets.symmetric] and
/// [f.EdgeInsets.all] as values.
///
/// The following usages are equivalent:
///
/// ```dart
/// /// fluttils:
/// /// flutter:
///
/// Padding(all: 5);
/// Padding(padding: EdgeInsets.all(5));
///
/// Padding(width: 2, height: 3);
/// Padding(padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3));
///
/// Padding(left: 1, top: 4);
/// Padding(padding: EdgeInsets.only(left: 1, top: 4));
///
/// Padding(all: 5, right: 3);
/// Padding(padding: EdgeInsets.only(left: 5, right: 3, top: 5, bottom: 5));
///
/// Padding(all: 10, width: 20, top: 5);
/// Padding(padding: EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 10));
/// ```
class Padding extends f.StatelessWidget {
  final f.Widget child;
  final double? all;
  final double? width;
  final double? height;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;

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
  const Padding({
    required this.child,
    this.all,
    this.width,
    this.height,
    this.left,
    this.right,
    this.top,
    this.bottom,
    f.Key? key,
  }) : super(key: key);

  @override
  f.Widget build(f.BuildContext context) {
    return Provider<EdgeInsets>(
      create: (_) => EdgeInsets(
        all: all,
        width: width,
        height: height,
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
      child: Consumer<EdgeInsets>(
        builder: (context, insets, _) => f.Padding(
          key: key,
          padding: insets,
          child: child,
        ),
      ),
    );
  }
}

/// A widget that hides or show a [child] widget.
///
/// If [isVisible] is false, the size, state and animation of the widget will be
/// maintained.
///
/// The following usage
///
/// ```dart
/// // fluttils:
/// Visibility(child: Text("hidden"), visible: false, level: VisibilityLevel.size());
/// ```
///
/// is equivalent to
///
/// ```dart
/// // flutter:
/// Visibility(
///    child: Text("hidden"),
///    visible: false,
///    maintainState: true,
///    maintainAnimation: true,
///    maintainSize: true,
///  );
/// ```
class Visibility extends f.StatelessWidget {
  final bool visible;
  final VisibilityLevel level;
  final f.Widget child;

  const Visibility({
    f.Key? key,
    required this.child,
    this.visible = true,
    this.level = const VisibilityLevel.none(),
  }) : super(key: key);

  const Visibility.fromLevel({
    f.Key? key,
    required f.Widget child,
    VisibilityLevel? level,
  }) : this(
            key: key,
            child: child,
            visible: level == null,
            level: level ?? const VisibilityLevel.none());

  @override
  f.Widget build(f.BuildContext context) => f.Visibility(
        key: key,
        visible: visible,
        child: child,
        maintainState: level.maintainState,
        maintainAnimation: level.maintainAnimation,
        maintainSize: level.maintainSize,
        maintainInteractivity: level.maintainInteractivity,
        maintainSemantics: level.maintainSemantics,
      );
}

/// Defines a configuration for [f.Visibility] that follows the rules defined by
/// its constructor.
class VisibilityLevel {
  final bool maintainState;
  final bool maintainAnimation;
  final bool maintainSize;
  final bool maintainSemantics;
  final bool maintainInteractivity;

  const VisibilityLevel._({
    this.maintainState = false,
    this.maintainAnimation = false,
    this.maintainSize = false,
    this.maintainSemantics = false,
    this.maintainInteractivity = false,
  });

  /// Completely hides the widget.
  const VisibilityLevel.none({
    bool maintainState = false,
  }) : this._(maintainState: maintainState);

  /// Maintains the state of the widget.
  ///
  /// The [maintainAnimation] argument can only be set if [maintainState] is set.
  const VisibilityLevel.state({
    bool maintainAnimation = false,
  }) : this._(maintainState: true, maintainAnimation: maintainAnimation);

  /// Maintains the animation of the widget.
  ///
  /// The [maintainSize] argument can only be set if [maintainAnimation] is set.
  const VisibilityLevel.animation({
    bool maintainSize = false,
  }) : this._(
            maintainState: true,
            maintainAnimation: true,
            maintainSize: maintainSize);

  /// Maintains the size of the widget.
  ///
  /// The [maintainSemantics] and [maintainInteractivity] arguments can only be set if [maintainSize] is set.
  const VisibilityLevel.size({
    bool maintainSemantics = false,
    bool maintainInteractivity = false,
  }) : this._(
            maintainState: true,
            maintainAnimation: true,
            maintainSize: true,
            maintainSemantics: maintainSemantics,
            maintainInteractivity: maintainInteractivity);
}

/// A [f.Stack] that can be created using a [Map].
///
/// The following usage
///
/// ```dart
/// StackMap({
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
class MapStack extends f.StatelessWidget {
  final Map<f.Alignment, f.Widget> alignments;
  final f.AlignmentDirectional alignment;
  final f.Clip clipBehavior;
  final f.StackFit fit;

  /// Creates a [SimpleStack].
  ///
  /// Each key of the map will be the alignment of its respective widget in the
  /// stack.
  const MapStack(
    this.alignments, {
    f.Key? key,
    this.alignment = f.AlignmentDirectional.topStart,
    this.clipBehavior = f.Clip.hardEdge,
    this.fit = f.StackFit.loose,
  }) : super(key: key);

  @override
  f.Widget build(f.BuildContext context) => f.Stack(
        key: key,
        alignment: alignment,
        clipBehavior: clipBehavior,
        fit: fit,
        children: alignments.entries
            .map((entry) => f.Align(alignment: entry.key, child: entry.value))
            .toList(),
      );
}

/// A splash screen used for loading purposes.
///
/// If [init] ends first than [duration], then the duration of the splash will
/// be [duration], otherwise it will be the execution time of [init].
class SplashScreen extends f.StatelessWidget {
  final Duration duration;
  final f.Widget content;
  final f.Widget Function(f.BuildContext) builder;
  final Future<void> init;

  /// Creates a [SplashScreen].
  ///
  /// The minimum [duration] of this splash defaults to three seconds.
  const SplashScreen({
    f.Key? key,
    required this.init,
    required this.content,
    required this.builder,
    this.duration = const Duration(seconds: 3),
  }) : super(key: key);

  /// Creates a [SplashScreen] with no [duration].
  ///
  /// This means that [builder] will be called as soon as [init] completes.
  const SplashScreen.short({
    f.Key? key,
    required Future<void> init,
    required f.Widget content,
    required f.Widget Function(f.BuildContext) builder,
  }) : this(
            key: key,
            init: init,
            content: content,
            builder: builder,
            duration: Duration.zero);

  @override
  f.Widget build(f.BuildContext context) {
    return FutureProvider<f.ConnectionState>(
      initialData: f.ConnectionState.waiting,
      create: (_) => Future.wait([Future.delayed(duration), init])
          .then((_) => f.ConnectionState.done),
      child: Consumer<f.ConnectionState>(
        builder: (context, state, _) =>
            state == f.ConnectionState.waiting ? content : builder(context),
      ),
    );
  }
}

/// Hides the soft keyboard by clicking outside of a [TextField] or anywhere on the screen.
///
/// The following usage
///
/// ```dart
/// ContextUnfocuser(child: TextFormField());
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
class ContextUnfocuser extends f.StatelessWidget {
  /// The widget below this widget in the tree.
  final f.Widget child;

  /// Creates a [ContextUnfocuser].
  const ContextUnfocuser({f.Key? key, required this.child}) : super(key: key);

  @override
  f.Widget build(f.BuildContext context) => f.GestureDetector(
        onTap: () => f.FocusScope.of(context).unfocus(),
        child: child,
      );
}

/// A [f.ListView] that creates its children by a map function.
///
/// It's equivalent to [ListView.builder].
class MappedListView<T> extends f.StatelessWidget {
  final List<T> values;
  final f.Widget Function(f.BuildContext, T) builder;
  final bool shrinkWrap;
  final f.ScrollPhysics? physics;

  const MappedListView(
    this.values, {
    f.Key? key,
    required this.builder,
    this.shrinkWrap = false,
    this.physics,
  }) : super(key: key);

  @override
  f.Widget build(f.BuildContext context) => f.ListView.builder(
        itemCount: values.length,
        itemBuilder: (context, i) => builder(context, values[i]),
        physics: physics,
        shrinkWrap: shrinkWrap,
      );
}

/// A [f.Scaffold] wrapped in a [f.SafeArea].
///
/// Useful when using [f.Scaffold] as root widget.
class SafeScaffold extends f.StatelessWidget {
  final f.PreferredSizeWidget? appBar;
  final f.Color? backgroundColor;
  final f.Widget? body;
  final f.FloatingActionButton? floatingActionButton;
  final f.Widget? bottomNavigationBar;

  /// Creates a [SafeScaffold] with some commonly used [f.Scaffold] parameters.
  const SafeScaffold({
    this.appBar,
    this.backgroundColor,
    this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    f.Key? key,
  }) : super(key: key);

  @override
  f.Widget build(f.BuildContext context) {
    return f.SafeArea(
      child: f.Scaffold(
        appBar: appBar,
        backgroundColor: backgroundColor,
        body: body,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}

/// A [f.SizedBox] with only the height value set.
class Height extends f.SizedBox {
  /// Creates a [Height] with size [value].
  const Height([double value = 0]) : super(height: value);
}

/// A [f.SizedBox] with only the width value set.
class Width extends f.SizedBox {
  /// Creates a [Width] with size [value].
  const Width([double value = 0]) : super(width: value);
}

/// A widget that intersperse a group of children with a separator.
///
/// This widget is equivalent to [ListView.separated], but (1) this widget is
/// not scrollable and (2) the children of this widget are not generated on
/// demand.
///
/// The following usages are equivalent:
///
/// ```dart
/// // fluttils:
/// // flutter:

/// Separated.col([], separator: Divider())
/// Column()
///
/// Separated.row([Text("1")], Divider())
/// Row(children: [Text("1")])
///
/// Separated.col([Text("1"), Text("2")], Divider())
/// Column(children: [Text("1"), Divider(), Text("2")])
///
/// Separated.row([Text("1"), Text("2"), Text("3")], Divider())
/// Row(children: [Text("1"), Divider(), Text("2"), Divider(), Text("3")])
/// ```
class Separated extends f.StatelessWidget {
  final f.Axis direction;
  final List<f.Widget> children;
  final f.Widget separator;
  final f.MainAxisSize mainAxisSize;
  final f.MainAxisAlignment mainAxisAlignment;
  final f.CrossAxisAlignment crossAxisAlignment;

  const Separated._(
    this.children, {
    f.Key? key,
    required this.direction,
    required this.separator,
    this.mainAxisSize = f.MainAxisSize.max,
    this.mainAxisAlignment = f.MainAxisAlignment.start,
    this.crossAxisAlignment = f.CrossAxisAlignment.center,
  }) : super(key: key);

  /// Creates a interspersed, vertical array of [children] with a given
  /// [separator].
  const Separated.col(
    List<f.Widget> children, {
    f.Key? key,
    required f.Widget separator,
    f.MainAxisSize mainAxisSize = f.MainAxisSize.max,
    f.MainAxisAlignment mainAxisAlignment = f.MainAxisAlignment.start,
    f.CrossAxisAlignment crossAxisAlignment = f.CrossAxisAlignment.center,
  }) : this._(children,
            key: key,
            direction: f.Axis.vertical,
            separator: separator,
            mainAxisSize: mainAxisSize,
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment);

  /// Creates a interspersed, horizontal array of [children] with a given
  /// [separator].
  const Separated.row(
    List<f.Widget> children, {
    f.Key? key,
    required f.Widget separator,
    f.MainAxisSize mainAxisSize = f.MainAxisSize.max,
    f.MainAxisAlignment mainAxisAlignment = f.MainAxisAlignment.start,
    f.CrossAxisAlignment crossAxisAlignment = f.CrossAxisAlignment.center,
  }) : this._(children,
            key: key,
            direction: f.Axis.horizontal,
            separator: separator,
            mainAxisSize: mainAxisSize,
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment);

  @override
  f.Widget build(f.BuildContext context) {
    return Provider<List<f.Widget>>(
      create: (_) {
        if (children.isEmpty) return [];
        return List.generate(
          2 * children.length - 1,
          (i) => i % 2 == 0 ? children[i ~/ 2] : separator,
        );
      },
      child: Consumer<List<f.Widget>>(
        builder: (context, children, _) => f.Flex(
          direction: direction,
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        ),
      ),
    );
  }
}
