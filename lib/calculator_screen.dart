import 'package:calculator_project/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ""; //. or 0-9
  String operand = ""; // + - x ÷
  String number2 = ""; //. or 0-9
  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          //output
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16),
                child: Text(
                  "$number1$operand$number2".isEmpty
                      ? "0"
                      : "$number1$operand$number2",
                  style: const TextStyle(
                      fontSize: 55, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ),
          //buttons
          Wrap(
            children: Button.buttonValues
                .map(
                  (value) => SizedBox(
                    width: value == Button.calculate
                        ? screensize.width / 2
                        : (screensize.width / 4),
                    height: screensize.width / 5,
                    child: buildButton(value),
                  ),
                )
                .toList(),
          ),
        ]),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Material(
        color: getButtonColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade600),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          //for button
          onTap: () => onButtonTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),
          ),
        ),
      ),
    );
  }

  void onButtonTap(String value) {
    //delete
    if (value == Button.del) {
      delete();
      return;
    }
    if (value == Button.clear) {
      clearAll();
      return;
    }

    if (value == Button.per) {
      convertToPercentage();
      return;
    }

    if (value == Button.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  void calculate() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

    double num1 = double.parse(number1);
    double num2 = double.parse(number2);

    var result = 0.0;
    switch (operand) {
      case Button.add:
        result = num1 + num2;

        break;
      case Button.subtract:
        result = num1 - num2;
        break;
      case Button.multiply:
        result = num1 * num2;

        break;
      case Button.divide:
        result = num1 / num2;

        break;
      default:
    }
    setState(() {
      number1 = "$result";
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";
    });
  }

  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      //final result=number1 operand number2;
      //number1 =result
      calculate();
    }
    if (operand.isNotEmpty) {
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  void appendValue(String value) {
    if (value != Button.dot && int.tryParse(value) == null) {
      //tap btn not number not . pressed btn not a num
      if (operand.isNotEmpty && number2.isNotEmpty) {
        //operand not empty and num2
        calculate();
      }
      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      //assignvalue for number 1
      //check if num1 is empty or assign new num
      if (value == Button.dot && number1.contains(Button.dot)) return;
      if (value == Button.dot && (number1.isEmpty || number1 == Button.n0)) {
        value = "0."; //number 1 == | 0
      }
      number1 += value;
    } //number1 empty or number1 .
    else if (number2.isEmpty || operand.isNotEmpty) {
      //check if num2 is empty or assign new num or opperand empty
      if (value == Button.dot && number2.contains(Button.dot)) return;
      if (value == Button.dot && (number2.isEmpty || number2 == Button.n0)) {
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }

  Color getButtonColor(value) {
    return [Button.del, Button.clear].contains(value)
        ? Colors.green.shade600
        : [
            Button.per,
            Button.multiply,
            Button.add,
            Button.subtract,
            Button.divide,
            Button.calculate
          ].contains(value)
            ? Colors.yellowAccent.shade400
            : Colors.black87;
  }
}
