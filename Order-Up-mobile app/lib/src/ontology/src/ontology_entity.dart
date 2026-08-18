import 'ontology_value.dart';

abstract class OntologyEntity {
  const OntologyEntity({
    required this.id,
    required this.type,
    this.label,
    this.attributes = const {},
  });

  final OntologyId id;
  final OntologyType type;
  final String? label;
  final Map<String, Object?> attributes;
}

class EntityReference {
  const EntityReference({
    required this.id,
    required this.type,
    this.label,
  });

  final OntologyId id;
  final OntologyType type;
  final String? label;

  Map<String, Object?> toJson() => {
        'id': id.value,
        'type': type.value,
        if (label != null) 'label': label,
      };
}

