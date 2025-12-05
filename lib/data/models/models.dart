// part 'models.g.dart'; // For Hive generator later if needed

// Actually, for Hive we need TypeAdapters. I will write them manually or use JSON storage for complex objects if generation is skipped.
// For this task, I will use standard classes and assume Hive stores basic types or we implement TypeAdapters later.
// Let's stick to simple classes first.

class Destination {
  final String id;
  final String name;
  final String country;
  final String description;
  final String imageUrl;
  final double rating;
  final List<String> categories;
  final double latitude;
  final double longitude;
  final List<String> images;
  final Map<String, dynamic> details; // Flexible for extra info

  Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.categories,
    required this.latitude,
    required this.longitude,
    required this.images,
    this.details = const {},
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      categories: List<String>.from(json['categories'] ?? []),
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      details: json['details'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'categories': categories,
      'latitude': latitude,
      'longitude': longitude,
      'images': images,
      'details': details,
    };
  }
}

class Trip {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String? destinationId;
  final String? destinationName;
  final String? destinationImageUrl;
  final List<TripItem> items;
  final double budget;
  final List<Expense> expenses;

  Trip({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.destinationId,
    this.destinationName,
    this.destinationImageUrl,
    this.items = const [],
    this.budget = 0.0,
    this.expenses = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'destinationId': destinationId,
      'destinationName': destinationName,
      'destinationImageUrl': destinationImageUrl,
      'items': items.map((e) => e.toJson()).toList(),
      'budget': budget,
      'expenses': expenses.map((e) => e.toJson()).toList(),
    };
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      destinationId: json['destinationId'] as String?,
      destinationName: json['destinationName'] as String?,
      destinationImageUrl: json['destinationImageUrl'] as String?,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => TripItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
      expenses: (json['expenses'] as List<dynamic>? ?? [])
          .map((e) => Expense.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}

class TripItem {
  final String id;
  final String title;
  final DateTime time;
  final String type; // Flight, Hotel, Activity
  final String? notes;

  TripItem({required this.id, required this.title, required this.time, required this.type, this.notes});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'time': time.toIso8601String(),
      'type': type,
      'notes': notes,
    };
  }

  factory TripItem.fromJson(Map<String, dynamic> json) {
    return TripItem(
      id: json['id'] as String,
      title: json['title'] as String,
      time: DateTime.parse(json['time'] as String),
      type: json['type'] as String,
      notes: json['notes'] as String?,
    );
  }
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  Expense({required this.id, required this.title, required this.amount, required this.category, required this.date});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
}

class Guide {
  final String id;
  final String title;
  final String category;
  final String content;
  final String icon;

  Guide({required this.id, required this.title, required this.category, required this.content, required this.icon});
  
  factory Guide.fromJson(Map<String, dynamic> json) {
    return Guide(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      content: json['content'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class Phrase {
  final String id;
  final String original;
  final String translated;
  final String pronunciation;
  final String category;

  Phrase({required this.id, required this.original, required this.translated, required this.pronunciation, required this.category});

  factory Phrase.fromJson(Map<String, dynamic> json) {
    return Phrase(
      id: json['id'] ?? '',
      original: json['original'] ?? '',
      translated: json['translated'] ?? '',
      pronunciation: json['pronunciation'] ?? '',
      category: json['category'] ?? '',
    );
  }
}
