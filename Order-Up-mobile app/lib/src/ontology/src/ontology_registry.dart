import 'ontology_relation.dart';
import 'ontology_value.dart';

class OntologyRegistry {
  OntologyRegistry({
    Iterable<OntologyTypeDefinition> types = const [],
    Iterable<OntologyRelationDefinition> relations = const [],
  })  : _types = {
          for (final type in types) type.type: type,
        },
        _relations = {
          for (final relation in relations) relation.name: relation,
        };

  final Map<OntologyType, OntologyTypeDefinition> _types;
  final Map<String, OntologyRelationDefinition> _relations;

  Iterable<OntologyTypeDefinition> get types => _types.values;
  Iterable<OntologyRelationDefinition> get relations => _relations.values;

  void registerType(OntologyTypeDefinition definition) {
    _types[definition.type] = definition;
  }

  void registerRelation(OntologyRelationDefinition definition) {
    _relations[definition.name] = definition;
  }

  OntologyTypeDefinition? typeOf(OntologyType type) => _types[type];

  OntologyRelationDefinition? relation(String name) => _relations[name];
}

class OntologyTypeDefinition {
  const OntologyTypeDefinition({
    required this.type,
    required this.displayName,
    this.description,
    this.attributes = const [],
  });

  final OntologyType type;
  final String displayName;
  final String? description;
  final List<OntologyAttributeDefinition> attributes;
}

class OntologyAttributeDefinition {
  const OntologyAttributeDefinition({
    required this.name,
    required this.valueType,
    this.required = false,
    this.description,
  });

  final String name;
  final OntologyValueType valueType;
  final bool required;
  final String? description;
}

enum OntologyValueType {
  boolean,
  dateTime,
  decimal,
  integer,
  list,
  map,
  string,
}

