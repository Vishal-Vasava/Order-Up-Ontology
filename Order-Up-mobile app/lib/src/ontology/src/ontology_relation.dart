import 'ontology_entity.dart';
import 'ontology_value.dart';

class OntologyRelation {
  const OntologyRelation({
    required this.name,
    required this.source,
    required this.target,
    this.attributes = const {},
  });

  final String name;
  final EntityReference source;
  final EntityReference target;
  final Map<String, Object?> attributes;
}

class OntologyRelationDefinition {
  const OntologyRelationDefinition({
    required this.name,
    required this.sourceType,
    required this.targetType,
    this.cardinality = OntologyCardinality.manyToMany,
    this.description,
  });

  final String name;
  final OntologyType sourceType;
  final OntologyType targetType;
  final OntologyCardinality cardinality;
  final String? description;
}

enum OntologyCardinality {
  oneToOne,
  oneToMany,
  manyToOne,
  manyToMany,
}

