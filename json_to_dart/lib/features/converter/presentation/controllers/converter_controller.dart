import 'package:flutter/material.dart';
import '../../domain/logic/json_parser.dart';
import '../../domain/logic/dart_generator.dart';

class ConverterController extends ChangeNotifier {
  final _parser = JsonConverterLogic();
  final _generator = DartGenerator();

  String _jsonInput = '';
  String get jsonInput => _jsonInput;

  String _dartOutput = '';
  String get dartOutput => _dartOutput;

  String? _error;
  String? get error => _error;

  String _className = 'MyModel';
  String get className => _className;

  void updateClassName(String name) {
    _className = name;
    _convert();
  }

  void updateInput(String input) {
    _jsonInput = input;
    _convert();
  }

  void _convert() {
    _error = null;
    if (_jsonInput.isEmpty) {
      _dartOutput = '';
      notifyListeners();
      return;
    }

    try {
      final classes = _parser.convert(
        _jsonInput,
        _className.isEmpty ? 'MyModel' : _className,
      );
      _dartOutput = _generator.generateCode(classes);
    } catch (e) {
      _dartOutput = '';
      // User requested "format hatalı uyarısı".
      if (e is FormatException) {
        _error = 'Invalid JSON Format: ${e.message}';
      } else {
        _error = 'Error: ${e.toString()}';
      }
    }
    notifyListeners();
  }
}
