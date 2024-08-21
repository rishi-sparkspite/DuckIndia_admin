import 'package:flutter/material.dart';
import 'package:admin_panel/myDio.dart';
import 'package:admin_panel/models/category.dart';

import '../../Utils/Constants.dart';
import '../../models/product.dart';
import '../product/product.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Category> categories = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await MyDio().get('${Server.url}/api/categories');
      final List<dynamic> data = response.data;
      setState(() {
        categories = data.map((json) => Category.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load categories.';
      });
      print(e);
    }
  }

  Future<void> _addCategory() async {
    final nameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final name = nameController.text;
                if (name.isNotEmpty) {
                  try {
                    await MyDio().post('${Server.url}/api/categories',
                        data: {'name': name});
                    fetchCategories(); // Refresh categories
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

  Future<void> _deleteCategory(String categoryId) async {
    try {
      await MyDio().delete('${Server.url}/api/categories/$categoryId');
      fetchCategories(); // Refresh categories
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView(
                  children: categories
                      .map((category) => CategoryTile(
                          category: category, onDelete: _deleteCategory))
                      .toList(),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CategoryTile extends StatefulWidget {
  final Category category;
  final Future<void> Function(String) onDelete;

  const CategoryTile({Key? key, required this.category, required this.onDelete})
      : super(key: key);

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  bool _expanded = false;
  List<Product> _products = [];
  bool _loadingProducts = false;

  Future<void> _toggleExpand() async {
    if (_expanded) {
      setState(() {
        _expanded = false;
        _products = [];
      });
    } else {
      setState(() {
        _loadingProducts = true;
      });
      _products = await fetchProducts();
      setState(() {
        _expanded = true;
        _loadingProducts = false;
      });
    }
  }

  Future<List<Product>> fetchProducts() async {
    return await fetchProductsByCategory(widget.category.id);
  }

  Future<List<Product>> fetchProductsByCategory(String categoryId) async {
    try {
      final response =
          await MyDio().get('${Server.url}/api/products/category/$categoryId');
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.category.name),
      onExpansionChanged: (expanded) {
        if (expanded) {
          _toggleExpand();
        }
      },
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => widget.onDelete(widget.category.id),
      ),
      children: _loadingProducts
          ? [const Center(child: CircularProgressIndicator())]
          : _products.isEmpty
              ? [const ListTile(title: Text('No products found.'))]
              : _products
                  .map((product) => ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductScreen(
                                categoryId: widget.category.id,
                              ),
                            ),
                          );
                        },
                        title: Text(product.name),
                        subtitle: Text(
                            'Price: \$${product.variants.isNotEmpty ? product.variants[0].retailPrice : 'N/A'}'),
                      ))
                  .toList(),
    );
  }
}
