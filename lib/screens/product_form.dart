import 'package:flutter/material.dart';
import 'package:football_shop_mobile/widgets/left_drawer.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:football_shop_mobile/screens/menu.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _thumbnailController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  bool _isFeatured = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    _stockController.dispose();
    _brandController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  // Validasi URL sederhana
  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return (uri.hasScheme &&
              (uri.scheme == 'http' || uri.scheme == 'https')) &&
          uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _thumbnailController.clear();
    _stockController.clear();
    _brandController.clear();
    _categoryController.clear();
    setState(() {
      _isFeatured = false;
    });
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final price = double.parse(_priceController.text.trim());
    final description = _descriptionController.text.trim();
    final thumbnail = _thumbnailController.text.trim();
    final stock = int.parse(_stockController.text.trim());
    final brand = _brandController.text.trim();
    final category = _categoryController.text.trim();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Produk berhasil disimpan'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: $name'),
                const SizedBox(height: 6),
                Text('Price: Rp ${price.toStringAsFixed(2)}'),
                const SizedBox(height: 6),
                Text('Description: $description'),
                const SizedBox(height: 6),
                Text('Thumbnail: $thumbnail'),
                const SizedBox(height: 6),
                Text('Category: $category'),
                const SizedBox(height: 6),
                Text('Brand: $brand'),
                const SizedBox(height: 6),
                Text('Stock: $stock'),
                const SizedBox(height: 6),
                Text('Featured: ${_isFeatured ? "Ya" : "Tidak"}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetForm();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Tambah Produk'),
        backgroundColor: Colors.indigo,
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // name -> matches Django TextInput
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Nama produk tidak boleh kosong';
                  if (v.length < 3) return 'Nama minimal 3 karakter';
                  if (v.length > 100) return 'Nama maksimal 100 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // price -> matches Django NumberInput
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  hintText: 'Masukkan harga (angka, contoh: 120000)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Price tidak boleh kosong';
                  final parsed = double.tryParse(v);
                  if (parsed == null) return 'Price harus berupa angka';
                  if (parsed <= 0) return 'Price harus lebih besar dari 0';
                  if (parsed > 1000000000) return 'Price terlalu besar';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // description -> matches Django Textarea (rows:4)
              TextFormField(
                controller: _descriptionController,
                minLines: 4,
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Description tidak boleh kosong';
                  if (v.length < 10) return 'Description minimal 10 karakter';
                  if (v.length > 2000) return 'Description terlalu panjang';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // thumbnail -> matches Django URLInput
              TextFormField(
                controller: _thumbnailController,
                decoration: InputDecoration(
                  labelText: 'Thumbnail URL',
                  hintText: 'https://example.com/image.jpg',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Thumbnail tidak boleh kosong';
                  if (!_isValidUrl(v))
                    return 'Thumbnail harus berupa URL valid (http/https)';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // category -> matches Django TextInput
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Category tidak boleh kosong';
                  if (v.length > 50) return 'Category terlalu panjang';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // is_featured -> matches Django CheckboxInput (form-check-input)
              CheckboxListTile(
                title: const Text('Tandai sebagai Featured'),
                value: _isFeatured,
                onChanged: (v) => setState(() => _isFeatured = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 12),

              // stock -> matches Django NumberInput
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(
                  labelText: 'Stock',
                  hintText: 'Jumlah stok (contoh: 10)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Stock tidak boleh kosong';
                  final parsed = int.tryParse(v);
                  if (parsed == null)
                    return 'Stock harus berupa bilangan bulat';
                  if (parsed < 0) return 'Stock tidak boleh negatif';
                  if (parsed > 10000000) return 'Stock terlalu besar';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // brand -> matches Django TextInput
              TextFormField(
                controller: _brandController,
                decoration: InputDecoration(
                  labelText: 'Brand',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Brand tidak boleh kosong';
                  if (v.length < 2) return 'Brand minimal 2 karakter';
                  if (v.length > 100) return 'Brand terlalu panjang';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Replace the URL with your app's URL
                      // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
                      // If you using chrome,  use URL http://localhost:8000
                      final String name = _nameController.text.trim();
                      final String priceText = _priceController.text.trim();
                      final String description = _descriptionController.text
                          .trim();
                      final String thumbnail = _thumbnailController.text.trim();
                      final String category = _categoryController.text.trim();
                      final String brand = _brandController.text.trim();
                      final String stockText = _stockController.text.trim();
                      final bool isFeatured = _isFeatured;

                      final String url =
                          "http://localhost:8000/create-flutter/";

                      final response = await request.postJson(
                        url,
                        jsonEncode({
                          "name": name,
                          "price": priceText,
                          "description": description,
                          "thumbnail": thumbnail,
                          "category": category,
                          "is_featured": isFeatured,
                          "stock": stockText,
                          "brand": brand,
                        }),
                      );

                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("News successfully saved!"),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Something went wrong, please try again.",
                              ),
                            ),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
