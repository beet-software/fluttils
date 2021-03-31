# fluttils

[![Pub version](https://img.shields.io/pub/v/fluttils)](https://pub.dev/packages/fluttils) [![Pub points](https://badges.bar/fluttils/pub%20points)](https://pub.dev/packages/fluttils/score)

fluttils is a package that helps you to write less code in your application
by selecting some frequently-used patterns and extracting them into new classes
or functions, avoiding you having to creating those patterns by yourself or
rewriting them every time you develop a new application.

## Examples

- Using `BuildContext` extension methods:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(
            child: Text("Pop true"),
            // Equivalent to Navigator.of(context).pop(true);
            onPressed: () => context.pop(true),
          ),
          TextButton(
            child: Text("Just pop it"),
            // Equivalent to Navigator.of(context).pop();
            onPressed: () => context.pop(),
          ),
          TextButton(
            child: Text("Push it"),
            // Equivalent to Navigator.of(context).push(MaterialPageRoute(builder: (_) => AnotherWidget()));
            onPressed: () => context.push(AnotherWidget()),
          ),
        ],
      ),
    );
  }
}
```

- Using a simplified `Padding` widget:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Equivalent to Padding(padding: EdgeInsets.all(5), child: Text("1"));
          SimplePadding(all: 5, child: Text("1")),
          // Equivalent to Padding(padding: EdgeInsets.symmetric(vertical: 1, horizontal: 3), child: Text("2"));
          SimplePadding(height: 1, width: 3, child: Text("2")),
          // Equivalent to Padding(padding: EdgeInsets.only(left: 2, right: 4, top: 4, bottom: 4), child: Text("3"));
          SimplePadding(all: 4, left: 2, child: Text("3")),
          // Equivalent to Padding(padding: EdgeInsets.only(left: 15, right: 10, top: 20, bottom: 20), child: Text("4"));
          SimplePadding(all: 10, left: 15, height: 20, child: Text("4")),
        ],
      ),
    );
  }
}
```

See [the *example* directory](https://github.com/enzo-santos/fluttils/tree/main/example) for a list 
of examples and their respective Flutter counterparts.

## Documentation

See [the docs](https://pub.dev/documentation/fluttils/latest/fluttils/fluttils-library.html)
for a list of all widgets, functions and extensions available by the package.

