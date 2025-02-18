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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hController = TextEditingController();
  final TextEditingController _cController = TextEditingController();
  final TextEditingController _sController = TextEditingController();
  final TextEditingController _nController = TextEditingController();
  final TextEditingController _oController = TextEditingController();
  final TextEditingController _wController = TextEditingController();
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _vController = TextEditingController();
  final TextEditingController _qDafController = TextEditingController();

  double? dryMass, combustibleMass, qph, qdh, qdafh;
  double? fuelCarbon, fuelHydrogen, fuelSulfur, fuelOxygen, fuelVanadium, qWork;

  int selectedCalculator = 0;

  void calculateTask1() {
    double h = double.tryParse(_hController.text) ?? 0;
    double c = double.tryParse(_cController.text) ?? 0;
    double s = double.tryParse(_sController.text) ?? 0;
    double n = double.tryParse(_nController.text) ?? 0;
    double o = double.tryParse(_oController.text) ?? 0;
    double w = double.tryParse(_wController.text) ?? 0;
    double a = double.tryParse(_aController.text) ?? 0;

    double krs = 100 / (100 - w);
    double krg = 100 / (100 - w - a);

    dryMass = krs;
    combustibleMass = krg;

    qph = (339 * c + 1030 * h - 108.8 * (o - s) - 25 * w) / 1000;
    qdh = qph! * krs;
    qdafh = qph! * krg;

    setState(() {});
  }

  void calculateTask2() {
    double cG = double.tryParse(_cController.text) ?? 0;
    double hG = double.tryParse(_hController.text) ?? 0;
    double sG = double.tryParse(_sController.text) ?? 0;
    double oG = double.tryParse(_oController.text) ?? 0;
    double vG = double.tryParse(_vController.text) ?? 0;
    double wR = double.tryParse(_wController.text) ?? 0;
    double aD = double.tryParse(_aController.text) ?? 0;
    double qDaf = double.tryParse(_qDafController.text) ?? 0;

    fuelCarbon = cG * (100 - wR - aD) / 100;
    fuelHydrogen = hG * (100 - wR - aD) / 100;
    fuelSulfur = sG * (100 - wR - aD) / 100;
    fuelOxygen = oG * (100 - wR - aD) / 100;
    fuelVanadium = vG * (100 - wR) / 100;

    qWork = qDaf * (100 - wR - aD) / 100 - 0.025 * wR;

    setState(() {});
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
            if (selectedCalculator == 0) ...[
              TextFormField(controller: _hController, decoration: InputDecoration(labelText: 'H (%)')),
              TextFormField(controller: _cController, decoration: InputDecoration(labelText: 'C (%)')),
              TextFormField(controller: _sController, decoration: InputDecoration(labelText: 'S (%)')),
              TextFormField(controller: _nController, decoration: InputDecoration(labelText: 'N (%)')),
              TextFormField(controller: _oController, decoration: InputDecoration(labelText: 'O (%)')),
              TextFormField(controller: _wController, decoration: InputDecoration(labelText: 'W (%)')),
              TextFormField(controller: _aController, decoration: InputDecoration(labelText: 'A (%)')),
              ElevatedButton(onPressed: calculateTask1, child: Text('Calculate')),
            ] else ...[
              TextFormField(controller: _cController, decoration: InputDecoration(labelText: 'C (%)')),
              TextFormField(controller: _hController, decoration: InputDecoration(labelText: 'H (%)')),
              TextFormField(controller: _sController, decoration: InputDecoration(labelText: 'S (%)')),
              TextFormField(controller: _oController, decoration: InputDecoration(labelText: 'O (%)')),
              TextFormField(controller: _vController, decoration: InputDecoration(labelText: 'V (mg/kg)')),
              TextFormField(controller: _wController, decoration: InputDecoration(labelText: 'W (%)')),
              TextFormField(controller: _aController, decoration: InputDecoration(labelText: 'A (%)')),
              TextFormField(controller: _qDafController, decoration: InputDecoration(labelText: 'Qdaf (MJ/kg)')),
              ElevatedButton(onPressed: calculateTask2, child: Text('Calculate')),
            ],
          ],
        ),
      ),
    );
  }
}
