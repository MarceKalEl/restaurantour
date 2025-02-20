import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oxidized/oxidized.dart';
import 'package:restaurantour/core/models/restaurant.dart';

class YelpRepository {
  late Dio dio;

  YelpRepository({
    @visibleForTesting Dio? dio,
  }) : dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://api.yelp.com',
                headers: {
                  'Authorization': 'Bearer ${dotenv.env['YELP_API_KEY']}',
                  'Content-Type': 'application/graphql',
                },
              ),
            );

  /// Returns a response in this shape
  /// {
  /// "data": {
  ///   "search": {
  ///     "total": 5056,
  ///     "business": [
  ///       {
  ///         "id": "faPVqws-x-5k2CQKDNtHxw",
  ///         "name": "Yardbird Southern Table & Bar",
  ///         "price": "$$",
  ///         "rating": 4.5,
  ///         "photos": [
  ///           "https:///s3-media4.fl.yelpcdn.com/bphoto/_zXRdYX4r1OBfF86xKMbDw/o.jpg"
  ///         ],
  ///         "reviews": [
  ///           {
  ///             "id": "sjZoO8wcK1NeGJFDk5i82Q",
  ///             "rating": 5,
  ///             "user": {
  ///               "id": "BuBCkWFNT_O2dbSnBZvpoQ",
  ///               "image_url": "https:///s3-media2.fl.yelpcdn.com/photo/v8tbTjYaFvkzh1d7iE-pcQ/o.jpg",
  ///               "name": "Gina T."
  ///             }
  ///           },
  ///           {
  ///             "id": "okpO9hfpxQXssbTZTKq9hA",
  ///             "rating": 5,
  ///             "user": {
  ///               "id": "0x9xu_b0Ct_6hG6jaxpztw",
  ///               "image_url": "https:///s3-media3.fl.yelpcdn.com/photo/gjz8X6tqE3e4praK4HfCiA/o.jpg",
  ///               "name": "Crystal L."
  ///             }
  ///           },
  ///        ...
  ///     ]
  ///   }
  /// }
  ///
  Future<Result<RestaurantQueryResult, DioException>> getRestaurants({
    int offset = 0,
  }) async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/restaurants.json');
      final Map<String, dynamic> jsonResponse = json.decode(jsonString);
      final result =
          RestaurantQueryResult.fromJson(jsonResponse['data']['search']);

      return Ok(result);
    } catch (e) {
      return Err(
        DioException(
          requestOptions: RequestOptions(path: 'path'),
          error: e.toString(),
        ),
      );
    }
  }
}

String _getQuery(int offset) {
  return '''
query getRestaurants($offset: Int) {
  search(location: "Las Vegas", limit: 20, offset: $offset) {
    total
    business {
      id
      name
      price
      rating
      photos
      reviews {
        id
        rating
        text  
        user {
          id
          image_url
          name
        }
      }
      categories {
        title
        alias
      }
      hours {
        is_open_now
      }
      location {
        formatted_address  
      }
    }
  }
}

''';
}
