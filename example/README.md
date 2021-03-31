# Examples

These are some examples that uses fluttils components.

Their Flutter counterparts appears as comments right above each usage.

## Extensions

Using `BuildContextUtils`:

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

## Widgets

Using `SimplePadding`:

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

Using `StyledText`:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Equivalent to Text("color", style: TextStyle(color: Colors.red));
          StyledText("color", [Colors.red]),
          // Equivalent to Text("weight", style: TextStyle(fontWeight: FontWeight.bold));
          StyledText("fontWeight", [FontWeight.bold]),
          // Equivalent to Text("fontSize", style: TextStyle(fontSize: 24));
          StyledText("fontSize", [24]),
          // Equivalent to Text("fontStyle", style: TextStyle(fontStyle: FontStyle.italic));
          StyledText("fontStyle", [FontStyle.italic]),
          // Equivalent to Text("locale", style: TextStyle(locale: Locale("en", "US")));
          StyledText("locale", [Locale("en", "US")]),
          // Equivalent to Text("color && fontWeight", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold));
          StyledText("color && fontWeight", [Colors.red, FontWeight.bold]),
          // Equivalent to Text("fontSize && fontSize", style: TextStyle(fontSize: 16));
          StyledText("fontSize && fontSize", [19, 16]),
        ],
      ),
    );
  }
}
```

Using `OnDemandListView`:

```dart
class MyWidget extends StatelessWidget {
  static const List<int> values = [1, 2, 3];
  
  @override
  Widget build(BuildContext context) {
    /*
    Equivalent to:
    
    return ListView.builder(
      itemCount: values.length,
      itemBuilder: (_, i) => Text("${values[i]}"));
    */
    return OnDemandListView.mapped(values, (_, v) => Text("$v"));
  }
}
```

Using `SimpleStack`:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*
    Equivalent to:
    
    Stack(
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Text("Title"),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(icon: Icon(Icons.arrow_back)),
        ),
      ] 
    );
    */
    return SimpleStack({
      Alignment.bottomRight: FloatingActionButton(),
      Alignment.topCenter: Text("Title"),
      Alignment.topLeft: IconButton(icon: Icon(Icons.arrow_back)),
    });
  }
}
```