import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_apk/api/api.dart';
import 'package:grocery_apk/models/banner.dart';
import 'package:grocery_apk/models/product.dart';
import 'package:grocery_apk/screens/catagoray_screen.dart';
import 'package:grocery_apk/screens/product_screen.dart';
import 'package:grocery_apk/themes/theme_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_apk/widget/product_card.dart';

class HomeScreenBottomNavigation extends StatefulWidget {
  const HomeScreenBottomNavigation({
    Key? key,
  });

  @override
  State<HomeScreenBottomNavigation> createState() =>
      _HomeScreenBottomNavigationState();
}

class _HomeScreenBottomNavigationState
    extends State<HomeScreenBottomNavigation> {
  TextEditingController _textController = TextEditingController();
  String selectedCategory = '';
  String searchQuery = '';
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HashColorCodes.green,
        title: _isSearching
            ? _buildSearchField()
            : Text(
                "Grocery App",
                style: TextStyle(
                  fontFamily: 'Sarala',
                  color: HashColorCodes.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.bell_fill,
              color: HashColorCodes.white,
            ),
          ),
          IconButton(
              icon: Icon(
                _isSearching ? Icons.close : Icons.search,
                color: HashColorCodes.white,
              ),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _textController.clear();
                    searchQuery = '';
                  }
                });
              })
        ],
      ),
      body: _isSearching ? _buildSearchResults() : _buildHomeScreen(),
    );
  }

  Widget _buildSearchField() {
    return CupertinoTextField(
      controller: _textController,
      placeholder: 'Search Item...',
      onChanged: (value) {
        setState(() {
          searchQuery = value.toLowerCase();
        });
      },
    );
  }

  Widget _buildHomeScreen() {
    return FutureBuilder<List<Carousal>>(
      future: APIs.getCarousal(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Carousal> carousels = snapshot.data ?? [];
          log("Carousels length: ${carousels.length}");

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                CarouselSlider(
                  options: CarouselOptions(height: 175.0),
                  items: carousels.map((carousel) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: carousel.imgurl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                    color: HashColorCodes.green,
                                  )),
                                  errorWidget: (context, url, error) {
                                    // log("Image URL (Error): $url");
                                    return Icon(Icons.error);
                                  },
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 16.0,
                                bottom: 16.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      carousel.title,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: HashColorCodes.green,
                                      ),
                                    ),
                                    Text(
                                      carousel.description,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: HashColorCodes.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Explore by Categories",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => CatagoriScreen()));
                          },
                          child: Text(
                            "view all",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: HashColorCodes.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildCategoryButton(
                        'vegetables', 'images/Icon_vegetables.png'),
                    buildCategoryButton('fruits', 'images/Icon_fruits.png'),
                    buildCategoryButton('dairy', 'images/Icon_cheese.png'),
                    buildCategoryButton('bakery', 'images/Icon_bread.png'),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: HashColorCodes.green,
                      ));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Product> products = snapshot.data!.docs
                          .map((doc) => Product.fromDocumentSnapshot(doc))
                          .toList();

                      List<Product> filteredProducts =
                          selectedCategory.isNotEmpty
                              ? products
                                  .where((product) =>
                                      product.category == selectedCategory)
                                  .toList()
                              : products;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              log('Selected Product: ${filteredProducts[index].id}');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductScreen(
                                    product: filteredProducts[index],
                                  ),
                                ),
                              );
                            },
                            child: ProductCard(
                              product: filteredProducts[index],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildSearchResults() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: HashColorCodes.green,
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Product> products = snapshot.data!.docs
              .map((doc) => Product.fromDocumentSnapshot(doc))
              .toList();

          List<Product> searchResults = products
              .where((product) =>
                  product.name.toLowerCase().contains(searchQuery) ||
                  product.category.toLowerCase().contains(searchQuery))
              .toList();

          if (searchResults.isEmpty) {
            return Center(
              child: Text('No items found'),
            );
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  log('Selected Product: ${searchResults[index].id}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductScreen(
                        product: searchResults[index],
                      ),
                    ),
                  );
                },
                child: ProductCard(
                  product: searchResults[index],
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget buildCategoryButton(String categoryName, String imagePath) {
    bool isSelected = selectedCategory == categoryName;
    return InkWell(
      onTap: () {
        setState(() {
          selectedCategory = isSelected ? '' : categoryName;
        });
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.green : Colors.grey,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 40,
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
