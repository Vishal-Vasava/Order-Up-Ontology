import 'package:orderly_ecom/src/ontology/ontology.dart';

abstract final class OrderUpOntologyTypes {
  static const customer = OntologyType('customer');
  static const producer = OntologyType('producer');
  static const product = OntologyType('product');
  static const category = OntologyType('category');
  static const cart = OntologyType('cart');
  static const cartItem = OntologyType('cartItem');
  static const order = OntologyType('order');
  static const orderItem = OntologyType('orderItem');
  static const address = OntologyType('address');
  static const currency = OntologyType('currency');
  static const inventoryItem = OntologyType('inventoryItem');
  static const offer = OntologyType('offer');
  static const review = OntologyType('review');
  static const notification = OntologyType('notification');
  static const delivery = OntologyType('delivery');
  static const payment = OntologyType('payment');
}

abstract final class OrderUpOntologyRelations {
  static const ownsAddress = 'ownsAddress';
  static const sellsProduct = 'sellsProduct';
  static const productInCategory = 'productInCategory';
  static const pricedIn = 'pricedIn';
  static const containsCartItem = 'containsCartItem';
  static const cartItemReferencesProduct = 'cartItemReferencesProduct';
  static const placedOrder = 'placedOrder';
  static const containsOrderItem = 'containsOrderItem';
  static const orderItemReferencesProduct = 'orderItemReferencesProduct';
  static const deliveredTo = 'deliveredTo';
  static const fulfilledBy = 'fulfilledBy';
  static const paidBy = 'paidBy';
  static const reviewsProduct = 'reviewsProduct';
  static const offerTargetsCustomer = 'offerTargetsCustomer';
  static const offerDiscountsProduct = 'offerDiscountsProduct';
  static const notifiesCustomer = 'notifiesCustomer';
}

OntologyRegistry buildOrderUpOntologyRegistry() {
  return OntologyRegistry(
    types: const [
      OntologyTypeDefinition(
        type: OrderUpOntologyTypes.customer,
        displayName: 'Customer',
        attributes: [
          OntologyAttributeDefinition(
            name: 'name',
            valueType: OntologyValueType.string,
          ),
          OntologyAttributeDefinition(
            name: 'phone',
            valueType: OntologyValueType.string,
          ),
          OntologyAttributeDefinition(
            name: 'email',
            valueType: OntologyValueType.string,
          ),
        ],
      ),
      OntologyTypeDefinition(
        type: OrderUpOntologyTypes.producer,
        displayName: 'Producer',
        description: 'A store, seller, or supplier that fulfills products.',
        attributes: [
          OntologyAttributeDefinition(
            name: 'name',
            valueType: OntologyValueType.string,
            required: true,
          ),
          OntologyAttributeDefinition(
            name: 'status',
            valueType: OntologyValueType.boolean,
          ),
        ],
      ),
      OntologyTypeDefinition(
        type: OrderUpOntologyTypes.product,
        displayName: 'Product',
        attributes: [
          OntologyAttributeDefinition(
            name: 'name',
            valueType: OntologyValueType.string,
            required: true,
          ),
          OntologyAttributeDefinition(
            name: 'description',
            valueType: OntologyValueType.string,
          ),
          OntologyAttributeDefinition(
            name: 'price',
            valueType: OntologyValueType.decimal,
          ),
          OntologyAttributeDefinition(
            name: 'quantity',
            valueType: OntologyValueType.integer,
          ),
          OntologyAttributeDefinition(
            name: 'unit',
            valueType: OntologyValueType.string,
          ),
        ],
      ),
      OntologyTypeDefinition(
        type: OrderUpOntologyTypes.category,
        displayName: 'Category',
      ),
      OntologyTypeDefinition(
        type: OrderUpOntologyTypes.cart,
        displayName: 'Cart',
      ),
      OntologyTypeDefinition(
        type: OrderUpOntologyTypes.cartItem,
        displayName: 'Cart Item',
        attributes: [
          OntologyAttributeDefinition(
            name: 'quantity',
            valueType: OntologyValueType.integer,
            required: true,
          ),
          OntologyAttributeDefinition(
            name: 'isAvailable',
            valueType: OntologyValueType.boolean,
          ),
        ],
      ),
      OntologyTypeDefinition(
        type: OrderUpOntologyTypes.order,
        displayName: 'Order',
        attributes: [
          OntologyAttributeDefinition(
            name: 'orderNumber',
            valueType: OntologyValueType.string,
          ),
          OntologyAttributeDefinition(
            name: 'deliveryType',
            valueType: OntologyValueType.string,
          ),
          OntologyAttributeDefinition(
            name: 'orderTotal',
            valueType: OntologyValueType.decimal,
          ),
          OntologyAttributeDefinition(
            name: 'createdAt',
            valueType: OntologyValueType.dateTime,
          ),
        ],
      ),
      OntologyTypeDefinition(
        type: OrderUpOntologyTypes.orderItem,
        displayName: 'Order Item',
        attributes: [
          OntologyAttributeDefinition(
            name: 'status',
            valueType: OntologyValueType.string,
          ),
          OntologyAttributeDefinition(
            name: 'quantity',
            valueType: OntologyValueType.integer,
          ),
          OntologyAttributeDefinition(
            name: 'price',
            valueType: OntologyValueType.decimal,
          ),
        ],
      ),
      OntologyTypeDefinition(
        type: OrderUpOntologyTypes.address,
        displayName: 'Address',
      ),
      OntologyTypeDefinition(
        type: OrderUpOntologyTypes.currency,
        displayName: 'Currency',
      ),
      OntologyTypeDefinition(
        type: OrderUpOntologyTypes.inventoryItem,
        displayName: 'Inventory Item',
      ),
      OntologyTypeDefinition(
        type: OrderUpOntologyTypes.offer,
        displayName: 'Offer',
      ),
      OntologyTypeDefinition(
        type: OrderUpOntologyTypes.review,
        displayName: 'Review',
      ),
      OntologyTypeDefinition(
        type: OrderUpOntologyTypes.notification,
        displayName: 'Notification',
      ),
      OntologyTypeDefinition(
        type: OrderUpOntologyTypes.delivery,
        displayName: 'Delivery',
      ),
      OntologyTypeDefinition(
        type: OrderUpOntologyTypes.payment,
        displayName: 'Payment',
      ),
    ],
    relations: const [
      OntologyRelationDefinition(
        name: OrderUpOntologyRelations.ownsAddress,
        sourceType: OrderUpOntologyTypes.customer,
        targetType: OrderUpOntologyTypes.address,
        cardinality: OntologyCardinality.oneToMany,
      ),
      OntologyRelationDefinition(
        name: OrderUpOntologyRelations.sellsProduct,
        sourceType: OrderUpOntologyTypes.producer,
        targetType: OrderUpOntologyTypes.product,
        cardinality: OntologyCardinality.oneToMany,
      ),
      OntologyRelationDefinition(
        name: OrderUpOntologyRelations.productInCategory,
        sourceType: OrderUpOntologyTypes.product,
        targetType: OrderUpOntologyTypes.category,
      ),
      OntologyRelationDefinition(
        name: OrderUpOntologyRelations.pricedIn,
        sourceType: OrderUpOntologyTypes.product,
        targetType: OrderUpOntologyTypes.currency,
        cardinality: OntologyCardinality.manyToOne,
      ),
      OntologyRelationDefinition(
        name: OrderUpOntologyRelations.containsCartItem,
        sourceType: OrderUpOntologyTypes.cart,
        targetType: OrderUpOntologyTypes.cartItem,
        cardinality: OntologyCardinality.oneToMany,
      ),
      OntologyRelationDefinition(
        name: OrderUpOntologyRelations.cartItemReferencesProduct,
        sourceType: OrderUpOntologyTypes.cartItem,
        targetType: OrderUpOntologyTypes.product,
        cardinality: OntologyCardinality.manyToOne,
      ),
      OntologyRelationDefinition(
        name: OrderUpOntologyRelations.placedOrder,
        sourceType: OrderUpOntologyTypes.customer,
        targetType: OrderUpOntologyTypes.order,
        cardinality: OntologyCardinality.oneToMany,
      ),
      OntologyRelationDefinition(
        name: OrderUpOntologyRelations.containsOrderItem,
        sourceType: OrderUpOntologyTypes.order,
        targetType: OrderUpOntologyTypes.orderItem,
        cardinality: OntologyCardinality.oneToMany,
      ),
      OntologyRelationDefinition(
        name: OrderUpOntologyRelations.orderItemReferencesProduct,
        sourceType: OrderUpOntologyTypes.orderItem,
        targetType: OrderUpOntologyTypes.product,
        cardinality: OntologyCardinality.manyToOne,
      ),
      OntologyRelationDefinition(
        name: OrderUpOntologyRelations.deliveredTo,
        sourceType: OrderUpOntologyTypes.order,
        targetType: OrderUpOntologyTypes.address,
        cardinality: OntologyCardinality.manyToOne,
      ),
      OntologyRelationDefinition(
        name: OrderUpOntologyRelations.fulfilledBy,
        sourceType: OrderUpOntologyTypes.orderItem,
        targetType: OrderUpOntologyTypes.producer,
        cardinality: OntologyCardinality.manyToOne,
      ),
      OntologyRelationDefinition(
        name: OrderUpOntologyRelations.paidBy,
        sourceType: OrderUpOntologyTypes.order,
        targetType: OrderUpOntologyTypes.payment,
        cardinality: OntologyCardinality.oneToOne,
      ),
      OntologyRelationDefinition(
        name: OrderUpOntologyRelations.reviewsProduct,
        sourceType: OrderUpOntologyTypes.review,
        targetType: OrderUpOntologyTypes.product,
        cardinality: OntologyCardinality.manyToOne,
      ),
      OntologyRelationDefinition(
        name: OrderUpOntologyRelations.offerTargetsCustomer,
        sourceType: OrderUpOntologyTypes.offer,
        targetType: OrderUpOntologyTypes.customer,
      ),
      OntologyRelationDefinition(
        name: OrderUpOntologyRelations.offerDiscountsProduct,
        sourceType: OrderUpOntologyTypes.offer,
        targetType: OrderUpOntologyTypes.product,
      ),
      OntologyRelationDefinition(
        name: OrderUpOntologyRelations.notifiesCustomer,
        sourceType: OrderUpOntologyTypes.notification,
        targetType: OrderUpOntologyTypes.customer,
        cardinality: OntologyCardinality.manyToOne,
      ),
    ],
  );
}

