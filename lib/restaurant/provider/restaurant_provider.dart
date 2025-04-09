import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/provider/pagination_provider.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantDetailProvider = Provider.family<RestaurantModel?, String>(
  (ref, id) {
    final state = ref.watch(restaurantProvider);

    if (state is! CursorPagination) {
      return null;
    }

    return state.data.firstWhere((e) => e.id == id);
  },
);

final restaurantProvider = StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);

    return RestaurantStateNotifier(repository: repository);
  },
);

class RestaurantStateNotifier extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({
    required super.repository,
  });

  void getDetail({
    required String id,
  }) async {
    if (state is! CursorPagination) {
      await paginate();
    }

    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;

    final response = await repository.getRestaurantDetail(id: id);

    state = pState.copyWith(
      data: pState.data.map<RestaurantModel>((e) => e.id == id ? response : e).toList(),
    );
  }
}
