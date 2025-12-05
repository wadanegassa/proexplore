import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routers/app_router.dart';
import 'core/theme/app_theme.dart';
import 'services/storage_service.dart';
import 'services/data_service.dart';
import 'services/location_service.dart';
import 'services/weather_service.dart';
import 'services/currency_service.dart';
import 'providers/app_provider.dart';
import 'providers/destinations_provider.dart';
import 'providers/trip_provider.dart';
import 'providers/tools_provider.dart';

class ProTravelApp extends StatelessWidget {
  const ProTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => StorageService()),
        Provider(create: (_) => DataService()),
        Provider(create: (_) => LocationService()),
        Provider(create: (_) => WeatherService()),
        Provider(create: (_) => CurrencyService()),
        
        ChangeNotifierProxyProvider<StorageService, AppProvider>(
          create: (context) => AppProvider(context.read<StorageService>()),
          update: (context, storage, previous) => previous ?? AppProvider(storage),
        ),
        ChangeNotifierProxyProvider2<DataService, StorageService, DestinationsProvider>(
          create: (context) => DestinationsProvider(context.read<DataService>(), context.read<StorageService>()),
          update: (context, data, storage, previous) => previous ?? DestinationsProvider(data, storage),
        ),
        ChangeNotifierProxyProvider<StorageService, TripProvider>(
          create: (context) => TripProvider(context.read<StorageService>()),
          update: (context, storage, previous) => previous ?? TripProvider(storage),
        ),
        ChangeNotifierProxyProvider2<CurrencyService, WeatherService, ToolsProvider>(
          create: (context) => ToolsProvider(context.read<CurrencyService>(), context.read<WeatherService>()),
          update: (context, currency, weather, previous) => previous ?? ToolsProvider(currency, weather),
        ),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp.router(
            title: 'ProTravel',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appProvider.themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
