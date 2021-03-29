import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttils/src/extensions.dart';

/// Shows a [AlertDialog] with a single action button that closes this dialog.
///
/// The text of the action button can be changed using [positiveText].
Future<void> showSimpleDialog(
    BuildContext context, Widget title, Widget content,
    {String positiveText = "OK"}) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: title,
          content: content,
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(positiveText),
            )
          ],
        );
      });
}

/// Shows a [AlertDialog] with two actions buttons, negative and positive, that
/// respectively pops either false or true.
///
/// The texts of these action buttons can be changed using [positiveText] and
/// [negativeText].
Future<bool> showBinaryDialog(
    BuildContext context, Widget title, Widget content,
    {String positiveText = "NO", String negativeText = "YES"}) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: title,
          content: content,
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: Text(negativeText),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              child: Text(positiveText),
            ),
          ],
        );
      });
}

/// Executes an [action] not now, but as soon as possible.
///
/// Useful for calling `Navigator.pop()` during `build`, for example, using
///
/// ```
/// @override
/// Widget build(BuildContext context) {
///   if (condition) {
///     asap(() => Navigator.of(context).pop());
///     return SizedBox.shrink();
///   }
///   return Text("world");
/// }
/// ```
Future<void> asap(VoidCallback action) => Future.delayed(Duration.zero, action);
