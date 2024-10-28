import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ReviewFormScreen extends StatefulWidget {
  final int restaurantId;

  ReviewFormScreen({required this.restaurantId});

  @override
  _ReviewFormScreenState createState() => _ReviewFormScreenState();
}

class _ReviewFormScreenState extends State<ReviewFormScreen> {
  final TextEditingController commentController = TextEditingController();
  int rating = 0;
  Map<String, dynamic>? restaurantDetails;

  @override
  void initState() {
    super.initState();
    fetchRestaurantDetails();
  }

  Future<void> fetchRestaurantDetails() async {
    restaurantDetails = await ApiService.fetchRestaurantDetails(widget.restaurantId);
    setState(() {});
  }

  Future<void> submitReview() async {
    bool success = await ApiService.submitReview(
      widget.restaurantId,
      rating,
      commentController.text,
    );

    if (success) {
      Navigator.pop(context);
    } else {
      print('Failed to submit review');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Write a Review')),
      body: restaurantDetails == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    restaurantDetails!['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Image.network(restaurantDetails!['imageUrl'], height: 150, fit: BoxFit.cover),
                  SizedBox(height: 10),
                  Text(restaurantDetails!['description']),
                  SizedBox(height: 20),
                  Text('Rating:'),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(index < rating ? Icons.star : Icons.star_border),
                        onPressed: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  TextField(
                    controller: commentController,
                    decoration: InputDecoration(labelText: 'Comment'),
                    maxLines: 3,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: submitReview,
                    child: Text('Submit Review'),
                  ),
                ],
              ),
            ),
    );
  }
}
