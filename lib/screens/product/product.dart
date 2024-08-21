import 'package:flutter/material.dart';
import 'package:admin_panel/myDio.dart';
import 'package:admin_panel/models/product.dart';
import 'package:admin_panel/models/category.dart';

import '../../Utils/Constants.dart';

class ProductScreen extends StatefulWidget {
  final String categoryId; // Category ID for context

  const ProductScreen({Key? key, required this.categoryId}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> products = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await MyDio()
          .get('${Server.url}/api/products/category/${widget.categoryId}');
      final List<dynamic> data = response.data;
      setState(() {
        products = data.map((json) => Product.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load products.';
      });
      print(e);
    }
  }

  Future<void> _addProduct() async {
    final nameController = TextEditingController();
    final wholesalePriceController = TextEditingController();
    final retailPriceController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: wholesalePriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Wholesale Price'),
              ),
              TextField(
                controller: retailPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Retail Price'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final name = nameController.text;
                final wholesalePrice =
                    double.tryParse(wholesalePriceController.text) ?? 0;
                final retailPrice =
                    double.tryParse(retailPriceController.text) ?? 0;
                if (name.isNotEmpty) {
                  try {
                    await MyDio().post('${Server.url}/api/products', data: {
                      'name': name,
                      'category': widget.categoryId,
                      'variants': [
                        {
                          'wholesalePrice': wholesalePrice,
                          'retailPrice': retailPrice,
                        }
                      ],
                      'images': [], // Add images if necessary
                    });
                    fetchProducts(); // Refresh products
                    Navigator.of(context).pop();
                  } catch (e) {
                    print(e);
                  }
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editProduct(Product product) async {
    final nameController = TextEditingController(text: product.name);
    final wholesalePriceController = TextEditingController(
        text: product.variants.isNotEmpty
            ? product.variants[0].wholesalePrice.toString()
            : '');
    final retailPriceController = TextEditingController(
        text: product.variants.isNotEmpty
            ? product.variants[0].retailPrice.toString()
            : '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: wholesalePriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Wholesale Price'),
              ),
              TextField(
                controller: retailPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Retail Price'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final name = nameController.text;
                final wholesalePrice =
                    double.tryParse(wholesalePriceController.text) ?? 0;
                final retailPrice =
                    double.tryParse(retailPriceController.text) ?? 0;
                if (name.isNotEmpty) {
                  try {
                    await MyDio()
                        .put('${Server.url}/api/products/${product.id}', data: {
                      'name': name,
                      'category': product.category,
                      'variants': [
                        {
                          'wholesalePrice': wholesalePrice,
                          'retailPrice': retailPrice,
                        }
                      ],
                      'images': product.images, // Add images if necessary
                    });
                    fetchProducts(); // Refresh products
                    Navigator.of(context).pop();
                  } catch (e) {
                    print(e);
                  }
                }
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(String productId) async {
    try {
      await MyDio().delete('${Server.url}/api/products/$productId');
      fetchProducts(); // Refresh products
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8.0),
                        title: Text(product.name),
                        subtitle: Text(
                            'Price: \$${product.variants.isNotEmpty ? product.variants[0].retailPrice : 'N/A'}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editProduct(product),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteProduct(product.id),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Optionally, navigate to a detailed product view
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
}
