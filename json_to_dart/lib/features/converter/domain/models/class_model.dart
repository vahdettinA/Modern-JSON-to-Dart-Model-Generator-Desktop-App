class DartClass {
  final String name;
  final List<DartField> fields;

  DartClass({required this.name, required this.fields});

  @override
  String toString() {
    return 'DartClass(name: $name, fields: $fields)';
  }
}

class DartField {
  final String jsonKey;
  final String fieldName;
  final String type;
  final bool isList;
  final bool isNullable;

  DartField({
    required this.jsonKey,
    required this.fieldName,
    required this.type,
    this.isList = false,
    this.isNullable = true,
  });

  @override
  String toString() {
    return 'DartField(name: $fieldName, type: $type, isList: $isList)';
  }
}
