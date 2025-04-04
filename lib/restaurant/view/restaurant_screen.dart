import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: FutureBuilder<CursorPagination<RestaurantModel>>(
          future: ref.watch(restaurantRepositoryProvider).paginate(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.separated(
              itemBuilder: (_, index) {
                final parsedItem = snapshot.data!.data[index];

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
              itemCount: snapshot.data!.data.length,
            );
          },
        ),
      ),
    );
  }
}
