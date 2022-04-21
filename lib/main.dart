
import 'package:flutter/material.dart';
import 'package:first/exchange.dart';

void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exchange service',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Exchange service demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ExchangeService exchangeService = ExchangeService();
  final List<String> currency = ['USD', 'EUR', 'BTC', 'UAH'];
  String currencyFrom = '';
  String currencyTo = '';
  double value = 0;
  double result = 0;

  void getActualExchangeRate() {
    setState(() {
      exchangeService = ExchangeService();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Enter value:',
              style: TextStyle(
                  fontSize: 30
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 400),
              child: TextField(
                  onSubmitted: (text) {
                    value = double.parse(text);
                  }
              )
            ),
            Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Choose your currency:',
                    textDirection: TextDirection.ltr),
                DropdownButton<String>(
                  items: currency.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  hint: Text(currencyFrom),
                  onChanged: (String? val) {
                    setState(() {
                      currencyFrom = (val) as String;
                    });
                  },
                )
              ],
            ),
            Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Choose currency for exchange:',
                    textDirection: TextDirection.ltr),
                DropdownButton<String>(
                  items: currency.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  hint: Text(currencyTo),
                  onChanged: (String? val) {
                    setState(() {
                      currencyTo = (val) as String;
                    });
                  },
                )
              ],
            ),
            FlatButton(onPressed: () {
              setState(() {
                result = exchangeService.getExchange(currencyFrom, currencyTo, value);
              });
            }, child: const Text(
              'Get exchange',
              style: TextStyle(
                  fontSize: 17
              ),
            )),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 400),
                child: Text(
                  '$result',
                  style: Theme.of(context).textTheme.headline4,
                ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getActualExchangeRate,
        tooltip: 'Get actual exchange rate',
        child: const Icon(Icons.arrow_circle_down),
      ),
    );
  }

}

