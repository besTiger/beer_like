import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'beer_model.dart';
import 'details_beer_screen.dart';


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
        List<Beer> beers = responseData.map((beerData) =>
            Beer.fromJson(beerData)).toList();

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
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.indigo,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for beer...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchBeers,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                Beer beer = _searchResults[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(beer: beer),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    height: 140.0,
                    decoration: BoxDecoration(
                      color: Colors.indigo[100],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80.0,
                          height: 130,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              beer.imageUrl,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  beer.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  beer.tagline,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  beer.description,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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