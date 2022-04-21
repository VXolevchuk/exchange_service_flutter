import 'dart:convert';
import 'dart:html';

class ExchangeService {
  static Map<String, Map<String, double>> _exchanges = {};

  static Future<Map> _getJSon() async {
      var data = await HttpRequest.getString('https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5');
      var json = jsonDecode(data);
      Map<String, double> map = {};
      for (var v in json) {
        map[v['ccy']] = double.parse(v['buy']);
      }
      return map;
 }

  static Future<void> initExchangeMap() async {
    var map = await _getJSon();

    Map<String, double> mapUSD = {};
    mapUSD['UAH'] = 1/map['USD'];
    mapUSD['EUR'] = map['EUR']/map['USD'];
    mapUSD['BTC'] = map['BTC'];
    _exchanges['USD'] = mapUSD;

    Map<String, double> mapEUR = {};
    mapEUR['UAH'] = 1/map['EUR'];
    mapEUR['USD'] = map['USD']/map['EUR'];
    mapEUR['BTC'] = map['BTC']*mapEUR['USD'];
    _exchanges['EUR'] = mapEUR;

    Map<String, double> mapBTC = {};
    mapBTC['UAH'] = 1/(map['BTC']*map['USD']);
    mapBTC['USD'] = 1/map['BTC'];
    mapBTC['EUR'] = 1/(_exchanges['EUR']!['BTC']!);
    _exchanges['BTC'] = mapBTC;

    _exchanges['UAH'] = map as Map<String, double>;
    _exchanges['UAH']!['BTC'] = map['BTC']!*map['USD']!;
  }

  static double getExchange(String currencyFrom, String currencyTo, double value) {
    if(currencyFrom == currencyTo) {
      return value;
    }
    double rate = _exchanges[currencyTo]![currencyFrom]!;
    return value*rate;
  }

}