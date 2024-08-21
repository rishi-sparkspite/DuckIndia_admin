import 'package:admin_panel/screens/product/product.dart';
import 'package:flutter/material.dart';
import '../Utils/Constants.dart';
import '../Utils/Essentials.dart';
import 'banner/banner.dart';
import 'category/category.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> pages = [
    {'type': "categories", "name": "Categories", 'icon': Icons.category},
    // {
    //   'type': "products",
    //   "name": "Products",
    //   'icon': Icons.production_quantity_limits
    // },
    {'type': "banners", "name": "Banners", 'icon': Icons.image},
    {'type': "logout", "name": "Logout", 'icon': Icons.exit_to_app},
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (selectedIndex == 0) ? Colors.black : Colors.transparent,
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.menuColor,
              ),
              child: Column(
                children: [
                  Essentials.heightSpacer(20),
                  // Center(
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(20),
                  //     child: Image.asset(
                  //       'assets/Icons/panda_icon.svg',
                  //       width: 100,
                  //     ),
                  //   ),
                  // ),
                  Essentials.heightSpacer(50),
                  ...List.generate(pages.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading:
                            Icon(pages[index]['icon'], color: Colors.white),
                        title: Essentials.myText(
                            context: context,
                            title: pages[index]['name'],
                            color: Colors.white,
                            textAlign: TextAlign.left),
                        onTap: () async {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        selected: index == selectedIndex,
                        selectedTileColor: Colors.lightBlue,
                      ),
                    );
                  }).toList(),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 20),
                    child: ListTile(
                        leading: const Icon(Icons.exit_to_app,
                            color: Color(0xff909497)),
                        title: Essentials.myText(
                            context: context,
                            title: 'Logout',
                            color: const Color(0xff909497),
                            textAlign: TextAlign.left),
                        onTap: () async {
                          // await FirebaseAuth.instance.signOut();
                          // await AuthMiddleware().update();
                          Navigator.pushReplacementNamed(context, "/");
                        }),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: PageNavigator(
              selectedIndex: selectedIndex,
            ),
          ),
        ],
      ),
    );
  }
}

class PageNavigator extends StatefulWidget {
  final int selectedIndex;

  const PageNavigator({Key? key, required this.selectedIndex})
      : super(key: key);

  @override
  _PageNavigatorState createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  @override
  Widget build(BuildContext context) {
    Widget pageWidget;

    switch (widget.selectedIndex) {
      case 0:
        pageWidget = const CategoryScreen();
        break;
      case 1:
        pageWidget = const BannerScreen();
        break;
      // case 2:
      //   pageWidget = const BannerScreen();
      //   break;
      case 3:
        // Handle logout here if needed
        pageWidget = Container();
        break;
      default:
        pageWidget = Container();
    }

    return pageWidget;
  }
}
