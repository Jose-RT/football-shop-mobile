import 'package:flutter/material.dart';


void main() => runApp(const FootballShopApp());


class FootballShopApp extends StatelessWidget {
    const FootballShopApp({super.key});


    @override
    Widget build(BuildContext context) {
        return MaterialApp(
        title: 'Football Shop',
        theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        );
    }
}


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
                            backgroundColor: Colors.blue, // biru
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
                            backgroundColor: Colors.green, // hijau
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: const TextStyle(fontSize: 16),
                        ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                        onPressed: () => _showSnackBar(context, 'Kamu telah menekan tombol Create Product'),
                        icon: const Icon(Icons.add),
                        label: const Text('Create Product'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // merah
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