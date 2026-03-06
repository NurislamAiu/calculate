import 'package:flutter/material.dart';
import 'my_home_page.dart'; // We import our calculator screen file here.

// BEGINNER'S EXPLANATION: The `main` function
// Every Dart program (and therefore every Flutter app) starts executing from the `main` function.
// It's the entry point of our entire application.
void main() {
  // `runApp` is a special function provided by Flutter that takes a Widget and makes it
  // the root of our entire widget tree. In simple terms, it tells Flutter "this is my
  // main app widget, please put it on the screen."
  runApp(const MyApp());
}

// BEGINNER'S EXPLANATION: What is a `StatelessWidget`?
// As we learned in `my_home_page.dart`, some widgets have a "State" that can change over time.
// But this `MyApp` widget is different. It's a `StatelessWidget`.
// A stateless widget is simpler. It describes a part of the user interface that doesn't
// depend on anything other than its own configuration information (the information given to it
// when it was created). It never changes on its own.
// Our `MyApp` widget is a perfect example: it just sets up the basic structure of the app
// (like the title and theme) and that's it. It never needs to rebuild itself.
class MyApp extends StatelessWidget {
  // `const` means this widget can be created at compile time, which is a performance optimization.
  // `super.key` is a way to pass a unique identifier to the parent `StatelessWidget` class.
  const MyApp({super.key});

  // BEGINNER'S EXPLANATION: The `build` Method
  // Just like in our stateful widget, the `build` method is where we describe what the UI
  // for this widget should look like.
  // The `context` object contains information about where this widget is located in the widget tree.
  @override
  Widget build(BuildContext context) {
    // `MaterialApp` is a core widget that provides a lot of standard mobile app functionality.
    // It sets up the app to use Material Design, handles navigation, and provides a theme.
    // Most Flutter apps start with this widget.
    return MaterialApp(
      // The title of our application, which is used by the operating system.
      title: 'Flutter Calculator',
      
      // `debugShowCheckedModeBanner: false` will remove the little "Debug" banner
      // from the top-right corner of the app. It's useful to turn this off for screenshots!
      debugShowCheckedModeBanner: false,

      // `ThemeData` lets us define a consistent color scheme, font styles, and more for our
      // entire application. This way, we don't have to style every single widget manually.
      theme: ThemeData(
        // The primary color swatch used throughout the app.
        primarySwatch: Colors.indigo,
        // This helps Flutter adjust the density of UI components to match the platform
        // (e.g., more compact on desktop, less compact on mobile).
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      
      // The `home` property defines what widget should be displayed as the main screen of our app.
      // Here, we are creating an instance of our `MyHomePage` widget from the other file,
      // and we're passing it a title to display in its app bar.
      home: const MyHomePage(title: 'Flutter Calculator'),
    );
  }
}
