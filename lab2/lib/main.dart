import 'package:flutter/material.dart';

void main() {
  runApp(EmissionCalculatorApp());
}

class EmissionCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emission Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: EmissionCalculatorScreen(),
    );
  }
}

class EmissionCalculatorScreen extends StatefulWidget {
  @override
  _EmissionCalculatorScreenState createState() => _EmissionCalculatorScreenState();
}

class _EmissionCalculatorScreenState extends State<EmissionCalculatorScreen> {
  final TextEditingController _coalController = TextEditingController();
  final TextEditingController _fuelOilController = TextEditingController();
  final TextEditingController _naturalGasController = TextEditingController();

  String result = "";

  void calculateEmissions() {
    double coalAmount = double.tryParse(_coalController.text) ?? 0;
    double fuelOilAmount = double.tryParse(_fuelOilController.text) ?? 0;
    double gasAmount = double.tryParse(_naturalGasController.text) ?? 0;

    const double emissionFactorCoal = 150.0;
    const double emissionFactorFuelOil = 0.57;
    const double emissionFactorGas = 0.0;

    const double heatValueCoal = 20.47;
    const double heatValueFuelOil = 40.40;
    const double heatValueGas = 33.08;

    double totalCoalEmissions = (emissionFactorCoal * heatValueCoal * coalAmount) / 1000000;
    double totalFuelOilEmissions = (emissionFactorFuelOil * heatValueFuelOil * fuelOilAmount) / 1000000;
    double totalGasEmissions = (emissionFactorGas * heatValueGas * gasAmount) / 1000000;

    double totalEmissions = totalCoalEmissions + totalFuelOilEmissions + totalGasEmissions;

    setState(() {
      result = """
Валові викиди при спалюванні палива:
Вугілля: ${totalCoalEmissions.toStringAsFixed(4)} т
Мазут: ${totalFuelOilEmissions.toStringAsFixed(4)} т
Природний газ: ${totalGasEmissions.toStringAsFixed(4)} т
Загальна кількість викидів: ${totalEmissions.toStringAsFixed(4)} т
""";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emission Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _coalController,
                decoration: InputDecoration(labelText: 'Кількість вугілля (т)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _fuelOilController,
                decoration: InputDecoration(labelText: 'Кількість мазуту (т)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _naturalGasController,
                decoration: InputDecoration(labelText: 'Кількість природного газу (т)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: calculateEmissions,
                child: Text('Розрахувати'),
              ),
              SizedBox(height: 24),
              Text(
                result,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
