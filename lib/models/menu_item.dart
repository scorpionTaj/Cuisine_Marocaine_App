class MenuItem {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;
  final String category;
  int likes;
  int dislikes;
  List<String> comments;
  bool isFavorite;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.category,
    this.likes = 0,
    this.dislikes = 0,
    List<String>? comments,
    this.isFavorite = false,
  }) : comments = comments ?? [];

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'category': category,
      'likes': likes,
      'dislikes': dislikes,
      'comments': comments,
      'isFavorite': isFavorite,
    };
  }

  // Create from JSON
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: json['price'].toDouble(),
      category: json['category'],
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
      comments: List<String>.from(json['comments'] ?? []),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Create a copy with modified properties
  MenuItem copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    double? price,
    String? category,
    int? likes,
    int? dislikes,
    List<String>? comments,
    bool? isFavorite,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      category: category ?? this.category,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      comments: comments ?? this.comments,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
