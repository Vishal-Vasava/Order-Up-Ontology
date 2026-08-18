class Review {
  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['_id'],
        customer: Customer.fromJson(json['_customer']),
        rating: json['rating'],
        review: json['review'],
      );

  Review({
    this.id,
    this.customer,
    this.rating,
    this.review,
  });
  final String? id;
  final Customer? customer;
  final int? rating;
  final String? review;
}

class Customer {
  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        imageUrl: json['image_url'],
        customerId: json['id'],
      );

  Customer({
    this.id,
    this.firstName,
    this.lastName,
    this.imageUrl,
    this.customerId,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? imageUrl;
  final String? customerId;
}
