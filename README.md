# fluttils

fluttils is a package that helps you to write less code in your application
by selecting some frequently-used patterns and extracting them into new classes
or functions, avoiding you having to creating those patterns by yourself or
rewriting them everytime you develop a new application.

## Examples

This example uses a `Text` widget with some `TextStyle`.

**Using Flutter:**

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
    Text(
      "Hello world!",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.red,
        fontSize: 24));
}
```

**Using fluttils:**

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
    StyledText(
      "Hello world!", 
      [FontWeight.bold, Colors.red, 24]);
}
```

This example uses a `ListView.builder` with a list of values.

**Using Flutter:**

```dart
class MyWidget extends StatelessWidget {
  final List<int> values = [1, 2, 3];
  @override
  Widget build(BuildContext context) =>
    ListView.builder(
      itemCount: values.length,
      itemBuilder: (_, i) => Text("${values[i]}"));
}
```

**Using fluttils:**

```dart
class MyWidget extends StatelessWidget {
  final List<int> values = [1, 2, 3];
  @override
  Widget build(BuildContext context) =>
    OnDemandListView.mapped(values, (_, v) => Text("$v"));
}
```