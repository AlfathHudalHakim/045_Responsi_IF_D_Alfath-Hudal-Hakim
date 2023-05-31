import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail.dart';

class ListMakananPage extends StatefulWidget {
  final String category;

  ListMakananPage({required this.category});

  @override
  _ListMakananPageState createState() => _ListMakananPageState();
}

class _ListMakananPageState extends State<ListMakananPage> {
  List<Map<String, dynamic>> foods = [];

  @override
  void initState() {
    super.initState();
    fetchFoods();
  }

  void fetchFoods() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.category}'));
    final data = json.decode(response.body);
    setState(() {
      foods = List<Map<String, dynamic>>.from(data['meals']);
    });
  }

  String truncateString(String text, int length) {
    if (text.length <= length) {
      return text;
    }
    return text.substring(0, length) + '...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman List Makanan'),
      ),
      body: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final mealName = truncateString(foods[index]['strMeal'], 25);
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailMakananPage(food: foods[index]),
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
                    Image.network(
                      foods[index]['strMealThumb'],
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        mealName,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
