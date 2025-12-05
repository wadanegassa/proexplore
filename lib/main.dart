import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Open Boxes
  await Hive.openBox('settings');
  await Hive.openBox('trips');
  await Hive.openBox('favorites');
  
  runApp(const ProTravelApp());
}
