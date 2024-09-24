import 'package:flutter/material.dart';
import 'package:admin_panel/myDio.dart';
import 'package:admin_panel/models/product.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../Utils/Constants.dart';

class ProductScreen extends StatefulWidget {
  final String categoryId;

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

  Future<List<File>> pickImagesForWeb() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) {
      return result.files
          .take(5)
          .map((pickedFile) => File(pickedFile.path!))
          .toList();
    }
    return [];
  }

  Future<String> uploadImage(File image) async {
    try {
      final response = await MyDio().post('${Server.url}/api/upload', data: {
        'file': image, 
      });
      return response?.data['url']; 
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<void> _addProduct() async {
    final nameController = TextEditingController();
    final wholesalePriceController = TextEditingController();
    final retailPriceController = TextEditingController();
    List<File> selectedImages = [];
    List<String> uploadedImageUrls = [];

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Product'),
              content: SingleChildScrollView(
                child: Column(
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
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final images = await pickImagesForWeb();
                        setState(() {
                          selectedImages.addAll(images);
                        });
                      },
                      child: const Text('Pick Images'),
                    ),
                    Wrap(
                      spacing: 8,
                      children: selectedImages.map((image) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Image.file(
                              image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  selectedImages.remove(image);
                                });
                              },
                            )
                          ],
                        );
                      }).toList(),
                    ),
                   
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                     if (selectedImages.isNotEmpty) {
                          for (var image in selectedImages) {
                            String uploadedUrl = await uploadImage(image);
                            if (uploadedUrl.isNotEmpty) {
                              uploadedImageUrls.add(uploadedUrl);
                            }
                          }
                        }
                    final name = nameController.text;
                    final wholesalePrice = double.tryParse(wholesalePriceController.text) ?? 0;
                    final retailPrice = double.tryParse(retailPriceController.text) ?? 0;
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
                          'images': uploadedImageUrls, 
                        });
                        fetchProducts(); 
                        Navigator.of(context).pop();
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: const Text('Add Product'),
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
      },
    );
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
                              onPressed: () {
                                // Edit product functionality
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // Delete product functionality
                              },
                            ),
                          ],
                        ),
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