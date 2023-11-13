import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(BMICalculator());
}

class BMICalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BMIHomePage(),
    );
  }
}

class BMIHomePage extends StatefulWidget {
  @override
  _BMIHomePageState createState() => _BMIHomePageState();
}

class _BMIHomePageState extends State<BMIHomePage> {
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  double? bmiResult;
  String? resultText;
  String? selectedGender;

  void calculateBMI() {
    double? weight = double.tryParse(weightController.text);
    String? heightText = heightController.text.replaceAll(',', '.');
    double? height = double.tryParse(heightText);
    if (weight != null && height != null && selectedGender != null) {
      final bmi = weight / (height * height);
      setState(() {
        bmiResult = bmi;
        if (bmi < 18.5) {
          resultText = 'Abaixo do peso';
        } else if (bmi < 25) {
          resultText = 'Peso normal';
        } else if (bmi < 30) {
          resultText = 'Sobrepeso';
        } else {
          resultText = 'Obesidade';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de IMC'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ToggleButtons(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.male),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.female),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  selectedGender = index == 0 ? 'male' : 'female';
                });
              },
              isSelected: [selectedGender == 'male', selectedGender == 'female'],
            ),
            SizedBox(height: 20),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Peso (kg)',
              ),
              enabled: selectedGender != null,
            ),
            SizedBox(height: 20),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Altura (m)',
                hintText: 'Exemplo: 1,75',
              ),
              enabled: selectedGender != null,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+[,]?\d{0,2}')),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedGender != null ? calculateBMI : null,
              child: Text('Calcular IMC'),
            ),
            if (bmiResult != null) ...[
              Text('Seu IMC é: ${bmiResult!.toStringAsFixed(2)}'),
              Text(resultText!),
            ],
          ],
        ),
      ),
    );
  }
}
