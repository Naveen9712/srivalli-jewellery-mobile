import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/invoice_settings.dart';
import '../../data/models/rates.dart';
import '../../data/models/shop_settings.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/page_header.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  // Shop
  late final TextEditingController _shopName;
  late final TextEditingController _gst;
  late final TextEditingController _address;
  late final TextEditingController _phone;
  // Rates
  late final TextEditingController _r18;
  late final TextEditingController _r22;
  late final TextEditingController _r24;
  late final TextEditingController _rSilver;
  // Invoice
  late final TextEditingController _prefix;
  late final TextEditingController _footer;
  bool _showHuid = true;
  bool _showGst = true;

  @override
  void initState() {
    super.initState();
    final ShopSettings? shop = ref.read(shopSettingsProvider);
    final Rates? rates = ref.read(ratesProvider);
    final InvoiceSettings? inv = ref.read(invoiceSettingsProvider);

    _shopName = TextEditingController(text: shop?.shopName ?? '');
    _gst = TextEditingController(text: shop?.gstNumber ?? '');
    _address = TextEditingController(text: shop?.address ?? '');
    _phone = TextEditingController(text: shop?.phone ?? '');

    _r18 = TextEditingController(text: rates?.gold18k.toString() ?? '');
    _r22 = TextEditingController(text: rates?.gold22k.toString() ?? '');
    _r24 = TextEditingController(text: rates?.gold24k.toString() ?? '');
    _rSilver = TextEditingController(text: rates?.silver925.toString() ?? '');

    _prefix = TextEditingController(text: inv?.prefix ?? 'SJ');
    _footer = TextEditingController(text: inv?.footerText ?? '');
    _showHuid = inv?.showHuid ?? true;
    _showGst = inv?.showGst ?? true;
  }

  @override
  void dispose() {
    for (final TextEditingController c in <TextEditingController>[
      _shopName, _gst, _address, _phone,
      _r18, _r22, _r24, _rSilver, _prefix, _footer,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _snack(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _saveShop() async {
    final ShopSettings current =
        ref.read(shopSettingsProvider) ??
            ShopSettings(shopName: '', gstNumber: '', address: '', phone: '');
    await ref.read(settingsRepositoryProvider).setShop(
          current.copyWith(
            shopName: _shopName.text.trim(),
            gstNumber: _gst.text.trim(),
            address: _address.text.trim(),
            phone: _phone.text.trim(),
          ),
        );
    _snack('Shop info saved');
  }

  Future<void> _saveRates() async {
    final double? r18 = _positive(_r18.text);
    final double? r22 = _positive(_r22.text);
    final double? r24 = _positive(_r24.text);
    final double? rS = _positive(_rSilver.text);
    if (r18 == null || r22 == null || r24 == null || rS == null) {
      _snack('Rates must be valid, non-negative numbers');
      return;
    }
    await ref.read(settingsRepositoryProvider).updateRates(
          gold18k: r18,
          gold22k: r22,
          gold24k: r24,
          silver925: rS,
        );
    _snack('Rates updated');
  }

  Future<void> _saveInvoice() async {
    final InvoiceSettings current =
        ref.read(invoiceSettingsProvider) ??
            InvoiceSettings(prefix: 'SJ', footerText: '');
    await ref.read(settingsRepositoryProvider).setInvoice(
          current.copyWith(
            prefix: _prefix.text.trim(),
            footerText: _footer.text.trim(),
            showHuid: _showHuid,
            showGst: _showGst,
          ),
        );
    _snack('Invoice settings saved');
  }

  double? _positive(String text) {
    final double? v = double.tryParse(text.trim());
    if (v == null || v < 0) return null;
    return v;
  }

  @override
  Widget build(BuildContext context) {
    final Rates? rates = ref.watch(ratesProvider);

    return ListView(
      children: <Widget>[
        const PageHeader(
          title: 'Settings',
          subtitle: 'Shop, rates, invoice and theme preferences',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          child: Column(
            children: <Widget>[
              _Section(
                title: 'Shop Information',
                icon: Icons.storefront_outlined,
                children: <Widget>[
                  _field('Shop name', _shopName),
                  _field('GST number', _gst),
                  _field('Address', _address, maxLines: 2),
                  _field('Phone', _phone, keyboardType: TextInputType.phone),
                  const SizedBox(height: 4),
                  GradientButton(
                    label: 'Save shop info',
                    icon: Icons.save_outlined,
                    expand: true,
                    onPressed: _saveShop,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _Section(
                title: 'Rate Settings (₹/gram)',
                icon: Icons.currency_rupee_rounded,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(child: _field('Gold 18K', _r18, number: true)),
                      const SizedBox(width: 12),
                      Expanded(child: _field('Gold 22K', _r22, number: true)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(child: _field('Gold 24K', _r24, number: true)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _field('Silver 925', _rSilver, number: true)),
                    ],
                  ),
                  if (rates != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Last updated: ${formatLongDate(rates.lastUpdated)}',
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                  const SizedBox(height: 12),
                  GradientButton(
                    label: 'Save rates',
                    icon: Icons.save_outlined,
                    expand: true,
                    onPressed: _saveRates,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _Section(
                title: 'Invoice Settings',
                icon: Icons.receipt_long_outlined,
                children: <Widget>[
                  _field('Invoice prefix', _prefix),
                  _field('Footer text', _footer, maxLines: 3),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: _showHuid,
                    onChanged: (bool v) => setState(() => _showHuid = v),
                    title: const Text('Show HUID on Invoice'),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: _showGst,
                    onChanged: (bool v) => setState(() => _showGst = v),
                    title: const Text('Show GST Breakdown'),
                  ),
                  const SizedBox(height: 8),
                  GradientButton(
                    label: 'Save invoice settings',
                    icon: Icons.save_outlined,
                    expand: true,
                    onPressed: _saveInvoice,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _ThemeSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    bool number = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: AppTextStyles.label),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: number
                ? const TextInputType.numberWithOptions(decimal: true)
                : keyboardType,
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: AppColors.border),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x0A0F2744), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.navy900.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: AppColors.navy800),
              ),
              const SizedBox(width: 12),
              Text(title, style: AppTextStyles.headingMedium),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _ThemeSection extends StatelessWidget {
  const _ThemeSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Theme Settings',
      icon: Icons.palette_outlined,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Current theme', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 2),
                  Text('Elegant Blue + Gold',
                      style: AppTextStyles.titleMedium),
                ],
              ),
            ),
            Row(
              children: const <Widget>[
                _Swatch(AppColors.navy900),
                _Swatch(AppColors.navy800),
                _Swatch(AppColors.gold400),
                _Swatch(AppColors.gold500),
                _Swatch(AppColors.gold600),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.color);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      margin: const EdgeInsets.only(left: 6),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
    );
  }
}
