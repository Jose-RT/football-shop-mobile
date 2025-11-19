import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:football_shop_mobile/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(const FootballShopApp());

class FootballShopApp extends StatelessWidget {
  const FootballShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Football Shop',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.red,
        ),
      home: const LoginPage(),
      ),
    );
  }
}

/// HomePage dengan drawer dan tombol-tombol utama
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Football Shop'),
        centerTitle: true,
      ),
      drawer: _LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () =>
                  _showSnackBar(context, 'Kamu telah menekan tombol All Products'),
              icon: const Icon(Icons.list),
              label: const Text('All Products'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // biru
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () =>
                  _showSnackBar(context, 'Kamu telah menekan tombol My Products'),
              icon: const Icon(Icons.person),
              label: const Text('My Products'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // hijau
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to product form page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductFormPage()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // merah
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Drawer widget yang memenuhi syarat: Home & Tambah Produk
class _LeftDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Football Shop',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Halaman Utama'),
            onTap: () {
              // Kembali ke home (replace current)
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Tambah Produk'),
            onTap: () {
              Navigator.pop(context); // tutup drawer dulu
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductFormPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Halaman form tambah produk
class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();

  // controllers untuk kemudahan reset dan akses nilai
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _thumbnailController = TextEditingController();

  // opsi kategori (sesuaikan dengan model Django mu jika perlu)
  final List<String> _categories = [
    'jersey',
    'boots',
    'ball',
    'accessory',
    'training',
  ];
  String _selectedCategory = 'jersey';
  bool _isFeatured = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  // Validasi URL sederhana menggunakan Uri
  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https')) && uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Panggil saat Save ditekan dan form valid
  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final price = double.parse(_priceController.text.trim());
    final description = _descriptionController.text.trim();
    final thumbnail = _thumbnailController.text.trim();
    final category = _selectedCategory;
    final isFeatured = _isFeatured;

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
                Text('Featured: ${isFeatured ? "Ya" : "Tidak"}'),
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

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _thumbnailController.clear();
    setState(() {
      _selectedCategory = _categories.first;
      _isFeatured = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Tambah Produk'),
        backgroundColor: Colors.indigo,
      ),
      drawer: _LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Nama produk',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
                ),
                // validasi non-empty + panjang
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Nama produk tidak boleh kosong';
                  if (v.length < 3) return 'Nama minimal 3 karakter';
                  if (v.length > 100) return 'Nama maksimal 100 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Price
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price (contoh: 120000)',
                  hintText: 'Masukkan harga (angka)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Price tidak boleh kosong';
                  final parsed = double.tryParse(v);
                  if (parsed == null) return 'Price harus berupa angka (contoh: 120000)';
                  if (parsed <= 0) return 'Price harus lebih besar dari 0';
                  if (parsed > 1000000000) return 'Price terlalu besar';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Description
              TextFormField(
                controller: _descriptionController,
                minLines: 3,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Deskripsi produk',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Description tidak boleh kosong';
                  if (v.length < 10) return 'Description minimal 10 karakter';
                  if (v.length > 1000) return 'Description terlalu panjang';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Thumbnail (URL)
              TextFormField(
                controller: _thumbnailController,
                decoration: InputDecoration(
                  labelText: 'Thumbnail URL',
                  hintText: 'https://example.com/image.jpg',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Thumbnail tidak boleh kosong';
                  if (!_isValidUrl(v)) return 'Thumbnail harus berupa URL valid (http/https)';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Category (dropdown)
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
                ),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c[0].toUpperCase() + c.substring(1))))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value ?? _categories.first;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Pilih category';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Is Featured (switch)
              SwitchListTile(
                title: const Text('Tandai sebagai Featured'),
                value: _isFeatured,
                onChanged: (v) => setState(() => _isFeatured = v),
              ),
              const SizedBox(height: 12),

              // Save button
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
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
