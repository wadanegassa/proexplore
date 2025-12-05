import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/models/models.dart';

class DataService {
  Future<List<Destination>> getDestinations() async {
    final String response = await rootBundle.loadString('assets/json/destinations.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Destination.fromJson(json)).toList();
  }

  Future<List<Phrase>> getPhrases() async {
    final String response = await rootBundle.loadString('assets/json/phrases.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Phrase.fromJson(json)).toList();
  }

  Future<List<Guide>> getGuides() async {
    final String response = await rootBundle.loadString('assets/json/guides.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Guide.fromJson(json)).toList();
  }
}
