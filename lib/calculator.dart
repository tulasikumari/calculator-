import 'package:flutter/material.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CalculatorViewState createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  String result = '';
  final List<String> buttons = [
    '7', '8', '9', '/',
    '4', '5', '6', '*',
    '1', '2', '3', '-',
    '0', '.', '=', '+',
    'C', '<', '(', ')', // Additional buttons
  ];

  void onButtonTap(String buttonText) {
    setState(() {
      if (buttonText == '=') {
        try {
          result = _evaluateExpression(result);
        } catch (e) {
          result = 'Error';
        }
      } else if (buttonText == 'C') {
        result = '';
      } else if (buttonText == '<') {
        // Remove the last character
        result =
            result.isNotEmpty ? result.substring(0, result.length - 1) : '';
      } else {
        result += buttonText;
      }
    });
  }

  String _evaluateExpression(String expression) {
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
    List<String> operands = expression.split(RegExp(r'[-+*/]'));
    List<String> operators = expression
        .split(RegExp(r'[0-9.]'))
        .where((element) => element.isNotEmpty)
        .toList();

    for (int i = 0; i < operators.length; i++) {
      if (operators[i] == '*') {
        double result =
            double.parse(operands[i]) * double.parse(operands[i + 1]);
        operands[i] = result.toString();
        operands.removeAt(i + 1);
        operators.removeAt(i);
        i--;
      } else if (operators[i] == '/') {
        double result =
            double.parse(operands[i]) / double.parse(operands[i + 1]);
        operands[i] = result.toString();
        operands.removeAt(i + 1);
        operators.removeAt(i);
        i--;
      }
    }

    double finalResult = double.parse(operands[0]);
    for (int i = 0; i < operators.length; i++) {
      if (operators[i] == '+') {
        finalResult += double.parse(operands[i + 1]);
      } else if (operators[i] == '-') {
        finalResult -= double.parse(operands[i + 1]);
      }
    }

    // Check if the result is a whole number
    if (finalResult % 1 == 0) {
      return finalResult.toInt().toString();
    } else {
      return finalResult.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Calculator'),
          backgroundColor: Colors.grey[200],
          centerTitle: true,
        ),
        body: Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(text: result),
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 40.0),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(16.0),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                flex: 4,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: buttons.length,
                  itemBuilder: (BuildContext context, int index) {
                    final button = buttons[index];
                    return CalculatorButton(
                      button: button,
                      onButtonTap: onButtonTap,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String button;
  final Function(String) onButtonTap;

  const CalculatorButton(
      {Key? key, required this.button, required this.onButtonTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: RawMaterialButton(
        onPressed: () {
          onButtonTap(button);
        },
        elevation: 0.0,
        constraints: const BoxConstraints.expand(),
        shape: const CircleBorder(),
        fillColor: Colors.white,
        child: Center(
          child: Text(
            button,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
