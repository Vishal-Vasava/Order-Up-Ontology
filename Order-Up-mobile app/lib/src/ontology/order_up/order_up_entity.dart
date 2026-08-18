import 'package:orderly_ecom/src/ontology/ontology.dart';

class OrderUpEntity extends OntologyEntity {
  const OrderUpEntity({
    required super.id,
    required super.type,
    super.label,
    super.attributes,
    this.relations = const [],
  });

  final List<OntologyRelation> relations;
}

