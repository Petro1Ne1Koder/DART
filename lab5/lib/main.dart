import 'package:flutter/material.dart';

void main() => runApp(ReliabilityLossesApp());

class ReliabilityLossesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Надійність та збитки',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Калькулятор надійності та збитків')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Task1Screen())),
              child: Text('Порівняння надійності'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Task2Screen())),
              child: Text('Розрахунок збитків'),
            ),
          ],
        ),
      ),
    );
  }
}

class Task1Screen extends StatefulWidget {
  @override
  _Task1ScreenState createState() => _Task1ScreenState();
}

class _Task1ScreenState extends State<Task1Screen> {
  final _elementsController = TextEditingController();
  final _nController = TextEditingController();
  String result = "";

  void calculateTask1() {
    final n = double.tryParse(_nController.text) ?? 0;
    final elements = _elementsController.text.trim().split(' ');

    final omegaMap = {
      "ПЛ-110": 0.07, "ПЛ-35": 0.02, "ПЛ-10": 0.02, "КЛ-10-канал": 0.005, "КЛ-10-траншея": 0.03,
      "Т-110": 0.015, "Т-35": 0.02, "Т-10-кабель": 0.005, "Т-10-повітря": 0.05
    };
    final tvMap = {
      "ПЛ-110": 10.0, "ПЛ-35": 8.0, "ПЛ-10": 10.0, "КЛ-10-канал": 17.5, "КЛ-10-траншея": 44.0,
      "Т-110": 100.0, "Т-35": 80.0, "Т-10-кабель": 60.0, "Т-10-повітря": 60.0
    };
    final tpMap = {
      "ПЛ-110": 35.0, "ПЛ-35": 35.0, "ПЛ-10": 35.0, "КЛ-10-канал": 9.0, "КЛ-10-траншея": 9.0,
      "Т-110": 43.0, "Т-35": 28.0, "Т-10-кабель": 10.0, "Т-10-повітря": 10.0
    };

    double omegaSum = 0.0, tRecovery = 0.0, maxTp = 0.0;
    for (var el in elements) {
      omegaSum += omegaMap[el] ?? 0;
      tRecovery += (omegaMap[el] ?? 0) * (tvMap[el] ?? 0);
      if ((tpMap[el] ?? 0) > maxTp) maxTp = tpMap[el]!;
    }

    omegaSum += 0.03 * n;
    tRecovery += 0.06 * n;
    tRecovery /= omegaSum;

    final kAP = omegaSum * tRecovery / 8760;
    final kPP = 1.2 * maxTp / 8760;
    final omegaDK = 2 * omegaSum * (kAP + kPP);
    final omegaDKS = omegaDK + 0.02;

    setState(() {
      result = """
Частота відмов: ${omegaSum.toStringAsFixed(5)} рік^-1
Середня тривалість відновлення: ${tRecovery.toStringAsFixed(5)} год
Коеф. аварійного простою: ${kAP.toStringAsFixed(5)}
Коеф. планового простою: ${kPP.toStringAsFixed(5)}
Частота відмов двоколової системи: ${omegaDK.toStringAsFixed(5)} рік^-1
Частота відмов з секційним вимикачем: ${omegaDKS.toStringAsFixed(5)} рік^-1
""";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Порівняння надійності')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _elementsController, decoration: InputDecoration(labelText: 'Елементи (через пробіл)')),
            TextField(controller: _nController, decoration: InputDecoration(labelText: 'n значення'), keyboardType: TextInputType.number),
            ElevatedButton(onPressed: calculateTask1, child: Text('Розрахувати')),
            SizedBox(height: 16),
            Text(result),
          ],
        ),
      ),
    );
  }
}

class Task2Screen extends StatefulWidget {
  @override
  _Task2ScreenState createState() => _Task2ScreenState();
}

class _Task2ScreenState extends State<Task2Screen> {
  final _omega = TextEditingController();
  final _tb = TextEditingController();
  final _Pm = TextEditingController();
  final _Tm = TextEditingController();
  final _kp = TextEditingController();
  final _zPerA = TextEditingController();
  final _zPerP = TextEditingController();
  String result = "";

  void calculateTask2() {
    final omega = double.tryParse(_omega.text) ?? 0;
    final tb = double.tryParse(_tb.text) ?? 0;
    final Pm = double.tryParse(_Pm.text) ?? 0;
    final Tm = double.tryParse(_Tm.text) ?? 0;
    final kp = double.tryParse(_kp.text) ?? 0;
    final zPerA = double.tryParse(_zPerA.text) ?? 0;
    final zPerP = double.tryParse(_zPerP.text) ?? 0;

    final MWA = omega * tb * Pm * Tm;
    final MWP = kp * Pm * Tm;
    final M = zPerA * MWA + zPerP * MWP;

    setState(() {
      result = """
Аварійне недовідпущення: ${MWA.toStringAsFixed(5)} кВт·год
Планове недовідпущення: ${MWP.toStringAsFixed(5)} кВт·год
Збитки: ${M.toStringAsFixed(5)} грн
""";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Розрахунок збитків')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _omega, decoration: InputDecoration(labelText: 'omega')),
              TextField(controller: _tb, decoration: InputDecoration(labelText: 'tb')),
              TextField(controller: _Pm, decoration: InputDecoration(labelText: 'Pm')),
              TextField(controller: _Tm, decoration: InputDecoration(labelText: 'Tm')),
              TextField(controller: _kp, decoration: InputDecoration(labelText: 'kp')),
              TextField(controller: _zPerA, decoration: InputDecoration(labelText: 'zPerA')),
              TextField(controller: _zPerP, decoration: InputDecoration(labelText: 'zPerP')),
              ElevatedButton(onPressed: calculateTask2, child: Text('Розрахувати')),
              SizedBox(height: 16),
              Text(result),
            ],
          ),
        ),
      ),
    );
  }
}

