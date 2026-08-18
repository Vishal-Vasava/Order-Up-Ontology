class NotificationModel {
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['_id'],
        title: json['title'],
        description: json['description'],
        apiUrl: json['apiUrl'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        bannerUrl: json['banner_url'],
        notificationModelId: json['id'],
      );
  NotificationModel({
    this.id,
    this.title,
    this.description,
    this.apiUrl,
    this.createdAt,
    this.updatedAt,
    this.bannerUrl,
    this.notificationModelId,
  });

  final String? id;
  final String? title;
  final String? description;
  final String? apiUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic bannerUrl;
  final String? notificationModelId;
}
