import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(GaussianCalculatorApp());
}

class GaussianCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gaussian Calculation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GaussianCalculatorScreen(),
    );
  }
}

class GaussianCalculatorScreen extends StatefulWidget {
  @override
  _GaussianCalculatorScreenState createState() => _GaussianCalculatorScreenState();
}

class _GaussianCalculatorScreenState extends State<GaussianCalculatorScreen> {
  final TextEditingController _powerController = TextEditingController();
  final TextEditingController _initialErrorController = TextEditingController();
  final TextEditingController _improvedErrorController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();

  String result = "";

  double calculateGaussian(double x, double mean, double deviation) {
    double coefficient = 1 / (deviation * sqrt(2 * pi));
    double exponent = -pow(x - mean, 2) / (2 * pow(deviation, 2));
    return coefficient * exp(exponent);
  }

  double approximateIntegral(double start, double end, int intervals, double mean, double deviation) {
    double sum = 0.0;
    double stepSize = (end - start) / intervals;
    for (int i = 0; i < intervals; i++) {
      double left = start + i * stepSize;
      double right = start + (i + 1) * stepSize;
      sum += (calculateGaussian(left, mean, deviation) + calculateGaussian(right, mean, deviation)) / 2 * stepSize;
    }
    return sum;
  }

  void performCalculation() {
    double power = double.tryParse(_powerController.text) ?? 0;
    double initialError = double.tryParse(_initialErrorController.text) ?? 0;
    double improvedError = double.tryParse(_improvedErrorController.text) ?? 0;
    double ratePerKWh = double.tryParse(_rateController.text) ?? 0;

    double rangeStart = power - improvedError;
    double rangeEnd = power + improvedError;
    int divisions = 1000;

    double efficiencyBefore = approximateIntegral(rangeStart, rangeEnd, divisions, power, initialError);
    double earningsBefore = power * 24 * efficiencyBefore * ratePerKWh * 1000;
    double penaltiesBefore = power * 24 * (1 - efficiencyBefore) * ratePerKWh * 1000;

    double efficiencyAfter = approximateIntegral(rangeStart, rangeEnd, divisions, power, improvedError);
    double earningsAfter = power * 24 * efficiencyAfter * ratePerKWh * 1000;
    double penaltiesAfter = power * 24 * (1 - efficiencyAfter) * ratePerKWh * 1000;

    setState(() {
      result = """
Прибуток до вдосконалення: ${(earningsBefore / 1000).toStringAsFixed(2)} тис. грн
Виручка до вдосконалення: ${((earningsBefore - penaltiesBefore) / 1000).toStringAsFixed(2)} тис. грн
Штраф до вдосконалення: ${(penaltiesBefore / 1000).toStringAsFixed(2)} тис. грн
Прибуток після вдосконалення: ${(earningsAfter / 1000).toStringAsFixed(2)} тис. грн
Виручка після вдосконалення: ${((earningsAfter - penaltiesAfter) / 1000).toStringAsFixed(2)} тис. грн
Штраф після вдосконалення: ${(penaltiesAfter / 1000).toStringAsFixed(2)} тис. грн
""";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gaussian Calculation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _powerController,
                decoration: InputDecoration(labelText: 'Потужність (кВт)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _initialErrorController,
                decoration: InputDecoration(labelText: 'Початкова похибка'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _improvedErrorController,
                decoration: InputDecoration(labelText: 'Покращена похибка'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _rateController,
                decoration: InputDecoration(labelText: 'Тариф (грн/кВт·год)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: performCalculation,
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
