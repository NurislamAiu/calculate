import 'package:flutter/material.dart';
import '../models/food_item.dart';
import 'item_detail_page.dart';
import '../services/food_service.dart';

/// [FoodDetailPage] - это универсальная страница, которая асинхронно
/// загружает данные о продукте на основе переданного [foodId].
/// Она заменяет собой отдельные страницы для каждого блюда (PizzaPage, BurgerPage и т.д.).
class FoodDetailPage extends StatefulWidget {
  final String foodId;

  const FoodDetailPage({super.key, required this.foodId});

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  final FoodService _foodService = FoodService();
  late final Future<FoodItem> _foodItemFuture;

  @override
  void initState() {
    super.initState();
    // Запускаем загрузку данных для конкретного блюда,
    // идентификатор которого получили через конструктор.
    _foodItemFuture = _foodService.getFoodItem(widget.foodId);
  }

  @override
  Widget build(BuildContext context) {
    // FutureBuilder следит за состоянием Future и перестраивает UI
    // в зависимости от этапа (загрузка, ошибка, успех).
    return FutureBuilder<FoodItem>(
      future: _foodItemFuture,
      builder: (context, snapshot) {
        // 1. Состояние загрузки: пока данные не пришли, показываем индикатор.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // 2. Состояние ошибки: если произошла ошибка, выводим сообщение.
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(), // Добавляем AppBar для кнопки "назад"
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }
        // 3. Состояние успеха: если данные пришли, передаем их в шаблонный виджет.
        if (snapshot.hasData) {
          final foodItem = snapshot.data!;
          return ItemDetailPage(item: foodItem);
        }
        // 4. Промежуточное состояние.
        return const Scaffold(
          body: Center(child: Text("No data available.")),
        );
      },
    );
  }
}
