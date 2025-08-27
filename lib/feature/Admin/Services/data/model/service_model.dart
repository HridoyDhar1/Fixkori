class Service {
  final String id;
  final String post;
  final String? imageUrl;
  final double price;
  final String? location;
  final String? adminId;

  Service({
    required this.id,
    required this.post,
    this.imageUrl,
    required this.price,
    this.location,
    this.adminId,
  });

  factory Service.fromMap(Map<String, dynamic> map, String documentId) {
    return Service(
      id: documentId,
      post: map['post'] ?? '',
      imageUrl: map['imageUrl'],
      price: (map['price'] ?? 0).toDouble(),
      location: map['location'],
      adminId: map['adminId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'post': post,
      'imageUrl': imageUrl,
      'price': price,
      'location': location,
      'adminId': adminId,
    };
  }
}
