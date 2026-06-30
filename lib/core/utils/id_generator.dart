import 'package:uuid/uuid.dart';

import '../constants/constants.dart';

const Uuid _uuid = Uuid();

/// Generates a fresh UUID v4 (used for permanent product ids).
String generateUuid() => _uuid.v4();

/// Builds a SKU / unique number following the Srivalli format:
///
///   metal     = carat.contains("Silver") ? "SLV" : "GLD"
///   prefix    = PREFIX_MAP[category] ?? "PRD"
///   caratCode = carat.replaceAll(" ", "").toUpperCase()   // "Silver 925" -> "SILVER925"
///   seq       = (currentProductCount + 1).padLeft(4,'0')
///   sku       = "$metal-$prefix-$caratCode-$seq"            // GLD-RNG-22K-0001
String generateSku({
  required String category,
  required String carat,
  required int currentProductCount,
}) {
  final String metal = carat.contains('Silver') ? 'SLV' : 'GLD';
  final String prefix = AppData.skuPrefix[category] ?? 'PRD';
  final String caratCode = carat.replaceAll(' ', '').toUpperCase();
  final String seq = (currentProductCount + 1).toString().padLeft(4, '0');
  return '$metal-$prefix-$caratCode-$seq';
}
