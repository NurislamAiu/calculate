import 'package:flutter/material.dart';
import '../cart_manager.dart';
import '../models/food_item.dart';
import '../models/review.dart';

/// [ItemDetailPage] - это универсальный (шаблонный) виджет для отображения
/// страницы с детальной информацией о продукте.
/// Он принимает в конструктор объект [FoodItem] и строит UI на основе его данных.
/// Это позволяет избежать дублирования кода для каждого продукта.
class ItemDetailPage extends StatefulWidget {
  /// [item] - объект, содержащий всю информацию о продукте для отображения.
  final FoodItem item;

  const ItemDetailPage({super.key, required this.item});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage>
    with SingleTickerProviderStateMixin {
  // Контроллер для управления вкладками "Ingredients" и "Ratings".
  late TabController _tabController;
  // Контроллер для текстового поля ввода отзыва.
  final _reviewController = TextEditingController();
  // Локальный список отзывов. Инициализируется изначальными отзывами из [widget.item.reviews].
  // Позволяет добавлять новые отзывы без изменения исходного объекта [FoodItem].
  late final List<Review> _reviews;
  // Текущий рейтинг, который выбрал пользователь для нового отзыва.
  int _currentRating = 0;

  @override
  void initState() {
    super.initState();
    // Инициализация TabController.
    _tabController = TabController(length: 2, vsync: this);
    // Создаем копию списка отзывов, чтобы его можно было изменять.
    _reviews = List.from(widget.item.reviews);
  }

  @override
  void dispose() {
    // Освобождаем ресурсы контроллеров, когда виджет удаляется.
    _tabController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  /// [_submitReview] - метод для добавления нового отзыва.
  /// Он срабатывает при нажатии на кнопку "отправить".
  void _submitReview() {
    // Проверяем, что пользователь ввел текст и поставил оценку.
    if (_reviewController.text.isNotEmpty && _currentRating > 0) {
      // Обновляем состояние виджета, чтобы перерисовать UI.
      setState(() {
        _reviews.add(
          Review(
            author: "New User", // В реальном приложении здесь было бы имя текущего пользователя.
            text: _reviewController.text,
            rating: _currentRating,
          ),
        );
        // Очищаем поле ввода и сбрасываем рейтинг после отправки.
        _reviewController.clear();
        _currentRating = 0;
      });
      // Скрываем клавиатуру.
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        // Заголовок экрана строится динамически из имени продукта.
        title: Text(
          "${widget.item.name} Details",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          // Виджеты для управления количеством товара в корзине.
          ListenableBuilder(
            listenable: cartManager,
            builder: (context, _) {
              final quantity = cartManager.getQuantity(widget.item.name);
              return Row(
                children: [
                  IconButton(
                    onPressed: () {
                      cartManager.removeItem(widget.item.name);
                    },
                    icon: const Icon(Icons.remove, color: Colors.black),
                  ),
                  Text(
                    '$quantity',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      cartManager.addItem(widget.item.name, widget.item.imagePath, widget.item.price);
                    },
                    icon: const Icon(Icons.add, color: Colors.black),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Секция с изображением продукта ---
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                child: Hero(
                  // Hero анимация для плавного перехода с главного экрана.
                  // Тег должен быть уникальным для каждого продукта.
                  tag: widget.item.imagePath,
                  child: Image.asset(widget.item.imagePath, fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- Секция с информацией (название, цена и табы) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Название и цена ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.item.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${widget.item.price} KZT",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // --- Переключатель вкладок ---
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.orange,
                    tabs: const [
                      Tab(text: "Ingredients"),
                      Tab(text: "Ratings"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // --- Содержимое вкладок ---
                  SizedBox(
                    height: 300, // Высота контейнера для вкладок
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // --- 1. Вкладка "Ингредиенты" ---
                        ListView.builder(
                          itemCount: widget.item.ingredients.length,
                          itemBuilder: (context, index) {
                            // Строим список ингредиентов на основе данных из [widget.item].
                            return _buildIngredientItem(widget.item.ingredients[index]);
                          },
                        ),
                        // --- 2. Вкладка "Отзывы" ---
                        Column(
                          children: [
                            Expanded(
                              // ListView.builder для отображения списка отзывов.
                              child: ListView.builder(
                                itemCount: _reviews.length,
                                itemBuilder: (context, index) {
                                  final review = _reviews[index];
                                  return ListTile(
                                    leading: ClipOval(
                                      child: Image.asset(
                                        "assets/profile.png",
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Text(review.author),
                                    subtitle: Text(
                                      review.text,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    // Отображение рейтинга в виде звезд.
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(5, (starIndex) {
                                        return Icon(
                                          starIndex < review.rating
                                              ? Icons.star
                                              : Icons.star_border_outlined,
                                          color: Colors.amber,
                                          size: 16,
                                        );
                                      }),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Поле для ввода нового отзыва.
                            _buildReviewInputField(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// [_buildReviewInputField] - вспомогательный виджет для создания
  /// поля ввода нового отзыва, включая звезды для рейтинга и кнопку отправки.
  Widget _buildReviewInputField() {
    return Column(
      children: [
        // --- Звезды для выбора рейтинга ---
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < _currentRating ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () {
                // Обновляем состояние, чтобы перерисовать звезды.
                setState(() {
                  _currentRating = index + 1;
                });
              },
            );
          }),
        ),
        // --- Поле для ввода текста отзыва ---
        TextFormField(
          controller: _reviewController,
          decoration: InputDecoration(
            hintText: 'Write a review...',
            fillColor: Colors.grey[200],
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 20.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color: Colors.orange,
              ),
            ),
            // --- Кнопка отправки отзыва ---
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: _submitReview,
            ),
          ),
        ),
      ],
    );
  }

  /// [_buildIngredientItem] - вспомогательный виджет для отображения
  /// одного пункта в списке ингредиентов.
  Widget _buildIngredientItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.orange[400], size: 20),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 16, color: Colors.grey[800])),
        ],
      ),
    );
  }
}
