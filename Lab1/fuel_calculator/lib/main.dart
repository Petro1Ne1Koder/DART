import 'package:flutter/material.dart';

void main() {
  runApp(FuelCalculatorApp());
}

class FuelCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FuelCalculatorScreen(),
    );
  }
}

class FuelCalculatorScreen extends StatefulWidget {
  @override
  _FuelCalculatorScreenState createState() => _FuelCalculatorScreenState();
}

class _FuelCalculatorScreenState extends State<FuelCalculatorScreen> {
  final Map<String, TextEditingController> controllers = {
    'H': TextEditingController(),
    'C': TextEditingController(),
    'S': TextEditingController(),
    'N': TextEditingController(),
    'O': TextEditingController(),
    'W': TextEditingController(),
    'A': TextEditingController(),
    'V': TextEditingController(),
    'Qdaf': TextEditingController(),
  };

  double? dryMass, combustibleMass, qph, qdh, qdafh, qWork;
  int selectedCalculator = 0;

  void calculateTask1() {
    setState(() {
      double h = double.tryParse(controllers['H']!.text) ?? 0;
      double c = double.tryParse(controllers['C']!.text) ?? 0;
      double s = double.tryParse(controllers['S']!.text) ?? 0;
      double n = double.tryParse(controllers['N']!.text) ?? 0;
      double o = double.tryParse(controllers['O']!.text) ?? 0;
      double w = double.tryParse(controllers['W']!.text) ?? 0;
      double a = double.tryParse(controllers['A']!.text) ?? 0;

      double krs = 100 / (100 - w);
      double krg = 100 / (100 - w - a);

      dryMass = krs;
      combustibleMass = krg;

      qph = (339 * c + 1030 * h - 108.8 * (o - s) - 25 * w) / 1000;
      qdh = qph! * krs;
      qdafh = qph! * krg;
    });
  }

  void calculateTask2() {
    setState(() {
      double c = double.tryParse(controllers['C']!.text) ?? 0;
      double h = double.tryParse(controllers['H']!.text) ?? 0;
      double s = double.tryParse(controllers['S']!.text) ?? 0;
      double o = double.tryParse(controllers['O']!.text) ?? 0;
      double v = double.tryParse(controllers['V']!.text) ?? 0;
      double w = double.tryParse(controllers['W']!.text) ?? 0;
      double a = double.tryParse(controllers['A']!.text) ?? 0;
      double qDaf = double.tryParse(controllers['Qdaf']!.text) ?? 0;

      qWork = qDaf * (100 - w - a) / 100 - 0.025 * w;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fuel Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleButtons(
              children: [Text('Task 1'), Text('Task 2')],
              isSelected: [selectedCalculator == 0, selectedCalculator == 1],
              onPressed: (index) {
                setState(() {
                  selectedCalculator = index;
                });
              },
            ),
            SizedBox(height: 16),
            ...(selectedCalculator == 0
                ? ['H', 'C', 'S', 'N', 'O', 'W', 'A']
                : ['C', 'H', 'S', 'O', 'V', 'W', 'A', 'Qdaf'])
                .map((key) => TextFormField(
                      controller: controllers[key],
                      decoration: InputDecoration(labelText: '$key (%)'),
                    ))
                .toList(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: selectedCalculator == 0 ? calculateTask1 : calculateTask2,
              child: Text('Calculate'),
            ),
            SizedBox(height: 16),
            if (selectedCalculator == 0) ...[
              Text('Dry Mass Factor: ${dryMass?.toStringAsFixed(2) ?? 'N/A'}'),
              Text('Combustible Mass Factor: ${combustibleMass?.toStringAsFixed(2) ?? 'N/A'}'),
              Text('QpH: ${qph?.toStringAsFixed(2) ?? 'N/A'} MJ/kg'),
              Text('QdH: ${qdh?.toStringAsFixed(2) ?? 'N/A'} MJ/kg'),
              Text('QdafH: ${qdafh?.toStringAsFixed(2) ?? 'N/A'} MJ/kg'),
            ] else ...[
              Text('Q Work: ${qW ork?.toStringAsFixed(2) ?? 'N/A'} MJ/kg'),
            ],
          ],
        ),
      ),
    );
  }
}
