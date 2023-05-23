import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(DiceApp());
}

class DiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DicePage(),
    );
  }
}

class DicePage extends StatefulWidget {
  @override
  _DicePageState createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  List<int> diceNumbers = [1]; // Lista para armazenar os números dos dados
  int numberOfDice = 1; // Número de dados atual

  void rollDice() {
    List<int> newDiceNumbers = [];

    for (int i = 0; i < numberOfDice; i++) {
      int newNumber = Random().nextInt(6) + 1;
      newDiceNumbers.add(newNumber);
    }

    setState(() {
      diceNumbers = newDiceNumbers;
    });
  }

  void addDice() {
    setState(() {
      if (numberOfDice < 6) {
        numberOfDice++;
        diceNumbers.add(1);
      }
    });
  }

  void removeDice() {
    setState(() {
      if (diceNumbers.length > 1) {
        diceNumbers.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dice App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < diceNumbers.length; i++)
              Padding(
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/dice${diceNumbers[i]}.png',
                  width: 100,
                  height: 100,
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: rollDice,
              child: Text('Rolar dados'),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addDice,
              child: Text('Adicionar dado'),
            ),
             SizedBox(height: 10),
            ElevatedButton(
              onPressed: removeDice,
              child: Text('Remover Dado'),
            )
          ],

        ),
      ),
    );
  }
}
