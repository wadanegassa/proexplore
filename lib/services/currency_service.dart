class CurrencyService {
  final Map<String, double> _rates = {
    'ETB': 1.0,      // Ethiopian Birr (base)
    'USD': 0.00653,  // 1 ETB = ~0.00653 USD (1 USD = 153 ETB)
    'EUR': 0.0062,   // 1 ETB = ~0.0062 EUR  
    'GBP': 0.0052,   // 1 ETB = ~0.0052 GBP
    'KES': 0.85,     // 1 ETB = ~0.85 KES (Kenyan Shilling)
    'TZS': 18.0,     // 1 ETB = ~18 TZS (Tanzanian Shilling)
  };

  final Map<String, String> _symbols = {
    'ETB': 'ብር',
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'KES': 'KSh',
    'TZS': 'TSh',
  };

  double convert(double amount, String from, String to) {
    double fromRate = _rates[from] ?? 1.0;
    double toRate = _rates[to] ?? 1.0;
    return (amount / fromRate) * toRate;
  }

  String getSymbol(String currency) {
    return _symbols[currency] ?? currency;
  }

  List<String> get availableCurrencies => _rates.keys.toList();
}
