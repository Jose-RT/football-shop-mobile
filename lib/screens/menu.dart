import 'package:flutter/material.dart';
import 'package:football_shop_mobile/widgets/left_drawer.dart';
import 'package:football_shop_mobile/widgets/product_entry_card.dart';
import 'package:football_shop_mobile/screens/product_form.dart';

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
            drawer: const LeftDrawer(),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                ElevatedButton.icon(
                    onPressed: () => _showSnackBar(context, 'Kamu telah menekan tombol All Products'),
                    icon: const Icon(Icons.list),
                    label: const Text('All Products'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                    ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                    onPressed: () => _showSnackBar(context, 'Kamu telah menekan tombol My Products'),
                    icon: const Icon(Icons.person),
                    label: const Text('My Products'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                    ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                    onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProductFormPage()),
                        );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Product'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
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