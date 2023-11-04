class WishlistItem {
  final String userId;
  final String productId;
  final String id;
  final String imgurl;
  final String name;
  final int price;

  WishlistItem({
    required this.price,
    required this.name,
    required this.userId,
    required this.imgurl,
    required this.productId,
    required this.id,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      name: json['name'],
      userId: json['userId'] ?? '',
      productId: json['productId'] ?? '',
      id: json['id'] ?? '',
      imgurl: json['imgurl'],
      price: json['price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'userId': userId,
      'productId': productId,
      'id': id,
      'imgurl': imgurl,
      'price': price,
    };
  }
}
