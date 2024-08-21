import 'package:admin_panel/Utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel/myDio.dart';

import '../../MyCachedNetworkWidget.dart';
import '../../models/banner.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});

  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  List<BannerModel> banners = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    try {
      final response = await MyDio().get('${Server.url}/api/banners');
      final List<dynamic> data = response.data;
      setState(() {
        banners = data.map((json) => BannerModel.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load banners.';
      });
      print(e);
    }
  }

  Future<void> _addBanner() async {
    final imageUrlController = TextEditingController();
    final categoryController = TextEditingController(); // Optional

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add BannerModel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              TextField(
                controller: categoryController,
                decoration:
                    const InputDecoration(labelText: 'Category ID (Optional)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final imageUrl = imageUrlController.text;
                final categoryId = categoryController.text;
                if (imageUrl.isNotEmpty) {
                  try {
                    await MyDio().post('${Server.url}/api/banners', data: {
                      'imageUrl': imageUrl,
                      'category': categoryId.isNotEmpty ? categoryId : null,
                    });
                    fetchBanners(); // Refresh banners
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

  Future<void> _deleteBanner(String bannerId) async {
    try {
      await MyDio().delete('${Server.url}/api/banners/$bannerId');
      fetchBanners(); // Refresh banners
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Banners')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    final banner = banners[index];
                    return ListTile(
                      leading: MyCachedNetworkWidget(
                          imageUrl: banner.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover),
                      title: Text(banner.id),
                      subtitle: banner.category != null
                          ? Text('Category: ${banner.category?.id}')
                          : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteBanner(banner.id),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBanner,
        child: const Icon(Icons.add),
      ),
    );
  }
}
