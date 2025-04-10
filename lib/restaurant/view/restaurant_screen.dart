import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/utils/pagination_utils.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(restaurantProvider.notifier),
    );

    // if (controller.offset > controller.position.maxScrollExtent - 300) {
    //   ref.read(restaurantProvider.notifier).paginate(
    //         fetchMore: true,
    //       );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    if (data is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    final cursorPagination = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: ListView.separated(
        controller: controller,
        itemCount: cursorPagination.data.length + 1,
        itemBuilder: (_, index) {
          if (index == cursorPagination.data.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Center(
                child: data is CursorPaginationFetchingMore ? const CircularProgressIndicator() : const Text('마지막 데이터입니다.'),
              ),
            );
          }

          final parsedItem = cursorPagination.data[index];

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
      ),
    );
  }
}
