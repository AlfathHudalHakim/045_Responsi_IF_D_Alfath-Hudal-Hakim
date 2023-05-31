import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'list.dart';

class Category {
  String strCategory;
  String strCategoryThumb;

  Category({required this.strCategory, required this.strCategoryThumb});
}

class Kategori extends StatefulWidget {
  @override
  _KategoriState createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> {
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));
    final data = json.decode(response.body);
    List<Category> fetchedCategories = [];
    for (var category in data['categories']) {
      fetchedCategories.add(
        Category(
          strCategory: category['strCategory'],
          strCategoryThumb: category['strCategoryThumb'],
        ),
      );
    }
    setState(() {
      categories = fetchedCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategori Makanan'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListMakananPage(category: categories[index].strCategory),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                children: [
                  Image.network(categories[index].strCategoryThumb,
                    height: 50,),
                  Text(
                    categories[index].strCategory,
                    style: TextStyle(fontSize: 16.0),
                  ),

                ],
              )
              
            ),
          );
        },
      ),
    );
  }

}