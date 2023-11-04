class GroceryUser {
  final String id;
  final String name;
  final String email;

  GroceryUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory GroceryUser.fromJson(Map<String, dynamic> json) {
    return GroceryUser(
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'id': id,
    };
  }
}
