import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String name;
  int price;
  String description;
  String imgurl;
  int discount;
  String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imgurl,
    required this.discount,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['title'] ?? '',
      price: json['price'],
      description: json['description'] ?? '',
      imgurl: json['imgurl'] ?? '',
      discount: json['discount'],
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': name,
      'price': price,
      'description': description,
      'imgurl': imgurl,
      'discount': discount,
      'category': category,
    };
  }

  factory Product.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product.fromJson(data);
  }
}
