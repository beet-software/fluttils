import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension BuildContextUtils<T> on BuildContext {
  NavigatorState get _navigator => Navigator.of(this);

  MediaQueryData get _mediaQuery => MediaQuery.of(this);

  /// See `size` attribute of [MediaQueryData].
  Size get screenSize => _mediaQuery.size;

  /// See `maybePop` method of [NavigatorState].
  void maybePop([T result]) => _navigator.maybePop(result);

  /// See `pop` method of [NavigatorState].
  void pop([T result]) => _navigator.pop(result);

  /// See `push` and `pushReplacement` methods of [NavigatorState].
  Future<T> push<T>(Widget widget, {bool replace = false}) async {
    final MaterialPageRoute<T> mpr = MaterialPageRoute(builder: (_) => widget);
    if (replace) return await _navigator.pushReplacement(mpr);
    return await _navigator.push(mpr);
  }

  /// See `pushNamed` and `pushReplacementNamed` methods of [NavigatorState].
  Future<T> pushNamed<T>(String routeName, {bool replace = false}) async {
    if (replace) return await _navigator.pushReplacementNamed(routeName);
    return await _navigator.pushNamed(routeName);
  }
}
