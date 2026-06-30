import 'package:hive/hive.dart';

import '../../core/constants/constants.dart';

part 'rates.g.dart';

/// A single historical snapshot of headline rates.
@HiveType(typeId: TypeIds.rateHistoryEntry)
class RateHistoryEntry {
  RateHistoryEntry({
    required this.date,
    required this.gold22k,
    required this.silver925,
  });

  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final double gold22k;

  @HiveField(2)
  final double silver925;
}

/// Current metal rates (₹/gram) plus a rolling history.
@HiveType(typeId: TypeIds.rates)
class Rates {
  Rates({
    required this.gold18k,
    required this.gold22k,
    required this.gold24k,
    required this.silver925,
    required this.lastUpdated,
    List<RateHistoryEntry>? rateHistory,
  }) : rateHistory = rateHistory ?? <RateHistoryEntry>[];

  @HiveField(0)
  double gold18k;

  @HiveField(1)
  double gold22k;

  @HiveField(2)
  double gold24k;

  @HiveField(3)
  double silver925;

  @HiveField(4)
  DateTime lastUpdated;

  @HiveField(5)
  List<RateHistoryEntry> rateHistory;

  double rateForCarat(String carat) {
    switch (carat) {
      case '18K':
        return gold18k;
      case '22K':
        return gold22k;
      case '24K':
        return gold24k;
      case 'Silver 925':
        return silver925;
      default:
        return gold22k;
    }
  }

  /// Most recent previous snapshot (for up/down arrows), if any.
  RateHistoryEntry? get previous =>
      rateHistory.isEmpty ? null : rateHistory.last;

  Rates copyWith({
    double? gold18k,
    double? gold22k,
    double? gold24k,
    double? silver925,
    DateTime? lastUpdated,
    List<RateHistoryEntry>? rateHistory,
  }) {
    return Rates(
      gold18k: gold18k ?? this.gold18k,
      gold22k: gold22k ?? this.gold22k,
      gold24k: gold24k ?? this.gold24k,
      silver925: silver925 ?? this.silver925,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rateHistory: rateHistory ?? this.rateHistory,
    );
  }
}
