import 'package:intl/intl.dart';

final NumberFormat _currency = NumberFormat.currency(
  locale: 'en_IN',
  symbol: '\u20B9', // ₹
  decimalDigits: 0,
);

// No locale arg => date symbols work without initializeDateFormatting().
final DateFormat _shortDate = DateFormat('dd/MM/yyyy');
final DateFormat _longDate = DateFormat('dd MMM yyyy');

/// ₹ en_IN, no decimals. e.g. ₹1,25,000
String formatCurrency(num value) => _currency.format(value);

/// grams with 3 decimals + " g" suffix. e.g. 5.250 g
String formatWeight(double value) => '${value.toStringAsFixed(3)} g';

/// en_IN short date. e.g. 12/04/2026
String formatDate(DateTime value) => _shortDate.format(value);

/// Longer date used in a few places. e.g. 12 Apr 2026
String formatLongDate(DateTime value) => _longDate.format(value);

/// "x ago" relative label, falling back to a short date.
String formatRelative(DateTime value) {
  final Duration diff = DateTime.now().difference(value);
  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return _shortDate.format(value);
}

/// Indian-style compact currency (₹1.3L, ₹2.5Cr) for tight spaces.
String formatCompactCurrency(num value) {
  final double v = value.toDouble();
  final double abs = v.abs();
  final String sign = v < 0 ? '-' : '';
  String trim(double x) {
    final String s = x.toStringAsFixed(1);
    return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
  }

  if (abs >= 10000000) return '$sign\u20B9${trim(abs / 10000000)}Cr';
  if (abs >= 100000) return '$sign\u20B9${trim(abs / 100000)}L';
  if (abs >= 1000) return '$sign\u20B9${trim(abs / 1000)}K';
  return _currency.format(v);
}
