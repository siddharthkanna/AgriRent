class Equipment {
  String? id;
  String name;
  String description;
  String category;
  double rentalPrice;
  String location;
  List<String>? images;
  String? ownerId;
  String? renterId;
  bool isAvailable;
  String? condition;
  List<String>? availabilityDates;
  String? features;
  String? deliveryMode;

  Equipment({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.rentalPrice,
    required this.location,
    this.deliveryMode,
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
      id: json['id'], // Assign ID from JSON data
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
      deliveryMode: json['deliveryMode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'deliveryMode': deliveryMode,
    };
  }
}
