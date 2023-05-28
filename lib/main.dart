import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: DiceApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class DiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Dice App',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? selectedNumberOfSides;
  final List<int> numberOfSidesOptions = [6, 8, 10];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dice App'),
        actions: [
          IconButton(
            icon: Icon(Icons.lightbulb),
            onPressed: () {
              final themeProvider =
                  Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          for (int numberOfSides in numberOfSidesOptions)
            RadioListTile(
              title: Text('$numberOfSides Lados'),
              value: numberOfSides,
              groupValue: selectedNumberOfSides,
              onChanged: (int? value) {
                setState(() {
                  selectedNumberOfSides = value;
                });
              },
            ),
          ElevatedButton(
            onPressed: () {
              if (selectedNumberOfSides != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DicePage(
                      numberOfSides: selectedNumberOfSides!,
                    ),
                  ),
                );
              }
            },
            child: Text('Jogar Dados'),
          ),
        ],
      ),
    );
  }
}

class DicePage extends StatefulWidget {
  final int numberOfSides;
  final int numberOfDice;

  DicePage({required this.numberOfSides, this.numberOfDice = 1});

  @override
  _DicePageState createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  List<int> diceNumbers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.numberOfDice; i++) {
      diceNumbers.add(_generateRandomNumber());
    }
  }

  void rollDice() {
    setState(() {
      for (int i = 0; i < diceNumbers.length; i++) {
        diceNumbers[i] = _generateRandomNumber();
      }
    });
  }

  int _generateRandomNumber() {
    return Random().nextInt(widget.numberOfSides) + 1;
  }

  Widget buildDiceWidget(int number, ThemeData theme) {
    final textColor = theme.textTheme.bodyText1?.color;

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: theme.cardColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.primaryColor, width: 2.0),
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

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
                child: buildDiceWidget(diceNumbers[i], theme),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: rollDice,
              child: Text('Rolar Dados'),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                if (diceNumbers.length < 6) {
                  diceNumbers.add(_generateRandomNumber());
                }
              });
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                if (diceNumbers.length > 1) {
                  diceNumbers.removeLast();
                }
              });
            },
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
