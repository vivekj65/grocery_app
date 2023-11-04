class ShippingAddress {
  String id;
  String name;
  String streetAddress;
  String city;
  String state;
  String postalCode;
  String phoneNo;

  ShippingAddress({
    required this.name,
    required this.id,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.phoneNo,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'streetAddress': streetAddress,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'phoneNo': phoneNo,
    };
  }

  factory ShippingAddress.fromMap(Map<String, dynamic> data) {
    return ShippingAddress(
      name: data['name'],
      id: data['id'],
      streetAddress: data['streetAddress'],
      city: data['city'],
      state: data['state'],
      postalCode: data['postalCode'],
      phoneNo: data['phoneNo'],
    );
  }
}
