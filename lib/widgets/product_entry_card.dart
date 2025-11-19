import 'package:flutter/material.dart';
import 'package:football_shop_mobile/models/product_entry.dart';

class ProductEntryCard extends StatelessWidget {
  final ProductEntry product;
  final VoidCallback onTap;

  const ProductEntryCard({super.key, required this.product, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    'http://localhost:8000/proxy-image/?url=${Uri.encodeComponent(product.fields.thumbnail)}',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Name
                Text(
                  product.fields.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                // Category + Brand
                Row(
                  children: [
                    Text(
                      "Category: ${product.fields.category}",
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(width: 12),
                    if (product.fields.brand != null)
                      Text(
                        "Brand: ${product.fields.brand}",
                        style: const TextStyle(fontSize: 13),
                      ),
                  ],
                ),

                const SizedBox(height: 6),

                // Price
                Text(
                  "Rp ${product.fields.price}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 6),

                // Description preview
                Text(
                  product.fields.description.length > 100
                      ? '${product.fields.description.substring(0, 100)}...'
                      : product.fields.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54),
                ),

                const SizedBox(height: 6),

                // Stock
                Text(
                  "Stock: ${product.fields.stock}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                // Featured badge
                if (product.fields.isFeatured)
                  const Text(
                    "FEATURED",
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
