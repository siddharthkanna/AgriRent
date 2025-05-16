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
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      rentalPrice: (json['rental_price'] ?? json['rentalPrice']).toDouble(),
      location: json['location'],
      images: json['images'] != null 
          ? (json['images'] is List 
              ? List<String>.from(json['images'])
              : json['images'].toString().split(','))
          : null,
      ownerId: json['owner_id'] ?? json['ownerId'],
      renterId: json['renter_id'] ?? json['renterId'],
      isAvailable: json['is_available'] ?? json['isAvailable'] ?? true,
      condition: json['condition'],
      availabilityDates: json['availability_dates'] != null
          ? List<String>.from(json['availability_dates'])
          : null,
      features: json['features'],
      deliveryMode: json['delivery_mode'] ?? json['deliveryMode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'rental_price': rentalPrice,
      'location': location,
      'images': images,
      'owner_id': ownerId,
      'renter_id': renterId,
      'is_available': isAvailable,
      'condition': condition,
      'availability_dates': availabilityDates,
      'features': features,
      'delivery_mode': deliveryMode,
    };
  }

  Equipment copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? rentalPrice,
    String? location,
    String? condition,
    String? features,
    String? deliveryMode,
    List<String>? images,
    bool? isAvailable,
    String? ownerId,
    String? renterId,
    List<String>? availabilityDates,
  }) {
    return Equipment(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      rentalPrice: rentalPrice ?? this.rentalPrice,
      location: location ?? this.location,
      condition: condition ?? this.condition,
      features: features ?? this.features,
      deliveryMode: deliveryMode ?? this.deliveryMode,
      images: images ?? this.images,
      isAvailable: isAvailable ?? this.isAvailable,
      ownerId: ownerId ?? this.ownerId,
      renterId: renterId ?? this.renterId,
      availabilityDates: availabilityDates ?? this.availabilityDates,
    );
  }
}
