import 'package:actual/common/const/data.dart';
import 'package:actual/common/dio/dio.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List<RestaurantModel>> paginateRestaurant() async {
    final dio = Dio();

    dio.interceptors.add(CustomInterceptor(storage: storage));

    final response =
        await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant')
            .paginate();

    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: FutureBuilder<List<RestaurantModel>>(
          future: paginateRestaurant(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.separated(
              itemBuilder: (_, index) {
                final parsedItem = snapshot.data![index];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RestaurantDetailScreen(
                          id: parsedItem.id,
                        ),
                      ),
                    );
                  },
                  child: RestaurantCard.fromModel(
                    model: parsedItem,
                  ),
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
