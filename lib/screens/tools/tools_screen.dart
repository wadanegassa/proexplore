import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/tools_provider.dart';
import '../../widgets/common/smart_image.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController(text: '100');
  String _fromCurrency = 'USD';
  String _toCurrency = 'ETB';
  String _selectedCity = 'Addis Ababa';
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // Initial conversion and weather fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _convert();
      context.read<ToolsProvider>().fetchWeather(_selectedCity);
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _convert() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    context.read<ToolsProvider>().convertCurrency(amount, _fromCurrency, _toCurrency);
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
    _animController.forward().then((_) => _animController.reverse());
    _convert();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ToolsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
              title: Text(
                'Travel Tools',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 2),
                      blurRadius: 8.0,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  SmartImage(
                    imageUrl: 'assets/images/onboarding1.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // Currency Converter
                  _buildModernCard(
                    context,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF009639), Color(0xFF00C853)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: Icons.currency_exchange_rounded,
                    title: 'Currency Converter',
                    child: Column(
                      children: [
                        // Amount input
                        Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              labelText: 'Enter Amount',
                              labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              prefixIcon: const Icon(Icons.attach_money, color: Color(0xFF009639)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: theme.cardColor,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            onChanged: (val) => _convert(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Currency selectors
                        Row(
                          children: [
                            Expanded(
                              child: _buildCurrencySelector(
                                context,
                                value: _fromCurrency,
                                label: 'From',
                                onChanged: (val) {
                                  setState(() => _fromCurrency = val!);
                                  _convert();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: RotationTransition(
                                turns: _animController,
                                child: IconButton(
                                  onPressed: _swapCurrencies,
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF009639),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF009639).withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.swap_horiz, color: Colors.white, size: 24),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: _buildCurrencySelector(
                                context,
                                value: _toCurrency,
                                label: 'To',
                                onChanged: (val) {
                                  setState(() => _toCurrency = val!);
                                  _convert();
                                },
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Result display
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFEDB00), Color(0xFFFFE84D)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFEDB00).withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.trending_up, color: Colors.black87, size: 20),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Converted Amount',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${provider.convertedAmount.toStringAsFixed(2)} $_toCurrency',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '1 $_fromCurrency = ${(1 / (double.tryParse(_amountController.text) ?? 1) * provider.convertedAmount).toStringAsFixed(2)} $_toCurrency',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  
                  const SizedBox(height: 16),
                  
                  // Weather Card
                  _buildModernCard(
                    context,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0288D1), Color(0xFF29B6F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: Icons.wb_sunny_rounded,
                    title: 'Weather Forecast',
                    subtitle: 'Select a destination',
                    child: Column(
                      children: [
                        // City selector
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFF0288D1).withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: DropdownButton<String>(
                                  value: _selectedCity,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF0288D1)),
                                  dropdownColor: theme.cardColor,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: theme.textTheme.bodyLarge?.color,
                                  ),
                                  items: [
                                    'Addis Ababa',
                                    'Lalibela',
                                    'Gondar',
                                    'Bahir Dar',
                                    'Axum',
                                    'Harar',
                                    'Jimma',
                                    'Dire Dawa',
                                    'Mekele',
                                  ].map((city) => DropdownMenuItem(
                                        value: city,
                                        child: Row(
                                          children: [
                                            const Icon(Icons.location_city, size: 18, color: Color(0xFF0288D1)),
                                            const SizedBox(width: 8),
                                            Text(city),
                                          ],
                                        ),
                                      )).toList(),
                                  onChanged: (city) {
                                    if (city != null) {
                                      setState(() => _selectedCity = city);
                                      context.read<ToolsProvider>().fetchWeather(city);
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () => context.read<ToolsProvider>().fetchWeather(_selectedCity),
                                icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0288D1)),
                                tooltip: 'Refresh weather',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        provider.weatherData != null
                            ? _buildWeatherContent(context, provider.weatherData!)
                            : _buildLoadingWeather(context),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Quick Links
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickTool(
                          context,
                          icon: Icons.translate_rounded,
                          title: 'Phrasebook',
                          subtitle: 'Learn Amharic',
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9C27B0), Color(0xFFBA68C8)],
                          ),
                          onTap: () => context.push('/phrasebook'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickTool(
                          context,
                          icon: Icons.book_rounded,
                          title: 'Guides',
                          subtitle: 'Travel tips',
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF5722), Color(0xFFFF7043)],
                          ),
                          onTap: () => context.push('/guides'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencySelector(
    BuildContext context, {
    required String value,
    required String label,
    required void Function(String?) onChanged,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF009639).withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: theme.cardColor,
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF009639)),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: theme.textTheme.bodyLarge?.color,
            ),
            items: ['ETB', 'USD', 'EUR', 'GBP', 'KES', 'TZS']
                .map((currency) => DropdownMenuItem(
                      value: currency,
                      child: Text(currency),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherContent(BuildContext context, Map<String, dynamic> weather) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherStat(
                Icons.thermostat_rounded,
                '${weather['temp']}°C',
                'Temperature',
                const Color(0xFFFFB74D),
              ),
              _buildWeatherStat(
                Icons.water_drop_rounded,
                '${weather['humidity']}%',
                'Humidity',
                const Color(0xFF64B5F6),
              ),
              _buildWeatherStat(
                Icons.air_rounded,
                '${weather['wind']} km/h',
                'Wind',
                const Color(0xFF81C784),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.refresh_rounded, size: 14, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  'Updated just now',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWeather(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildWeatherStat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildModernCard(
    BuildContext context, {
    required LinearGradient gradient,
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: gradient),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.all(20),
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTool(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
