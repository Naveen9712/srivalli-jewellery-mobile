import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/constants/constants.dart';
import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/id_generator.dart';
import '../../data/models/product.dart';
import '../../widgets/category_image.dart';
import '../../widgets/gradient_button.dart';

class AddEditProductPage extends ConsumerStatefulWidget {
  const AddEditProductPage({super.key, this.productId, this.initialCategory});

  final String? productId;
  final String? initialCategory;

  bool get isEditing => productId != null;

  @override
  ConsumerState<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends ConsumerState<AddEditProductPage> {
  final ImagePicker _picker = ImagePicker();

  // Controllers
  final TextEditingController _name = TextEditingController();
  final TextEditingController _sku = TextEditingController();
  final TextEditingController _netWeight = TextEditingController();
  final TextEditingController _grossWeight = TextEditingController();
  final TextEditingController _stoneWeight = TextEditingController();
  final TextEditingController _wastage = TextEditingController();
  final TextEditingController _making = TextEditingController();
  final TextEditingController _purchase = TextEditingController();
  final TextEditingController _selling = TextEditingController();
  final TextEditingController _quantity = TextEditingController(text: '1');
  final TextEditingController _huid = TextEditingController();
  final TextEditingController _designCode = TextEditingController();
  final TextEditingController _vendor = TextEditingController();

  // Dropdown state
  String? _category;
  String? _subCategory;
  String _metalType = 'Gold';
  String? _carat;
  String _status = AppData.statusInStock;

  String? _imagePath;
  bool _advancedOpen = false;
  bool _skuManuallyEdited = false;
  String _lastAutoSku = '';
  Product? _existing;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory != null &&
            AppData.categories.contains(widget.initialCategory)
        ? widget.initialCategory
        : null;
    _name.addListener(_onFormChanged);
    _netWeight.addListener(_onFormChanged);
  }

  void _onFormChanged() => setState(() {});

  @override
  void dispose() {
    for (final TextEditingController c in <TextEditingController>[
      _name, _sku, _netWeight, _grossWeight, _stoneWeight, _wastage,
      _making, _purchase, _selling, _quantity, _huid, _designCode, _vendor,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _loadExistingIfNeeded() {
    if (_loaded || !widget.isEditing) return;
    _loaded = true;
    final Product? p = ref.read(productRepositoryProvider).getById(widget.productId!);
    // Missing or deleted -> leave _existing null so build() redirects.
    if (p == null || p.isDeleted) return;
    _existing = p;
    _name.text = p.name;
    _sku.text = p.uniqueId;
    _category = p.category;
    _subCategory = p.subCategory;
    _metalType = p.metalType;
    _carat = p.carat;
    _status = p.status;
    _imagePath = p.imagePath;
    _netWeight.text = p.netWeight == 0 ? '' : p.netWeight.toString();
    _grossWeight.text = p.grossWeight?.toString() ?? '';
    _stoneWeight.text = p.stoneWeight?.toString() ?? '';
    _wastage.text = p.wastage?.toString() ?? '';
    _making.text = p.makingCharges?.toString() ?? '';
    _purchase.text = p.purchasePrice?.toString() ?? '';
    _selling.text = p.sellingPrice?.toString() ?? '';
    _quantity.text = p.quantity.toString();
    _huid.text = p.huid ?? '';
    _designCode.text = p.designCode ?? '';
    _vendor.text = p.vendor ?? '';
    final bool anyAdvanced = (p.grossWeight ?? 0) > 0 ||
        (p.stoneWeight ?? 0) > 0 ||
        (p.huid ?? '').isNotEmpty ||
        (p.sellingPrice ?? 0) > 0;
    _advancedOpen = anyAdvanced;
  }

  // --- SKU -----------------------------------------------------------------

  void _maybeRegenerateSku() {
    if (widget.isEditing) return; // never regenerate in edit mode
    if (_skuManuallyEdited) return;
    if (_category == null || _carat == null) return;
    final int count = ref.read(productRepositoryProvider).getAll().length;
    final String sku = generateSku(
      category: _category!,
      carat: _carat!,
      currentProductCount: count,
    );
    _lastAutoSku = sku;
    _sku.text = sku;
  }

  // --- Image ---------------------------------------------------------------

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file =
          await _picker.pickImage(source: source, maxWidth: 1280, imageQuality: 82);
      if (file == null) return;
      final Directory dir = await getApplicationDocumentsDirectory();
      final String ext = file.path.contains('.')
          ? file.path.substring(file.path.lastIndexOf('.'))
          : '.jpg';
      final String dest =
          '${dir.path}/product_${DateTime.now().millisecondsSinceEpoch}$ext';
      await File(file.path).copy(dest);
      setState(() => _imagePath = dest);
    } on PlatformException {
      _toast('Could not access photos.');
    } catch (_) {
      _toast('Could not save the image.');
    }
  }

  void _showImageSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_imagePath != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.danger),
                title: const Text('Remove photo'),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _imagePath = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  // --- Validation ----------------------------------------------------------

  double? get _netWeightValue {
    final double? v = double.tryParse(_netWeight.text.trim());
    return v;
  }

  bool get _isValid {
    return _name.text.trim().isNotEmpty &&
        _sku.text.trim().isNotEmpty &&
        _category != null &&
        _carat != null &&
        (_netWeightValue ?? 0) > 0;
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  double? _num(TextEditingController c) {
    final String t = c.text.trim();
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  Future<void> _save() async {
    if (!_isValid) return;
    final repo = ref.read(productRepositoryProvider);
    final DateTime now = DateTime.now();
    final int qty = int.tryParse(_quantity.text.trim()) ?? 1;

    if (widget.isEditing) {
      final Product? current = _existing ?? repo.getById(widget.productId!);
      if (current == null || !repo.isActive(current.id)) {
        if (mounted) context.go(Routes.stocks);
        return;
      }
      final Product updated = current.copyWith(
        uniqueId: _sku.text.trim(),
        name: _name.text.trim(),
        category: _category,
        subCategory: _subCategory,
        clearSubCategory: _subCategory == null,
        metalType: _metalType,
        carat: _carat,
        grossWeight: _num(_grossWeight),
        netWeight: _netWeightValue,
        stoneWeight: _num(_stoneWeight),
        wastage: _num(_wastage),
        makingCharges: _num(_making),
        purchasePrice: _num(_purchase),
        sellingPrice: _num(_selling),
        quantity: qty <= 0 ? 1 : qty,
        huid: _huid.text.trim().isEmpty ? null : _huid.text.trim(),
        designCode:
            _designCode.text.trim().isEmpty ? null : _designCode.text.trim(),
        vendor: _vendor.text.trim().isEmpty ? null : _vendor.text.trim(),
        status: _status,
        imagePath: _imagePath,
        clearImagePath: _imagePath == null,
        updatedAt: now,
      );
      await repo.update(updated);
      if (mounted) context.go(Routes.product(updated.id));
    } else {
      final Product product = Product(
        id: 'temp-${now.millisecondsSinceEpoch}',
        uniqueId: _sku.text.trim(),
        name: _name.text.trim(),
        category: _category!,
        subCategory: _subCategory,
        metalType: _metalType,
        carat: _carat!,
        grossWeight: _num(_grossWeight),
        netWeight: _netWeightValue!,
        stoneWeight: _num(_stoneWeight),
        wastage: _num(_wastage),
        makingCharges: _num(_making),
        purchasePrice: _num(_purchase),
        sellingPrice: _num(_selling),
        quantity: qty <= 0 ? 1 : qty,
        huid: _huid.text.trim().isEmpty ? null : _huid.text.trim(),
        designCode:
            _designCode.text.trim().isEmpty ? null : _designCode.text.trim(),
        vendor: _vendor.text.trim().isEmpty ? null : _vendor.text.trim(),
        status: _status,
        imagePath: _imagePath,
        createdAt: now,
      );
      await repo.add(product);
      if (mounted) context.go(Routes.stocks);
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadExistingIfNeeded();

    // Editing a missing/deleted id -> redirect.
    if (widget.isEditing && _existing == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(Routes.stocks);
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final List<String> carats = AppData.caratsFor(_metalType);
    final List<String> subs = _category == null
        ? <String>[]
        : (AppData.subCategories[_category] ?? <String>[]);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Product' : 'Add Product'),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: GradientButton(
            label: widget.isEditing ? 'Save changes' : 'Save item',
            icon: Icons.check_rounded,
            expand: true,
            onPressed: _isValid ? _save : null,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: <Widget>[
          _ImagePicker(
            imagePath: _imagePath,
            category: _category ?? 'Other',
            onTap: _showImageSheet,
          ),
          const SizedBox(height: 20),

          _label('Product Name *'),
          _textField(_name, hint: 'e.g. Classic Wedding Band'),
          const SizedBox(height: 16),

          _label('Unique Number / SKU *'),
          TextField(
            controller: _sku,
            decoration: const InputDecoration(hintText: 'GLD-RNG-22K-0001'),
            onChanged: (String v) {
              if (v != _lastAutoSku) _skuManuallyEdited = true;
            },
          ),
          const SizedBox(height: 8),
          _SkuPreviewCard(sku: _sku.text),
          const SizedBox(height: 16),

          _label('Category *'),
          _dropdown<String>(
            name: 'category',
            value: _category,
            hint: 'Select category',
            items: AppData.categories,
            onChanged: (String? v) {
              setState(() {
                _category = v;
                _subCategory = null;
                _maybeRegenerateSku();
              });
            },
          ),
          const SizedBox(height: 16),

          _label('Sub Category'),
          _dropdown<String>(
            name: 'sub',
            value: _subCategory,
            hint: _category == null ? 'Select category first' : 'Select sub category',
            items: subs,
            enabled: _category != null,
            onChanged: (String? v) => setState(() => _subCategory = v),
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _label('Metal Type *'),
                    _dropdown<String>(
                      name: 'metal',
                      value: _metalType,
                      hint: 'Metal',
                      items: AppData.metals,
                      onChanged: (String? v) {
                        if (v == null) return;
                        setState(() {
                          _metalType = v;
                          final List<String> opts = AppData.caratsFor(v);
                          if (_carat == null || !opts.contains(_carat)) {
                            _carat = v == 'Silver' ? 'Silver 925' : null;
                          }
                          _maybeRegenerateSku();
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _label('Carat *'),
                    _dropdown<String>(
                      name: 'carat',
                      value: _carat,
                      hint: 'Carat',
                      items: carats,
                      onChanged: (String? v) {
                        setState(() {
                          _carat = v;
                          _maybeRegenerateSku();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _label('Weight (g) *'),
          _textField(
            _netWeight,
            hint: '0.000',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            error: (_netWeight.text.isNotEmpty && (_netWeightValue ?? 0) <= 0)
                ? 'Enter a weight greater than 0'
                : null,
          ),
          const SizedBox(height: 20),

          _AdvancedSection(
            open: _advancedOpen,
            onToggle: () => setState(() => _advancedOpen = !_advancedOpen),
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: _field('Gross weight (g)', _grossWeight,
                        decimal: true),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _field('Stone weight (g)', _stoneWeight,
                        decimal: true),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(child: _field('Wastage %', _wastage, decimal: true)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _field('Making charges', _making, decimal: true)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                      child: _field('Purchase price', _purchase, decimal: true)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _field('Selling price', _selling, decimal: true)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _field('Quantity', _quantity, decimal: false),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _label('Status'),
                        _dropdown<String>(
                          name: 'status',
                          value: _status,
                          hint: 'Status',
                          items: AppData.statuses,
                          onChanged: (String? v) =>
                              setState(() => _status = v ?? _status),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _field('HUID', _huid),
              const SizedBox(height: 12),
              _field('Design code', _designCode),
              const SizedBox(height: 12),
              _field('Vendor', _vendor),
            ],
          ),
        ],
      ),
    );
  }

  // --- small builders ------------------------------------------------------

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: AppTextStyles.label),
      );

  Widget _textField(
    TextEditingController c, {
    String? hint,
    TextInputType? keyboardType,
    String? error,
  }) {
    return TextField(
      controller: c,
      keyboardType: keyboardType,
      decoration: InputDecoration(hintText: hint, errorText: error),
    );
  }

  Widget _field(String label, TextEditingController c, {bool decimal = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _label(label),
        TextField(
          controller: c,
          keyboardType: decimal
              ? const TextInputType.numberWithOptions(decimal: true)
              : (label == 'Quantity'
                  ? TextInputType.number
                  : TextInputType.text),
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(hintText: ''),
        ),
      ],
    );
  }

  Widget _dropdown<T>({
    required String name,
    required T? value,
    required String hint,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    bool enabled = true,
  }) {
    // initialValue only seeds the field once, so we key on the value to make
    // programmatic changes (e.g. carat after a metal switch) reflect visually.
    return DropdownButtonFormField<T>(
      key: ValueKey<String>('$name:$value'),
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(hintText: hint),
      items: items
          .map((T e) => DropdownMenuItem<T>(value: e, child: Text('$e')))
          .toList(),
      onChanged: enabled ? onChanged : null,
    );
  }
}

class _SkuPreviewCard extends StatelessWidget {
  const _SkuPreviewCard({required this.sku});
  final String sku;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.navy900.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.qr_code_2_rounded, color: AppColors.gold600),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Live SKU preview', style: AppTextStyles.bodySmall),
                const SizedBox(height: 2),
                Text(
                  sku.isEmpty ? '—' : sku,
                  style: AppTextStyles.titleMedium
                      .copyWith(color: AppColors.navy900),
                ),
                Text('Format: GLD-RNG-22K-0001',
                    style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePicker extends StatelessWidget {
  const _ImagePicker({
    required this.imagePath,
    required this.category,
    required this.onTap,
  });

  final String? imagePath;
  final String category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ProductThumb(imagePath: imagePath, category: category),
            Positioned(
              right: 10,
              bottom: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.camera_alt_outlined,
                        size: 16, color: AppColors.navy900),
                    const SizedBox(width: 6),
                    Text(imagePath == null ? 'Add photo' : 'Change photo',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.navy900,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdvancedSection extends StatelessWidget {
  const _AdvancedSection({
    required this.open,
    required this.onToggle,
    required this.children,
  });

  final bool open;
  final VoidCallback onToggle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: onToggle,
            leading: const Icon(Icons.tune_rounded, color: AppColors.navy800),
            title: Text('Advanced details', style: AppTextStyles.titleMedium),
            trailing: Icon(open ? Icons.expand_less : Icons.expand_more),
          ),
          if (open)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(children: children),
            ),
        ],
      ),
    );
  }
}
