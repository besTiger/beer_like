import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'beer_model.dart';

class BeerSearchScreen extends StatefulWidget {
  @override
  _BeerSearchScreenState createState() => _BeerSearchScreenState();
}

class _BeerSearchScreenState extends State<BeerSearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Beer> _searchResults = [];

  void _searchBeers() async {
    final String baseUrl = 'https://api.punkapi.com/v2/beers';
    final String query = _searchController.text;

    if (query.isEmpty) {
      return;
    }

    final String url = '$baseUrl?beer_name=$query';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);
        List<Beer> beers = responseData.map((beerData) => Beer.fromJson(beerData)).toList();

        setState(() {
          _searchResults = beers;
        });
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Punk API Beer Search'),
        backgroundColor: Colors.indigo, // Змінено колір панелі
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.indigo, // Змінено колір контейнера
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for beer...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchBeers,
                ),
                filled: true,
                fillColor: Colors.white, // Змінено колір фону текстового поля
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                Beer beer = _searchResults[index];

                return Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: beer.imageUrl.isNotEmpty
                            ? Image.network(
                          beer.imageUrl,
                          fit: BoxFit.cover,
                        )
                            : Container(
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              beer.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(beer.tagline),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}