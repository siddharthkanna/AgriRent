class Equipment {
  final String name;
  final String description;
  final String category;
  final double rentalPrice;
  final String location;
  List<String>? images;
  final String? ownerId;
  String? renterId; // Nullable field for renterId
  bool isAvailable; // Added isAvailable field
  String? condition; // Nullable field for condition
  List<String>? availabilityDates; // Added availabilityDates field
  String? features; // Nullable field for features

  Equipment({
    required this.name,
    required this.description,
    required this.category,
    required this.rentalPrice,
    required this.location,
    this.images,
    this.ownerId,
    this.renterId,
    this.isAvailable = true,
    this.condition,
    this.availabilityDates,
    this.features,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      name: json['name'],
      description: json['description'],
      category: json['category'],
      rentalPrice: json['rentalPrice'].toDouble(),
      location: json['location'],
      images: List<String>.from(json['images']),
      ownerId: json['ownerId'],
      renterId: json['renterId'],
      isAvailable: json['isAvailable'] ?? true,
      condition: json['condition'],
      availabilityDates: List<String>.from(json['availabilityDates']),
      features: json['features'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'rentalPrice': rentalPrice,
      'location': location,
      'images': images,
      'ownerId': ownerId,
      'renterId': renterId,
      'isAvailable': isAvailable,
      'condition': condition,
      'availabilityDates': availabilityDates,
      'features': features,
    };
  }
}
