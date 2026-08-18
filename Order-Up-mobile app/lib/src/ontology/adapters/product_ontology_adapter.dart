import 'package:orderly_ecom/src/features/product/domain/product.dart';
import 'package:orderly_ecom/src/ontology/ontology.dart';
import 'package:orderly_ecom/src/ontology/order_up/order_up_entity.dart';
import 'package:orderly_ecom/src/ontology/order_up/order_up_ontology.dart';

extension ProductDataOntologyAdapter on ProductData {
  OrderUpEntity toOntologyEntity() {
    final productKey = productId ?? id;

    return OrderUpEntity(
      id: OntologyId(productKey ?? ''),
      type: OrderUpOntologyTypes.product,
      label: name,
      attributes: {
        if (name != null) 'name': name,
        if (desc != null) 'description': desc,
        if (price != null) 'price': price,
        if (qty != null) 'quantity': qty,
        if (unit != null) 'unit': unit,
        if (visible != null) 'visible': visible,
        if (deleted != null) 'deleted': deleted,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (offerPrice != null) 'offerPrice': offerPrice,
        if (averageRatings != null) 'averageRatings': averageRatings,
        if (totalRatings != null) 'totalRatings': totalRatings,
        if (createdAt != null) 'createdAt': createdAt,
        if (updatedAt != null) 'updatedAt': updatedAt,
      },
      relations: [
        if (currency?.code != null)
          OntologyRelation(
            name: OrderUpOntologyRelations.pricedIn,
            source: EntityReference(
              id: OntologyId(productKey ?? ''),
              type: OrderUpOntologyTypes.product,
              label: name,
            ),
            target: EntityReference(
              id: OntologyId(currency!.code!),
              type: OrderUpOntologyTypes.currency,
              label: currency!.name,
            ),
          ),
      ],
    );
  }
}

extension ProductOntologyAdapter on Product {
  List<OrderUpEntity> toOntologyEntities() {
    return productList?.map((product) => product.toOntologyEntity()).toList() ??
        const [];
  }
}

