# План разработки

1) подключим сервер
2) поставим real items
3) научимся что такое const, final, late, var
4) create page settings

---

# Инструкция по интеграции с Firebase

Этот проект подготовлен для легкого подключения к Firebase. Все необходимые "заготовки" кода уже добавлены в файлы и закомментированы.

Следуйте этим шагам, чтобы переключить приложение с имитации данных на реальные данные из Firestore.

### Шаг 1: Настройка проекта Firebase

1.  **Создайте проект Firebase:** Перейдите на [консоль Firebase](https://console.firebase.google.com/) и создайте новый проект.
2.  **Зарегистрируйте ваше приложение:** В настройках проекта добавьте Flutter-приложение, следуя инструкциям (вам нужно будет указать `applicationId` для Android и `bundleId` для iOS).
3.  **Скачайте конфигурационные файлы:** Скачайте `google-services.json` ( для Android) и `GoogleService-Info.plist` (для iOS) и разместите их в соответствующих папках вашего проекта, как указано в инструкции Firebase.
4.  **Создайте базу данных Firestore:** В консоли Firebase перейдите в раздел "Firestore Database" и создайте базу данных. Начните в тестовом режиме (это позволит делать запросы без настройки правил безопасности).

### Шаг 2: Добавление зависимостей

Откройте файл `pubspec.yaml` и добавьте в секцию `dependencies` следующие пакеты:

```yaml
dependencies:
  flutter:
    sdk: flutter
  # ... другие зависимости
  
  firebase_core: ^2.24.2 # Уточните актуальную версию
  cloud_firestore: ^4.14.0 # Уточните актуальную версию
```
После добавления выполните команду `flutter pub get` в терминале.

### Шаг 3: Инициализация Firebase в приложении

Откройте файл `lib/main.dart` и инициализируйте Firebase перед запуском приложения:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 1. Импортируйте
import 'home_page.dart';

void main() async { // 2. Сделайте main асинхронным
  WidgetsFlutterBinding.ensureInitialized(); // 3. Обязательная строка
  await Firebase.initializeApp(); // 4. Инициализация Firebase
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ... остальной код
}
```

### Шаг 4: Раскомментируйте заготовки кода

Теперь последовательно раскомментируйте подготовленный код в следующих файлах:

1.  **Модели:**
    *   `lib/models/review.dart` (конструктор `fromMap`)
    *   `lib/models/food_item.dart` (конструктор `fromFirestore`)
    *   `lib/models/user_profile.dart` (конструкторы `fromMap` и `fromFirestore`)
    *   `lib/cart_manager.dart` (в классе `CartItem` конструктор `fromMap` и метод `toMap`)

2.  **Сервисы и Менеджеры:**
    *   `lib/services/food_service.dart` (импорт `cloud_firestore` и закомментированный блок с запросом в методе `getFoodItem`)
    *   `lib/services/user_service.dart` (импорт и метод `getUserProfileFromFirebase`)
    *   `lib/cart_manager.dart` (импорт и все закомментированные блоки, связанные с Firebase)

### Шаг 5: Переключите логику на Firebase

1.  **Загрузка данных о еде:**
    *   В файле `lib/services/food_service.dart`, в методе `getFoodItem`, **закомментируйте** блок `switch-case` и **раскомментируйте** блок с запросом к Firebase.

2.  **Загрузка профиля пользователя:**
    *   В файле `lib/profile_page.dart`, в методе `initState`, замените вызов `_userService.getUserProfile()` на `_userService.getUserProfileFromFirebase("ID_ПОЛЬЗОВАТЕЛЯ")`.
      *(В реальном приложении ID пользователя нужно будет получать после его аутентификации)*.

3.  **Синхронизация корзины:**
    *   После того как пользователь войдет в систему, вызовите один раз `cartManager.loadCart("ID_ПОЛЬЗОВАТЕЛЯ")`, чтобы загрузить его корзину с сервера.
    *   Убедитесь, что вызовы `_syncItemToFirebase` в методах `addItem` и `removeItem` в `cart_manager.dart` раскомментированы, чтобы все изменения сразу отправлялись в Firebase.

### Шаг 6: Настройка структуры данных в Firestore

Убедитесь, что структура вашей базы данных Firestore соответствует тому, что ожидает код:

*   **Коллекция `products`:**
    *   Документы с ID `pizza`, `burger`, `sushi`.
    *   Каждый документ должен содержать поля: `name` (String), `price` (Number), `imagePath` (String, например "pizza.png"), `ingredients` (Array of Strings), `reviews` (Array of Maps, где каждый Map содержит `author`, `text`, `rating`).

*   **Коллекция `users`:**
    *   Документы, где ID - это уникальный идентификатор пользователя (`userId`).
    *   Каждый документ должен содержать поля для профиля: `name`, `phone`, `avatarUrl` и т.д.
    *   В каждом документе пользователя должна быть **подколлекция `cart`**, где хранятся товары его корзины.

После выполнения этих шагов ваше приложение будет полностью работать с Firebase.
