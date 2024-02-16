import 'package:flutter/material.dart';
import 'package:restaurantour/shared/tr_skeleton.dart';

class MyFavoritesTab extends StatelessWidget {
  const MyFavoritesTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TrSkeleton(height: 50, width: 100),
            Text('My Favorites'),
          ],
        ),
      ),
    );
  }
}
