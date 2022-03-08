import 'package:flutter/material.dart' as f;

extension BuildContextUtils<T> on f.BuildContext {
  f.NavigatorState get _navigator => f.Navigator.of(this);

  f.MediaQueryData get _mediaQuery => f.MediaQuery.of(this);

  /// Corresponds to `size` attribute of [MediaQueryData].
  f.Size get screenSize => _mediaQuery.size;

  /// Corresponds to `maybePop` method of [NavigatorState].
  void maybePop([T? result]) => _navigator.maybePop(result);

  /// Corresponds to `pop` method of [NavigatorState].
  void pop([T? result]) => _navigator.pop(result);

  /// Corresponds to both `push` and `pushReplacement` methods of [NavigatorState].
  Future<T?> push<T>(f.Widget widget, {bool replace = false}) async {
    final f.MaterialPageRoute<T> mpr = f.MaterialPageRoute(
      builder: (_) => widget,
    );
    if (replace) return await _navigator.pushReplacement(mpr);
    return await _navigator.push(mpr);
  }

  /// See `pushNamed` and `pushReplacementNamed` methods of [NavigatorState].
  Future<T?> pushNamed<T>(String routeName, {bool replace = false}) async {
    if (replace) return await _navigator.pushReplacementNamed(routeName);
    return await _navigator.pushNamed(routeName);
  }
}
