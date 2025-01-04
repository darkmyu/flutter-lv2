import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: RestaurantCard(
          image: Image.asset(
            'asset/img/food/ddeok_bok_gi.jpg',
            fit: BoxFit.cover,
          ),
          name: '불타는 떡볶이',
          tags: const ['떡볶이', '치즈', '매운맛'],
          ratingCount: 100,
          deliveryTime: 15,
          deliveryFee: 2000,
          ratings: 4.52,
        ),
      ),
    );
  }
}
