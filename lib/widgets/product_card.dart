import 'package:flutter/material.dart';
import 'package:football_shop_mobile/screens/product_form_page.dart';

class ProductItem {
    final String title;
    final String category;
    final String thumbnail;
    final bool isFeatured;

    ProductItem({required this.title, required this.category, this.thumbnail = '', this.isFeatured = false});
}

class ProductCard extends StatelessWidget {
final ProductItem item;
const ProductCard({super.key, required this.item});


    @override
    Widget build(BuildContext context) {
        return Card(
            child: InkWell(
                onTap: () {
                    ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("Kamu telah menekan: ${item.title}")));
                },
                child: Padding(
                padding: const EdgeInsets.all(12.0),
                    child: Row(
                        children: [
                            if (item.thumbnail.isNotEmpty)
                                Image.network(item.thumbnail, width: 80, height: 80, fit: BoxFit.cover)
                            else
                                Container(width: 80, height: 80, color: Colors.grey[300], child: const Icon(Icons.image, size: 40)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(item.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 6),
                                        Text(item.category),
                                        if (item.isFeatured) const SizedBox(height: 6),
                                        if (item.isFeatured) const Chip(label: Text('Unggulan')),
                                    ],
                                ),
                            )
                        ],
                    ),
                ),
            ),
        );
    }
}