import '../models/class_model.dart';

class DartGenerator {
  // final _formatter = DartFormatter(); // Temporarily removed due to API change

  String generateCode(List<DartClass> classes) {
    final buffer = StringBuffer();

    for (final cls in classes) {
      buffer.writeln(_generateSingleClass(cls));
      buffer.writeln(); // Spacing between classes
    }

    return buffer.toString();
  }

  String _generateSingleClass(DartClass cls) {
    final buffer = StringBuffer();

    buffer.writeln('class ${cls.name} {');

    // Fields
    for (final field in cls.fields) {
      final typeDecl = field.isList ? 'List<${field.type}>?' : '${field.type}?';
      buffer.writeln('  final $typeDecl ${field.fieldName};');
    }

    buffer.writeln();

    // Constructor
    buffer.writeln('  ${cls.name}({');
    for (final field in cls.fields) {
      buffer.writeln('    this.${field.fieldName},');
    }
    buffer.writeln('  });');

    buffer.writeln();

    // fromJson
    buffer.writeln(
      '  factory ${cls.name}.fromJson(Map<String, dynamic> json) {',
    );
    buffer.writeln('    return ${cls.name}(');
    for (final field in cls.fields) {
      final jsonAccess = "json['${field.jsonKey}']";

      String assignment;
      if (field.isList) {
        // List handling
        if (_isPrimitive(field.type)) {
          assignment =
              '($jsonAccess as List<dynamic>?)?.map((e) => e as ${field.type}).toList()';
        } else {
          // List of objects
          assignment =
              '($jsonAccess as List<dynamic>?)?.map((e) => ${field.type}.fromJson(e as Map<String, dynamic>)).toList()';
        }
      } else {
        // Single item
        if (_isPrimitive(field.type)) {
          assignment = '$jsonAccess as ${field.type}?';
        } else if (field.type == 'dynamic') {
          assignment = jsonAccess;
        } else {
          // Nested object
          assignment =
              '$jsonAccess == null ? null : ${field.type}.fromJson($jsonAccess as Map<String, dynamic>)';
        }
      }

      buffer.writeln('      ${field.fieldName}: $assignment,');
    }
    buffer.writeln('    );');
    buffer.writeln('  }');

    buffer.writeln();

    // toJson
    buffer.writeln('  Map<String, dynamic> toJson() {');
    buffer.writeln(
      '    final Map<String, dynamic> data = <String, dynamic>{};',
    );
    for (final field in cls.fields) {
      if (field.isList) {
        if (_isPrimitive(field.type)) {
          buffer.writeln("    data['${field.jsonKey}'] = ${field.fieldName};");
        } else {
          buffer.writeln(
            "    data['${field.jsonKey}'] = ${field.fieldName}?.map((v) => v.toJson()).toList();",
          );
        }
      } else {
        if (_isPrimitive(field.type) || field.type == 'dynamic') {
          buffer.writeln("    data['${field.jsonKey}'] = ${field.fieldName};");
        } else {
          buffer.writeln(
            "    data['${field.jsonKey}'] = ${field.fieldName}?.toJson();",
          );
        }
      }
    }
    buffer.writeln('    return data;');
    buffer.writeln('  }');

    buffer.writeln('}');

    return buffer.toString();
  }

  bool _isPrimitive(String type) {
    return ['int', 'double', 'bool', 'String', 'dynamic'].contains(type);
  }
}
