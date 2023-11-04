class Carousal {
  final String id;
  final String imgurl;
  final String redirectUrl;
  final String title;
  final String description;

  Carousal({
    required this.id,
    required this.imgurl,
    required this.redirectUrl,
    required this.title,
    required this.description,
  });

  factory Carousal.fromJson(Map<String, dynamic> json) {
    return Carousal(
      id: json['id'] ?? '',
      imgurl: json['imgurl'] ?? '',
      redirectUrl: json['redirecturl'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imgurl': imgurl,
      'redirectUrl': redirectUrl,
      'title': title,
      'description': description,
    };
  }
}
