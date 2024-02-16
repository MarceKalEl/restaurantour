import 'package:flutter/material.dart';
import 'package:restaurantour/repositories/yelp_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Restaurantour'),
            ElevatedButton(
              child: const Text('Fetch Restaurants'),
              onPressed: () async {
                final yelpRepo = YelpRepository();

                try {
                  final result = await yelpRepo.getRestaurants();
                  if (result != null) {
                    print('Fetched ${result.restaurants!.length} restaurants');
                  } else {
                    print('No restaurants fetched');
                  }
                } catch (e) {
                  print('Failed to fetch restaurants: $e');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
