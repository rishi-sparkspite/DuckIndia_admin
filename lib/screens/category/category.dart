import 'package:flutter/material.dart';
import 'package:admin_panel/myDio.dart';
import 'package:admin_panel/models/category.dart';
import '../product/product.dart'; // Assuming ProductScreen is imported here

import '../../Utils/Constants.dart';

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
                  children: categories.map((category) {
                    return ListTile(
                      title: Text(category.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteCategory(category.id),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductScreen(categoryId: category.id),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        child: const Icon(Icons.add),
      ),
    );
  }
}
