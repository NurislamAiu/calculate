import 'package:flutter/material.dart';

// BEGINNER'S EXPLANATION: What are `StatefulWidget` and `State`?
// Flutter UIs are made of Widgets. Some widgets are simple and never change (like text on a button).
// These are called `StatelessWidget`.
// But our calculator needs to remember the current number, the history, etc., and the screen
// needs to UPDATE when these values change. For this, we use a `StatefulWidget`.
// A `StatefulWidget` doesn't hold the changing data (the "state") itself. Instead, it creates a
// companion `State` class (`_MyHomePageState` in our case) to do that job.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This `title` variable is passed in from the parent widget (`main.dart`). It's configuration, not state.
  final String title;

  // This is the required method for a StatefulWidget. It tells Flutter how to create its State object.
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// BEGINNER'S EXPLANATION: What is `with SingleTickerProviderStateMixin`?
// In Dart (the language Flutter uses), a "mixin" is a way to add abilities to a class without
// having to inherit from it.
// `SingleTickerProviderStateMixin` gives our `_MyHomePageState` class the ability to be a "Ticker".
// A Ticker is like a metronome that ticks on every new frame the screen draws (about 60 times per second).
// Our AnimationController needs this ticker to know when to update its animation value.
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  // BEGINNER'S EXPLANATION: State Variables
  // These are the variables that our app needs to remember. When we change them inside a special
  // function called `setState`, Flutter knows it needs to rebuild the screen to show the new values.
  String _history = ''; // Shows the first number and the operator (e.g., "123 +")
  String _output = '0';   // The main display of the calculator.
  double _num1 = 0;     // Stores the first number in a calculation (e.g., in "5 + 3", this would be 5).
  String _operand = ''; // Stores the operator (+, -, *, /).
  bool _isOperandPressed = false; // A flag to know if an operator was the last button pressed.

  // BEGINNER'S EXPLANATION: Animation Variables
  // `late` means we are promising Dart that we will give this variable a value before we ever use it.
  // We will do this in the `initState` function below.
  late AnimationController _animationController;
  late Animation<double> _translateAnimation;
  late Animation<double> _wobbleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _translateAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 15.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 15.0, end: -15.0), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: -15.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _wobbleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.05), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.05, end: -0.05), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: -0.05, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // BEGINNER'S EXPLANATION: The Core Logic (`_buttonPressed`)
  // This function is called every time any button is tapped. It's the "brain" of our calculator.
  // It takes one argument: the text of the button that was pressed (e.g., "7", "+", "C").
  void _buttonPressed(String buttonText) {
    // We wrap all our logic in `setState`. This is crucial! `setState` tells Flutter that our state
    // variables have changed and that it needs to run the `build` method again to update the screen.
    setState(() {
      // Case 1: The button is a number (0-9) or a decimal point.
      if (double.tryParse(buttonText) != null || buttonText == '.') {
        if (buttonText == '.' && _output.contains('.')) return; // Don't allow multiple decimals.
        if (_isOperandPressed) {
          _output = buttonText; // If an operator was just pressed, start a new number.
          _isOperandPressed = false;
        } else {
          _output = _output == '0' ? buttonText : _output + buttonText; // Otherwise, add to the current number.
        }
      // Case 2: The button is "C" (Clear).
      } else if (buttonText == 'C') {
        _history = '';
        _output = '0';
        _num1 = 0;
        _operand = '';
        _isOperandPressed = false;
      // Case 3: The button is an operator (+, -, *, /).
      } else if (buttonText == '+' || buttonText == '-' || buttonText == '*' || buttonText == '/') {
        if (_operand.isNotEmpty && !_isOperandPressed) {
          _performCalculation(); // If there's already a pending operation, calculate it first.
        }
        _num1 = double.parse(_output);
        _operand = buttonText;
        _history = '${_output.replaceAll(RegExp(r'\\.0$'), '')} $_operand';
        _isOperandPressed = true; // Set the flag so we know to start a new number next.
      // Case 4: The button is "=".
      } else if (buttonText == '=') {
        if (_operand.isNotEmpty && !_isOperandPressed) {
          _performCalculation();
          _history = ''; // Clear the history after showing the final result.
          _operand = '';
        }
      // Case 5 & 6: The button is a utility (+/-, %).
      } else if (buttonText == '+/-') {
        if (_output != '0') {
          _output = _output.startsWith('-') ? _output.substring(1) : '-$_output';
        }
      } else if (buttonText == '%') {
        _output = (double.parse(_output) / 100).toString();
      }

      // After all logic, check if the output is "67" to trigger the animation.
      if (_output == '67') {
        _animationController.forward(from: 0.0);
      }
    });
  }

  // BEGINNER'S EXPLANATION: Performing the Calculation
  // This function does the actual math. We moved it to its own function to keep our code clean.
  void _performCalculation() {
    double num2 = double.parse(_output);
    double result = 0;

    String num1String = _num1.toString().replaceAll(RegExp(r'\\.0$'), '');
    String num2String = num2.toString().replaceAll(RegExp(r'\\.0$'), '');
    
    // A `switch` statement is a clean way to handle multiple options for a single variable (`_operand`).
    switch (_operand) {
      case '+': result = _num1 + num2; break;
      case '-': result = _num1 - num2; break;
      case '*': result = _num1 * num2; break;
      case '/':
        if (num2 == 0) {
          _output = 'Error';
          return;
        }
        result = _num1 / num2;
        break;
    }
    _history = '$num1String $_operand $num2String =';
    // Format the result nicely (remove ".0" for whole numbers).
    _output = result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 2);
    _num1 = result; // Store the result as the new first number for chained calculations.
  }

  // BEGINNER'S EXPLANATION: Building a Reusable Button
  // We could have copied and pasted the code for every button, but that's messy. Instead, we
  // create a function that acts like a "button factory". We give it the button's text, and it
  // returns a fully styled and functional button widget. This is a core concept in Flutter.
  Widget _buildButton(String buttonText) {
    bool isOperator = buttonText == '/' || buttonText == '*' || buttonText == '-' || buttonText == '+' || buttonText == '=';
    bool isTopRow = buttonText == 'C' || buttonText == '+/-' || buttonText == '%';

    // `Expanded` tells the widget to take up available space within a Row or Column.
    // The `flex` property lets us make one widget bigger than others (our '0' button is twice as wide).
    return Expanded(
      flex: buttonText == '0' ? 2 : 1,
      // `GestureDetector` is a simple way to make any widget tappable.
      child: GestureDetector(
        onTap: () => _buttonPressed(buttonText),
        // `Container` is a versatile widget for styling (color, shape, borders, shadows).
        child: Container(
          margin: const EdgeInsets.all(8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFE0E5EC),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1), offset: const Offset(4, 4), blurRadius: 10, spreadRadius: 1),
              const BoxShadow(
                  color: Colors.white, offset: Offset(-4, -4), blurRadius: 10, spreadRadius: 1),
            ],
          ),
          // `Text` is the widget for displaying text. We use `TextStyle` to change its font, size, and color.
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.w600,
              color: isOperator ? Colors.orange.shade800 : (isTopRow ? Colors.grey.shade800 : Colors.black54),
            ),
          ),
        ),
      ),
    );
  }

  // BEGINNER'S EXPLANATION: The `build` Method
  // This is the most important method in any widget. It describes what the UI should look like.
  // Flutter calls this method whenever the widget is first created and any time `setState` is called.
  @override
  Widget build(BuildContext context) {
    // `Scaffold` is a basic page layout widget from the Material library. It gives us common
    // features like an `appBar` (the bar at the top) and a `body` (the rest of the screen).
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.grey.shade800)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // The `body` is wrapped in our `AnimatedBuilder` to make the whole UI wobble.
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_translateAnimation.value, 0),
            child: Transform.rotate(
              angle: _wobbleAnimation.value,
              child: child,
            ),
          );
        },
        // The `child` of the builder is the actual calculator layout.
        // `Column` is a layout widget that arranges its children vertically.
        child: Column(
          children: <Widget>[
            // This `Expanded` contains the calculator's display screen.
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_history, style: TextStyle(fontSize: 24.0, color: Colors.grey.shade600)),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(_output,
                          style: const TextStyle(fontSize: 64.0, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ),
                  ],
                ),
              ),
            ),
            // This `Padding` widget adds some space around the button area.
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  // Each `Row` widget arranges its children horizontally, creating a row of buttons.
                  // We call our `_buildButton` "factory" to create the buttons for each row.
                  Row(children: [_buildButton('C'), _buildButton('+/-'), _buildButton('%'), _buildButton('/')]),
                  Row(children: [_buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('*')]),
                  Row(children: [_buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('-')]),
                  Row(children: [_buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('+')]),
                  Row(children: [_buildButton('0'), _buildButton('.'), _buildButton('=')]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
