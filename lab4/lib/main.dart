import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(ShortCircuitApp());
}

class ShortCircuitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Short Circuit Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Short Circuit Calculator')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SinglePhaseScreen()),
              ),
              child: Text('Однофазне КЗ'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThreePhaseScreen()),
              ),
              child: Text('Трифазне КЗ'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StabilityScreen()),
              ),
              child: Text('Термічна стійкість'),
            ),
          ],
        ),
      ),
    );
  }
}

class SinglePhaseScreen extends StatefulWidget {
  @override
  _SinglePhaseScreenState createState() => _SinglePhaseScreenState();
}

class _SinglePhaseScreenState extends State<SinglePhaseScreen> {
  final TextEditingController _voltageController = TextEditingController();
  final TextEditingController _impedanceController = TextEditingController();
  String result = "";

  void calculateSinglePhase() {
    double voltage = double.tryParse(_voltageController.text) ?? 0;
    double impedance = double.tryParse(_impedanceController.text) ?? 0;
    if (impedance != 0) {
      double current = voltage / impedance;
      setState(() => result = "Струм однофазного КЗ: ${current.toStringAsFixed(2)} A");
    } else {
      setState(() => result = "Помилка: Імпеданс не може бути нулем.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Однофазне КЗ')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _voltageController,
              decoration: InputDecoration(labelText: 'Напруга (В)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _impedanceController,
              decoration: InputDecoration(labelText: 'Імпеданс (Ом)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calculateSinglePhase,
              child: Text('Розрахувати'),
            ),
            SizedBox(height: 16),
            Text(result, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class ThreePhaseScreen extends StatefulWidget {
  @override
  _ThreePhaseScreenState createState() => _ThreePhaseScreenState();
}

class _ThreePhaseScreenState extends State<ThreePhaseScreen> {
  final TextEditingController _voltageController = TextEditingController();
  final TextEditingController _impedanceController = TextEditingController();
  String result = "";

  void calculateThreePhase() {
    double voltage = double.tryParse(_voltageController.text) ?? 0;
    double impedance = double.tryParse(_impedanceController.text) ?? 0;
    if (impedance != 0) {
      double current = voltage / (impedance * sqrt(3));
      setState(() => result = "Струм трифазного КЗ: ${current.toStringAsFixed(2)} A");
    } else {
      setState(() => result = "Помилка: Імпеданс не може бути нулем.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Трифазне КЗ')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _voltageController,
              decoration: InputDecoration(labelText: 'Напруга (В)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _impedanceController,
              decoration: InputDecoration(labelText: 'Імпеданс (Ом)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calculateThreePhase,
              child: Text('Розрахувати'),
            ),
            SizedBox(height: 16),
            Text(result, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class StabilityScreen extends StatefulWidget {
  @override
  _StabilityScreenState createState() => _StabilityScreenState();
}

class _StabilityScreenState extends State<StabilityScreen> {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  String result = "";

  void calculateStability() {
    double current = double.tryParse(_currentController.text) ?? 0;
    double duration = double.tryParse(_durationController.text) ?? 0;
    double stability = current * current * duration;
    setState(() => result = "Термічна стійкість: ${stability.toStringAsFixed(2)} A²·с");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Термічна стійкість')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _currentController,
              decoration: InputDecoration(labelText: 'Струм (A)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(labelText: 'Тривалість (с)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calculateStability,
              child: Text('Розрахувати'),
            ),
            SizedBox(height: 16),
            Text(result, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
