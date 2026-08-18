class Banners {
  Banners({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.imageUrl,
    required this.bannersId,
  });

  factory Banners.fromJson(Map<String, dynamic> json) => Banners(
        id: json['_id'],
        title: json['title'],
        description: json['description'],
        image: json['image'],
        imageUrl: json['image_url'],
        bannersId: json['id'],
      );
  final String id;
  final String title;
  final String description;
  final String image;
  final String imageUrl;
  final String bannersId;
}
