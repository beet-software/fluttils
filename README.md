# fluttils

[![Pub version](https://img.shields.io/pub/v/fluttils)](https://pub.dev/packages/fluttils) [![Pub points](https://badges.bar/fluttils/pub%20points)](https://pub.dev/packages/fluttils/score) [![Travis](https://travis-ci.org/enzo-santos/fluttils.svg?branch=main)](https://travis-ci.org/github/enzo-santos/fluttils) [![codecov](https://codecov.io/gh/enzo-santos/fluttils/branch/main/graph/badge.svg)](https://codecov.io/gh/enzo-santos/fluttils)

fluttils is a package that helps you to write less code in your application
by selecting some frequently used patterns and extracting them into new classes
or functions, avoiding you having to creating those patterns by yourself or
rewriting them every time you develop a new application.

## Examples

- Using `BuildContext` extension methods:

```dart
void _(BuildContext context, Widget widget) {
  // fluttils:
  // flutter: 
  
  context.pop();
  Navigator.of(context).pop();

  context.push(widget);
  Navigator.of(context).push(MaterialPageRoute((_) => widget));
  
  context.push(widget, replace: true);
  Navigator.of(context).pushReplacement(MaterialPageRoute((_) => widget));

  context.screenSize;
  MediaQuery.of(context).size;
}
```

- Using `Text` with a list of parameters:

```dart
import 'package:fluttils/fluttils.dart' as f;

void _(String label) {
    // fluttils:
    // flutter: 
    
    f.Text(label);
    Text(label);
  
    f.Text(label, [Colors.red]);
    Text(label, style: TextStyle(color: Colors.red));
    
    f.Text(label, [Colors.white, TextAlign.center, FontWeight.bold]);
    Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center);
}
```

- Using a simplified `Padding` widget:

```dart
import 'package:fluttils/fluttils.dart' as f;

void _(Widget widget) {
  // fluttils:
  // flutter: 

  f.Padding(all: 5, child: widget);
  Padding(padding: EdgeInsets.all(5), child: widget);

  f.Padding(height: 1, width: 3, child: widget);
  Padding(padding: EdgeInsets.symmetric(vertical: 1, horizontal: 3), child: widget);
  
  f.Padding(all: 4, left: 2, child: widget);
  Padding(padding: EdgeInsets.only(left: 2, right: 4, top: 4, bottom: 4), child: widget);
  
  f.Padding(all: 10, left: 15, height: 20, child: widget);
  Padding(padding: EdgeInsets.only(left: 15, right: 10, top: 20, bottom: 20), child: widget);    
}
```

- Using `MapStack` as a replacement to `Stack` in basic scenarios:

```dart
import 'package:fluttils/fluttils.dart' as f;

void _() {
  // fluttils:
  // flutter: 

  f.MapStack({Alignment.center: Text("a")});
  Stack(children: [Align(alignment: Alignment.center, child: Text("a"))]);

  f.MapStack({
    Alignment.topLeft: Icon(Icons.right_arrow),
    Alignment.bottomRight: Icon(Icons.add),
  });
  Stack(children: [
    Align(alignment: Alignment.topLeft, child: Icon(Icons.right_arrow)),
    Align(alignment: Alignment.bottomRight, child: Icon(Icons.add)),
  ]);
}
```

- Using an easier-to-configure `Visibility` widget:

```dart
import 'package:fluttils/fluttils.dart' as f;

void _(Widget widget) {
  f.Visibility(visible: false, child: widget);
  Visibility(visible: false, child: widget);
  
  f.Visibility(visible: false, child: widget, level: f.VisibilityLevel.state());
  Visibility(visible: false, child: widget, maintainState: true);

  f.Visibility(visible: false, child: widget, level: f.VisibilityLevel.animation());
  Visibility(visible: false, child: widget, maintainState: true, maintainAnimation: true);
  
  f.Visibility(visible: false, child: widget, level: f.VisibilityLevel.size());
  Visibility(visible: false, child: widget, maintainState: true, maintainAnimation: true, maintainSize: true);

  f.Visibility(visible: false, child: widget, level: f.VisibilityLevel.size(maintainSemantics: true));
  Visibility(visible: false, child: widget, maintainState: true, maintainAnimation: true, maintainSize: true, maintainSemantics: true);
}
```

See [the docs](https://pub.dev/documentation/fluttils/latest/fluttils/fluttils-library.html)
for a list of all widgets, functions and extensions provided by the package.
