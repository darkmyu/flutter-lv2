import 'package:actual/common/const/data.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> paginateRestaurant() async {
    final dio = Dio();
    final accessToken = await storage.read(key: accessTokenKey);

    final response = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      ),
    );

    return response.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: FutureBuilder<List>(
          future: paginateRestaurant(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            return ListView.separated(
              itemBuilder: (_, index) {
                final item = snapshot.data![index];
                final parsedItem = RestaurantModel(
                  id: item['id'],
                  name: item['name'],
                  thumbUrl: 'http://$ip${item['thumbUrl']}',
                  tags: List.from(item['tags']),
                  priceRange: RestaurantPriceRange.values.firstWhere(
                    (e) => e.name == item['priceRange'],
                  ),
                  ratings: item['ratings'],
                  ratingsCount: item['ratingsCount'],
                  deliveryTime: item['deliveryTime'],
                  deliveryFee: item['deliveryFee'],
                );

                return RestaurantCard(
                  image: Image.network(
                    parsedItem.thumbUrl,
                    fit: BoxFit.cover,
                  ),
                  name: parsedItem.name,
                  tags: parsedItem.tags,
                  ratingsCount: parsedItem.ratingsCount,
                  deliveryTime: parsedItem.deliveryTime,
                  deliveryFee: parsedItem.deliveryFee,
                  ratings: parsedItem.ratings,
                );
              },
              separatorBuilder: (_, index) {
                return const SizedBox(
                  height: 16,
                );
              },
              itemCount: snapshot.data!.length,
            );
          },
        ),
      ),
    );
  }
}
