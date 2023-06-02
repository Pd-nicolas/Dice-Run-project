import 'dart:math';  // Importação da biblioteca 'dart:math' para usar a classe Random
import 'package:flutter/material.dart';  // Importação do pacote flutter/material.dart, que contém widgets do Material Design
import 'package:provider/provider.dart';  // Importação do pacote provider, que fornece gerenciamento de estado

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),  // Criação do provider para gerenciar o tema do aplicativo
      child: DiceApp(),  // Execução do aplicativo principal
    ),
  );
}

// Classe ThemeProvider que estende ChangeNotifier para gerenciar o tema do aplicativo
class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;  // Variável privada para armazenar o estado do tema

  bool get isDarkMode => _isDarkMode;  // Getter para acessar o estado do tema

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;  // Inverte o estado do tema
    notifyListeners();  // Notifica os ouvintes sobre a mudança no estado do tema
  }
}

// Classe DiceApp que estende StatelessWidget e representa o aplicativo principal
class DiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);  // Obtém a instância de ThemeProvider do contexto
    return MaterialApp(
      title: 'Dice App',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),  // Define o tema do aplicativo com base no estado do tema
      home: HomePage(),  // Define a página inicial do aplicativo
    );
  }
}

// Classe HomePage que estende StatefulWidget e representa a página inicial do aplicativo
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? selectedNumberOfSides;  // Número de lados selecionado
  final List<int> numberOfSidesOptions = [4,6,8,10,12,20,100];  // Lista de opções de número de lados

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Virtual Dice'),
        actions: [
          IconButton(
            icon: Icon(Icons.lightbulb),
            onPressed: () {
              final themeProvider =
                  Provider.of<ThemeProvider>(context, listen: false);  // Obtém a instância de ThemeProvider do contexto
              themeProvider.toggleTheme();  // Altera o tema ao clicar no botão
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
                  selectedNumberOfSides = value;  // Atualiza o número de lados selecionado
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
                      numberOfSides: selectedNumberOfSides!,  // Passa o número de lados selecionado para a próxima página
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

// Classe DicePage que estende StatefulWidget e representa a página de jogar dados
class DicePage extends StatefulWidget {
  final int numberOfSides;  // Número de lados do dado
  final int numberOfDice;  // Número de dados a serem exibidos

  DicePage({required this.numberOfSides, this.numberOfDice = 1});  // Construtor da classe

  @override
  _DicePageState createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  List<int> diceNumbers = [];  // Lista de números dos dados

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.numberOfDice; i++) {
      diceNumbers.add(_generateRandomNumber());  // Gera números aleatórios para os dados e os adiciona à lista
    }
  }

  void rollDice() {
    setState(() {
      for (int i = 0; i < diceNumbers.length; i++) {
        diceNumbers[i] = _generateRandomNumber();  // Gera novos números aleatórios para os dados
      }
    });
  }

  int _generateRandomNumber() {
    return Random().nextInt(widget.numberOfSides) + 1;  // Gera um número aleatório com base no número de lados
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
    final themeProvider = Provider.of<ThemeProvider>(context);  // Obtém a instância de ThemeProvider do contexto
    final theme = Theme.of(context);  // Obtém o tema atual do contexto

    return Scaffold(
      appBar: AppBar(
        title: Text('Virtual Dice'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < diceNumbers.length; i++)
              Padding(
                padding: EdgeInsets.all(10),
                child: buildDiceWidget(diceNumbers[i], theme),  // Exibe os dados na tela
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
                  diceNumbers.add(_generateRandomNumber());  // Adiciona mais um dado à lista
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
                  diceNumbers.removeLast();  // Remove o último dado da lista
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
