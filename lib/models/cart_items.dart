class CartItem {
  String cartItemId;
  String productName;
  String imgurl;
  int quantity;
  int price;

  CartItem({
    required this.imgurl,
    required this.cartItemId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'imgurl': imgurl,
      'cartItemId': cartItemId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      imgurl: map['imgurl'] ?? '',
      cartItemId: map['cartItemId'] ?? '',
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: map['price'] ?? 0,
    );
  }
}
