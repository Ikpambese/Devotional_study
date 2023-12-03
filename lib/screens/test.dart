import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class NumberSelectionWidget extends StatefulWidget {
  final int minNumber;
  final int maxNumber;

  NumberSelectionWidget({required this.minNumber, required this.maxNumber});

  @override
  _NumberSelectionWidgetState createState() => _NumberSelectionWidgetState();
}

class _NumberSelectionWidgetState extends State<NumberSelectionWidget> {
  int selectedNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Selected Number: $selectedNumber',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 20),
        Slider(
          value: selectedNumber.toDouble(),
          min: widget.minNumber.toDouble(),
          max: widget.maxNumber.toDouble(),
          onChanged: (newValue) {
            setState(() {
              selectedNumber = newValue.round();
            });
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Do something with the selected number
            print('Selected Number: $selectedNumber');
          },
          child: Text('Select $selectedNumber'),
        ),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Number Selection Widget'),
        ),
        body: Center(
          child: NumberSelectionWidget(minNumber: 1, maxNumber: 10),
        ),
      ),
    );
  }
}
