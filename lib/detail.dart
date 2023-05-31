import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class DetailMakananPage extends StatefulWidget {
  final Map<String, dynamic> food;

  DetailMakananPage({required this.food});

  @override
  _DetailMakananPageState createState() => _DetailMakananPageState();
}

class _DetailMakananPageState extends State<DetailMakananPage> {
  Map<String, dynamic> foodDetails = {};

  @override
  void initState() {
    super.initState();
    fetchFoodDetails();
  }

  void fetchFoodDetails() {
    http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=${widget.food['strMeal']}'))
        .then((response) {
      final data = json.decode(response.body);
      setState(() {
        foodDetails = data['meals'][0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Detail Makanan'),
      ),
      body: foodDetails.isNotEmpty
          ? SingleChildScrollView(
        child: Column(
          children: [
            Image.network(foodDetails['strMealThumb']),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    foodDetails['strMeal'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(foodDetails['strInstructions']),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      launch(foodDetails['strYoutube']);
                    },
                    child: Text('Lihat Video di YouTube'),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
