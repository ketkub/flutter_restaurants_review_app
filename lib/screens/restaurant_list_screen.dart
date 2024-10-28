import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'review_form_screen.dart';

class RestaurantListScreen extends StatefulWidget {
  @override
  _RestaurantListScreenState createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  List<dynamic> restaurants = [];

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    restaurants = await ApiService.fetchRestaurants();
    setState(() {});
  }

  void handleRestaurantTap(int restaurantId) {
    if (User.userId == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      ).then((_) {
        if (User.userId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReviewFormScreen(restaurantId: restaurantId)),
          );
        }
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReviewFormScreen(restaurantId: restaurantId)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Restaurants')),
      body: restaurants.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                return Card(
                  child: GestureDetector(
                    onTap: () => handleRestaurantTap(restaurants[index]['id']),
                    child: Column(
                      children: [
                        Image.network(
                          restaurants[index]['imageUrl'],
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            restaurants[index]['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(restaurants[index]['location'], textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
