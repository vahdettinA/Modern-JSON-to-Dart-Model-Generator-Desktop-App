import 'dart:convert';
import '../models/class_model.dart';

class JsonConverterLogic {
  final List<DartClass> _generatedClasses = [];

  List<DartClass> convert(String jsonInput, String rootClassName) {
    _generatedClasses.clear();
    try {
      final decoded = json.decode(jsonInput);
      if (decoded is Map<String, dynamic>) {
        _generateClass(rootClassName, decoded);
      } else if (decoded is List) {
        if (decoded.isNotEmpty && decoded.first is Map<String, dynamic>) {
          _generateClass(rootClassName, decoded.first as Map<String, dynamic>);
        } else {
          // Root is a list of primitives? Rare for a model generator, usually we generate the item type.
          // But if user pastes `[1, 2]`, we can't make a class.
          // We assume object or list of objects.
        }
      }
      return _generatedClasses.reversed
          .toList(); // Reverse so dependent classes come first (optional)
    } catch (e) {
      // Return empty or throw, UI should handle format error.
      rethrow;
    }
  }

  String _generateClass(String className, Map<String, dynamic> jsonMap) {
    final fields = <DartField>[];

    // Capitalize class name
    final finalClassName = _capitalize(className);

    jsonMap.forEach((key, value) {
      final fieldName = _toCamelCase(key);
      String type = 'dynamic';
      bool isList = false;

      if (value is int) {
        type = 'int';
      } else if (value is double) {
        type = 'double';
      } else if (value is bool) {
        type = 'bool';
      } else if (value is String) {
        type = 'String';
      } else if (value is Map) {
        // Nested object
        type = _generateClass(key, value as Map<String, dynamic>);
      } else if (value is List) {
        isList = true;
        if (value.isNotEmpty) {
          final firstItem = value.first;
          if (firstItem is int) {
            type = 'int';
          } else if (firstItem is double) {
            type = 'double';
          } else if (firstItem is bool) {
            type = 'bool';
          } else if (firstItem is String) {
            type = 'String';
          } else if (firstItem is Map) {
            // List of objects
            type = _generateClass(key, firstItem as Map<String, dynamic>);
          }
        } else {
          type = 'dynamic'; // Empty list
        }
      }

      fields.add(
        DartField(
          jsonKey: key,
          fieldName: fieldName,
          type: type,
          isList: isList,
        ),
      );
    });

    final newClass = DartClass(name: finalClassName, fields: fields);

    // Check if duplicate class exists with same name but different fields?
    // For simplicity, we just add it. In real app, we might merge or rename.
    _generatedClasses.add(newClass);

    return finalClassName;
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  String _toCamelCase(String s) {
    if (s.isEmpty) return s;
    final parts = s.split('_');
    final first = parts.first;
    final rest = parts.skip(1).map((p) => _capitalize(p)).join();
    // Ensure valid identifier (strip non-alphanumeric if needed, but assuming valid JSON keys)
    return first + rest;
  }
}
