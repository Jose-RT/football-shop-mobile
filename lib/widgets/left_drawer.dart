import 'package:flutter/material.dart';
import 'package:football_shop_mobile/screens/menu.dart';
import 'package:football_shop_mobile/screens/product_form_page.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

    @override
    Widget build(BuildContext context) {
        return Drawer(
            child: ListView(
                padding: EdgeInsets.zero,
                children: [
                    const DrawerHeader(
                        decoration: BoxDecoration(color: Colors.blue),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text('Football Shop', style: TextStyle(fontSize: 24, color: Colors.white)),
                            SizedBox(height: 8),
                            Text('Toko merchandise sepak bola', style: TextStyle(color: Colors.white)),
                            ],
                        ),
                    ),
                    ListTile(
                        leading: const Icon(Icons.home),
                        title: const Text('Halaman Utama'),
                        onTap: () {
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
                            Navigator.pop(context); // close drawer
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