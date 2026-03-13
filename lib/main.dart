import 'package:example/row_and_column.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.indigo,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      home: const RowAndColumn(),
    );
  }
}
