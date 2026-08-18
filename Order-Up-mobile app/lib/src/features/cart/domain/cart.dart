class Cart {
  Cart({
    required this.cart,
    required this.charges,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        cart: List<CartElement>.from(
            json['cart'].map((x) => CartElement.fromJson(x))),
        charges:
            List<Charge>.from(json['charges'].map((x) => Charge.fromJson(x))),
      );
  final List<CartElement> cart;
  final List<Charge> charges;

  Map<String, dynamic> toJson() => {
        'cart': List<dynamic>.from(cart.map((x) => x.toJson())),
        'charges': List<dynamic>.from(charges.map((x) => x.toJson())),
      };
}

class CartElement {
  CartElement({
    required this.producer,
    required this.items,
    required this.slots,
  });

  factory CartElement.fromJson(Map<String, dynamic> json) => CartElement(
        producer: CartProducer.fromJson(json['producer']),
        items:
            List<CartItem>.from(json['items'].map((x) => CartItem.fromJson(x))),
        slots: List<Slot>.from(json['slots'].map((x) => Slot.fromJson(x))),
      );
  final CartProducer producer;
  final List<CartItem> items;
  final List<Slot> slots;

  Map<String, dynamic> toJson() => {
        'producer': producer.toJson(),
        'items': List<dynamic>.from(items.map((x) => x.toJson())),
        'slots': List<dynamic>.from(slots.map((x) => x.toJson())),
      };
}

class CartItem {
  CartItem({
    required this.product,
    required this.qty,
    required this.id,
    required this.isAvailable,
    required this.cartItemPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        product: Product.fromJson(json['product']),
        qty: json['qty'],
        id: json['_id'],
        isAvailable: json['isAvailable'],
        cartItemPrice: json['cart_item_price'],
      );
  final Product product;
  final int qty;
  final String id;
  final bool isAvailable;
  final int cartItemPrice;

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'qty': qty,
        '_id': id,
        'isAvailable': isAvailable,
        'cart_item_price': cartItemPrice,
      };
}

class Product {
  Product({
    required this.filters,
    required this.images,
    required this.id,
    required this.name,
    required this.desc,
    required this.image,
    required this.price,
    required this.qty,
    required this.visible,
    required this.deleted,
    required this.currency,
    required this.producer,
    required this.creator,
    required this.returnPolicy,
    required this.estimatedPickup,
    required this.createdAt,
    required this.updatedAt,
    required this.imageUrl,
    required this.imagesUrl,
    required this.unit,
    required this.productId,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        filters:
            List<Filter>.from(json['_filters'].map((x) => Filter.fromJson(x))),
        images: List<dynamic>.from(json['images'].map((x) => x)),
        id: json['_id'],
        name: json['name'],
        desc: json['desc'],
        image: json['image'],
        price: json['price'],
        qty: json['qty'],
        visible: json['visible'],
        deleted: json['deleted'],
        currency: Currency.fromJson(json['_currency']),
        producer: CartProducer.fromJson(json['_producer']),
        creator: json['_creator'],
        returnPolicy: json['_returnPolicy'] == null
            ? null
            : ReturnPolicy.fromJson(json['_returnPolicy']),
        estimatedPickup: json['_estimatedPickup'] == null
            ? null
            : EstimatedPickup.fromJson(json['_estimatedPickup']),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        imageUrl: json['image_url'],
        imagesUrl: List<ImagesUrl>.from(
            json['images_url'].map((x) => ImagesUrl.fromJson(x))),
        unit: json['unit'],
        productId: json['id'],
      );
  final List<Filter> filters;
  final List<dynamic> images;
  final String id;
  final String name;
  final String desc;
  final String image;
  final int price;
  final int qty;
  final bool visible;
  final bool deleted;
  final Currency currency;
  final CartProducer producer;
  final String creator;
  final ReturnPolicy? returnPolicy;
  final EstimatedPickup? estimatedPickup;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String imageUrl;
  final List<ImagesUrl> imagesUrl;
  final String unit;
  final String productId;

  Map<String, dynamic> toJson() => {
        '_filters': List<dynamic>.from(filters.map((x) => x.toJson())),
        'images': List<dynamic>.from(images.map((x) => x)),
        '_id': id,
        'name': name,
        'desc': desc,
        'image': image,
        'price': price,
        'qty': qty,
        'visible': visible,
        'deleted': deleted,
        '_currency': currency.toJson(),
        '_producer': producer.toJson(),
        '_creator': creator,
        '_returnPolicy': returnPolicy?.toJson(),
        '_estimatedPickup': estimatedPickup?.toJson(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'image_url': imageUrl,
        'images_url': List<dynamic>.from(imagesUrl.map((x) => x.toJson())),
        'unit': unit,
        'id': productId,
      };
}

class Currency {
  Currency({
    required this.id,
    required this.name,
    required this.locale,
    required this.createdAt,
    required this.updatedAt,
    required this.code,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json['_id'],
        name: json['name'],
        locale: json['locale'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        code: json['code'],
      );
  final String id;
  final String name;
  final String locale;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String code;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'locale': locale,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'code': code,
      };
}

class EstimatedPickup {
  EstimatedPickup({
    required this.id,
    required this.producer,
    required this.title,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
    // required this.order,
    required this.estimatedPickupId,
  });

  factory EstimatedPickup.fromJson(Map<String, dynamic> json) =>
      EstimatedPickup(
        id: json['_id'],
        producer: json['_producer'],
        title: json['title'],
        deleted: json['deleted'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        // order: json['order'],
        estimatedPickupId: json['id'],
      );
  final String id;
  final dynamic producer;
  final String title;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  // final int order;
  final String estimatedPickupId;

  Map<String, dynamic> toJson() => {
        '_id': id,
        '_producer': producer,
        'title': title,
        'deleted': deleted,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        // 'order': order,
        'id': estimatedPickupId,
      };
}

class Filter {
  Filter({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.iconUrl,
    required this.filterId,
  });

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        id: json['_id'],
        name: json['name'],
        description: json['description'],
        icon: json['icon'],
        iconUrl: json['icon_url'],
        filterId: json['id'],
      );
  final String id;
  final String name;
  final String description;
  final String icon;
  final String iconUrl;
  final String filterId;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'description': description,
        'icon': icon,
        'icon_url': iconUrl,
        'id': filterId,
      };
}

class ImagesUrl {
  ImagesUrl({
    required this.url,
    required this.isDefault,
    required this.name,
  });

  factory ImagesUrl.fromJson(Map<String, dynamic> json) => ImagesUrl(
        url: json['url'],
        isDefault: json['is_default'],
        name: json['name'],
      );
  final String url;
  final bool isDefault;
  final String name;

  Map<String, dynamic> toJson() => {
        'url': url,
        'is_default': isDefault,
        'name': name,
      };
}

class CartProducer {
  CartProducer({
    required this.schedule,
    required this.urgentDelivery,
    required this.id,
    required this.name,
    required this.desc,
    required this.banner,
    required this.icon,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.currency,
    required this.urgentDeliveryCharge,
    required this.bannerUrl,
    required this.iconUrl,
    required this.producerId,
  });

  factory CartProducer.fromJson(Map<String, dynamic> json) => CartProducer(
        schedule: Schedule.fromJson(json['_schedule']),
        urgentDelivery: json['urgent_delivery'],
        id: json['_id'],
        name: json['name'],
        desc: json['desc'],
        banner: json['banner'],
        icon: json['icon'],
        status: json['status'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        currency: Currency.fromJson(json['_currency']),
        urgentDeliveryCharge: json['urgent_delivery_charge'],
        bannerUrl: json['banner_url'],
        iconUrl: json['icon_url'],
        producerId: json['id'],
      );
  final Schedule schedule;
  final bool urgentDelivery;
  final String id;
  final String name;
  final String desc;
  final String banner;
  final String icon;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Currency currency;
  final int urgentDeliveryCharge;
  final String bannerUrl;
  final String iconUrl;
  final String producerId;

  Map<String, dynamic> toJson() => {
        '_schedule': schedule.toJson(),
        'urgent_delivery': urgentDelivery,
        '_id': id,
        'name': name,
        'desc': desc,
        'banner': banner,
        'icon': icon,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '_currency': currency.toJson(),
        'urgent_delivery_charge': urgentDeliveryCharge,
        'banner_url': bannerUrl,
        'icon_url': iconUrl,
        'id': producerId,
      };
}

class Schedule {
  Schedule({
    required this.days,
    required this.frequency,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        days: json['days'],
        frequency: json['frequency'],
      );
  final String days;
  final String frequency;

  Map<String, dynamic> toJson() => {
        'days': days,
        'frequency': frequency,
      };
}

class ReturnPolicy {
  ReturnPolicy({
    required this.id,
    required this.title,
    required this.code,
    // required this.order,
    required this.returnPolicyId,
  });

  factory ReturnPolicy.fromJson(Map<String, dynamic> json) => ReturnPolicy(
        id: json['_id'],
        title: json['title'],
        code: json['code'],
        // order: json['order'],
        returnPolicyId: json['id'],
      );
  final String id;
  final String title;
  final String code;
  // final int order;
  final String returnPolicyId;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'code': code,
        // 'order': order,
        'id': returnPolicyId,
      };
}

class Slot {
  Slot({
    required this.label,
    required this.value,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        label: json['label'],
        value: json['value'],
      );
  final String label;
  final String value;

  Map<String, dynamic> toJson() => {
        'label': label,
        'value': value,
      };
}

class Charge {
  Charge({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Charge.fromJson(Map<String, dynamic> json) => Charge(
        id: json['_id'],
        code: json['code'],
        name: json['name'],
        type: json['type'],
        value: json['value'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
  final String id;
  final String code;
  final String name;
  final String type;
  final String value;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'code': code,
        'name': name,
        'type': type,
        'value': value,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
