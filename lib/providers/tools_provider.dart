import 'package:flutter/material.dart';
import '../services/currency_service.dart';
import '../services/weather_service.dart';

class ToolsProvider extends ChangeNotifier {
  final CurrencyService _currencyService;
  final WeatherService _weatherService;

  ToolsProvider(this._currencyService, this._weatherService);

  // Currency State
  double _convertedAmount = 0.0;
  double get convertedAmount => _convertedAmount;

  void convertCurrency(double amount, String from, String to) {
    _convertedAmount = _currencyService.convert(amount, from, to);
    notifyListeners();
  }

  // Weather State
  Map<String, dynamic>? _weatherData;
  Map<String, dynamic>? get weatherData => _weatherData;

  Future<void> fetchWeather(String city) async {
    _weatherData = await _weatherService.getWeather(city);
    notifyListeners();
  }
}
