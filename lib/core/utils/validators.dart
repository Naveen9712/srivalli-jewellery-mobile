/// Form validation helpers. All return `null` when valid.
class Validators {
  Validators._();

  static String? required(String? value, [String field = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  static String? positiveNumber(String? value, {String field = 'Value', bool allowZero = true}) {
    if (value == null || value.trim().isEmpty) {
      return allowZero ? null : '$field is required';
    }
    final double? parsed = double.tryParse(value.trim());
    if (parsed == null) return 'Enter a valid number';
    if (parsed < 0) return '$field cannot be negative';
    if (!allowZero && parsed == 0) return '$field must be greater than 0';
    return null;
  }

  static String? integer(String? value, {String field = 'Value', bool allowZero = true}) {
    if (value == null || value.trim().isEmpty) {
      return allowZero ? null : '$field is required';
    }
    final int? parsed = int.tryParse(value.trim());
    if (parsed == null) return 'Enter a whole number';
    if (parsed < 0) return '$field cannot be negative';
    if (!allowZero && parsed == 0) return '$field must be greater than 0';
    return null;
  }

  static String? percentage(String? value, {String field = 'Percentage'}) {
    if (value == null || value.trim().isEmpty) return null;
    final double? parsed = double.tryParse(value.trim());
    if (parsed == null) return 'Enter a valid number';
    if (parsed < 0 || parsed > 100) return '$field must be 0–100';
    return null;
  }
}

/// Safe parsing helpers.
extension NumParsing on String {
  double toDoubleOrZero() => double.tryParse(trim()) ?? 0;
  int toIntOrZero() => int.tryParse(trim()) ?? 0;
}
