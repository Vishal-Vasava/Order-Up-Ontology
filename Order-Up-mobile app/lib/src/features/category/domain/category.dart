class Category {
  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['store_id'],
        name: json['name'],
        banner: json['banner'],
        icon: json['icon'],
        bannerUrl: json['banner_url'],
        iconUrl: json['icon_url'],
        distance: json['distance']?.toDouble(),
      );
  Category({
    this.id,
    this.name,
    this.banner,
    this.icon,
    this.bannerUrl,
    this.iconUrl,
    this.distance,
  });

  final String? id;
  final String? name;
  final String? banner;
  final String? icon;
  final String? bannerUrl;
  final String? iconUrl;
  final double? distance;
}
