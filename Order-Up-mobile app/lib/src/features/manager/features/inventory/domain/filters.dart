class Filters {
  Filters({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.iconUrl,
    required this.filtersId,
  });

  factory Filters.fromJson(Map<String, dynamic> json) => Filters(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        icon: json['icon'] ?? '',
        iconUrl: json['icon_url'] ?? '',
        filtersId: json['id'] ?? '',
      );

  final String? id;
  final String? name;
  final String? description;
  final String? icon;
  final String? iconUrl;
  final String? filtersId;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'description': description,
        'icon': icon,
        'icon_url': iconUrl,
        'id': filtersId,
      };
}
