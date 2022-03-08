import 'package:flutter/material.dart' as f;
import 'package:fluttils/src/extensions.dart';

/// Shows a [AlertDialog] with a single action button that closes this dialog.
///
/// The text of the action button can be changed using [positiveText].
Future<void> showSimpleDialog(
  f.BuildContext context,
  f.Widget title,
  f.Widget content, {
  required String positiveText,
}) async {
  return await f.showDialog(
    context: context,
    builder: (context) {
      return f.AlertDialog(
        title: title,
        content: content,
        actions: [
          f.TextButton(
            onPressed: () => context.pop(),
            child: f.Text(positiveText),
          )
        ],
      );
    },
  );
}

/// Shows a [AlertDialog] with two actions buttons, negative and positive, that
/// respectively pops either false or true.
///
/// The texts of these action buttons can be changed using [positiveText] and
/// [negativeText].
Future<bool?> showBinaryDialog(
  f.BuildContext context,
  f.Widget title,
  f.Widget content, {
  required String positiveText,
  required String negativeText,
}) async {
  return await f.showDialog(
    context: context,
    builder: (context) {
      return f.AlertDialog(
        title: title,
        content: content,
        actions: [
          f.TextButton(
            onPressed: () => context.pop(false),
            child: f.Text(negativeText),
          ),
          f.TextButton(
            onPressed: () => context.pop(true),
            child: f.Text(positiveText),
          ),
        ],
      );
    },
  );
}
