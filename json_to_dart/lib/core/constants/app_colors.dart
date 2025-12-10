import 'dart:ui';

class AppColors {
  // Provided Palette
  // #C8E3CB
  // #364859
  // #283846
  // #87BAA2

  static const Color paleGreen = Color(0xFFC8E3CB);
  static const Color slateBlue = Color(0xFF364859);
  static const Color darkSlate = Color(0xFF283846);
  static const Color sageGreen = Color(0xFF87BAA2);

  // Semantic mappings
  static const Color background = darkSlate;
  static const Color surface = slateBlue;
  static const Color primary = sageGreen;
  static const Color onPrimary = darkSlate;
  static const Color textPrimary = paleGreen;
  static const Color textSecondary = Color(
    0xFFB0C4B5,
  ); // Slightly darker pale green for hierarchy (calculated manually, opaque)

  static const Color error = Color(0xFFCF6679);
}
