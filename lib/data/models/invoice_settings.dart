import 'package:hive/hive.dart';

import '../../core/constants/constants.dart';

part 'invoice_settings.g.dart';

/// Invoice presentation preferences.
@HiveType(typeId: TypeIds.invoiceSettings)
class InvoiceSettings {
  InvoiceSettings({
    required this.prefix,
    required this.footerText,
    this.showHuid = true,
    this.showGst = true,
  });

  @HiveField(0)
  String prefix;

  @HiveField(1)
  String footerText;

  @HiveField(2)
  bool showHuid;

  @HiveField(3)
  bool showGst;

  InvoiceSettings copyWith({
    String? prefix,
    String? footerText,
    bool? showHuid,
    bool? showGst,
  }) {
    return InvoiceSettings(
      prefix: prefix ?? this.prefix,
      footerText: footerText ?? this.footerText,
      showHuid: showHuid ?? this.showHuid,
      showGst: showGst ?? this.showGst,
    );
  }
}
