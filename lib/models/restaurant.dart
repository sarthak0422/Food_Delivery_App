import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/models/cart_item.dart';
import 'food.dart';


// 1. SIMPLE DATA MODEL
class SavedCard {
  final String number;
  final String expiry;
  final String holder;

  SavedCard({required this.number, required this.expiry, required this.holder});
}

class Restaurant extends ChangeNotifier {
  /*
  M E N U
  */
  final List<Food> _menu = [
    // rice plate
    Food(
      name: "Fish Thali",
      description: "This thali contains tawa kolambi fry, bangda curry, tandalachi bhakari, pomfret fry, solkadhi and rice.",
      imagePath: "lib/images/riceplate/rice1.jpeg",
      price: 500,
      category: FoodCategory.riceplate,
      availableAddons: [
        Addons(name: "Extra Masala", price: 50),
        Addons(name: "Extra Kanda", price: 10),
        Addons(name: "Extra Rassa", price: 30)
      ],
    ),
    Food(
      name: "Mutton Thali",
      description: "The mutton thali had unlimited jowar rotis, with mutton gravy, goat intestine gravy and egg gravy. The jowar rotis are prepared fresh and served hot.",
      imagePath: "lib/images/riceplate/rice2.jpeg",
      price: 500,
      category: FoodCategory.riceplate,
      availableAddons: [
        Addons(name: "Extra Masala", price: 50),
        Addons(name: "Extra Kanda", price: 10),
        Addons(name: "Extra Rassa", price: 30)
      ],
    ),
    Food(
      name: "Spicy Fish Thali",
      description: "This thali contains tawa kolambi fry, bangda curry, tandalachi bhakari, pomfret fry, solkadhi and rice.",
      imagePath: "lib/images/riceplate/rice3.jpeg",
      price: 500,
      category: FoodCategory.riceplate,
      availableAddons: [
        Addons(name: "Extra Masala", price: 50),
        Addons(name: "Extra Kanda", price: 10),
        Addons(name: "Extra Rassa", price: 30)
      ],
    ),
    Food(
      name: "Kokani Fish Thali",
      description: "This thali contains tawa kolambi fry, bangda curry, tandalachi bhakari, pomfret fry, solkadhi and rice.",
      imagePath: "lib/images/riceplate/rice4.jpeg",
      price: 500,
      category: FoodCategory.riceplate,
      availableAddons: [
        Addons(name: "Extra Masala", price: 50),
        Addons(name: "Extra Kanda", price: 10),
        Addons(name: "Extra Rassa", price: 30)
      ],
    ),
    Food(
      name: "Crab Thali",
      description: "It comes with a generous portion of Crab curry, Our speciality Prawns Sautallela, Fish Curry, Solkadhi, Prawns Pickle, Jawla Chutney, Mirgunda, Bhakri/Chapati and Rice.",
      imagePath: "lib/images/riceplate/rice5.jpeg",
      price: 500,
      category: FoodCategory.riceplate,
      availableAddons: [
        Addons(name: "Extra Masala", price: 50),
        Addons(name: "Extra Kanda", price: 10),
        Addons(name: "Extra Rassa", price: 30),
      ],
    ),
    // salads
    Food(
      name: "Western",
      description: "Just Salad.",
      imagePath: "lib/images/salads/salad1.jpeg",
      price: 50,
      category: FoodCategory.salads,
      availableAddons: [Addons(name: "Extra Masala", price: 50)],
    ),
    Food(
      name: "Just Cucumber.",
      description: "This cucumber salad recipe is made with fresh dill, onions, and a sweet and tangy vinegar dressing. It's an easy, delicious summer side dish.",
      imagePath: "lib/images/salads/salad2.jpeg",
      price: 50,
      category: FoodCategory.salads,
      availableAddons: [Addons(name: "Extra Masala", price: 50)],
    ),
    Food(
      name: "Kanda",
      description: "Just Kanda.",
      imagePath: "lib/images/salads/salad3.jpeg",
      price: 50,
      category: FoodCategory.salads,
      availableAddons: [Addons(name: "Extra Masala", price: 50)],
    ),
    Food(
      name: "Chana",
      description: "Just Chana.",
      imagePath: "lib/images/salads/salad4.jpeg",
      price: 50,
      category: FoodCategory.salads,
      availableAddons: [Addons(name: "Extra Masala", price: 50)],
    ),
    Food(
      name: "Koshimbir Classic.",
      description: "It’s a great fasting recipe too. Easy to make and cool for the tummy.",
      imagePath: "lib/images/salads/salad5.jpeg",
      price: 50,
      category: FoodCategory.salads,
      availableAddons: [Addons(name: "Extra Masala", price: 50)],
    ),
    // sides
    Food(
      name: "Bhaji Classic.",
      description: "A bhaji is a small piece of food of Indian origin, made of vegetables fried in batter with spices.",
      imagePath: "lib/images/sides/sides1.jpeg",
      price: 50,
      category: FoodCategory.sides,
      availableAddons: [Addons(name: "Extra Masala", price: 50)],
    ),
    // deserts
    Food(
      name: "Pudding Classic.",
      description: "A soft, spongy, or thick creamy consistency",
      imagePath: "lib/images/deserts/deserts1.jpeg",
      price: 100,
      category: FoodCategory.deserts,
      availableAddons: [Addons(name: "Extra Nuts", price: 50)],
    ),
    // drinks
    Food(
      name: "Lassi Classic.",
      description: "A creamy, frothy yogurt-based drink, blended with water and various fruits or seasonings (such as salt or sugar), that originated in Punjab, India.",
      imagePath: "lib/images/drinks/drinks1.jpeg",
      price: 80,
      category: FoodCategory.drinks,
      availableAddons: [Addons(name: "Extra Masala", price: 50)],
    ),
  ];

  /*
  C A R T  &  H I S T O R Y
  */
  final List<CartItem> _cart = [];
  final List<String> _orderHistory = [];

  List<Food> get menu => _menu;
  List<CartItem> get cart => _cart;
  List<String> get orderHistory => _orderHistory;

  /*
  C A R D  M A N A G E M E N T (Fixed Placement)
  */
  final List<SavedCard> _myCards = [];
  int _selectedCardIndex = 0;

  List<SavedCard> get myCards => _myCards;
  int get selectedCardIndex => _selectedCardIndex;

  // Add a new card (Max 3)
  void addCard(String number, String expiry, String holder) {
    if (_myCards.length < 3) {
      _myCards.add(SavedCard(number: number, expiry: expiry, holder: holder));
      _selectedCardIndex = _myCards.length - 1;
      notifyListeners();
    }
  }

  // Remove a card
  void removeCard(int index) {
    _myCards.removeAt(index);
    if (_selectedCardIndex >= _myCards.length && _myCards.isNotEmpty) {
      _selectedCardIndex = _myCards.length - 1;
    } else if (_myCards.isEmpty) {
      _selectedCardIndex = 0;
    }
    notifyListeners();
  }

  // Change selected card
  void selectCard(int index) {
    _selectedCardIndex = index;
    notifyListeners();
  }

  /*
  O P E R A T I O N S
  */

  void saveOrderToHistory() {
    String receipt = displayCartRecipt();
    _orderHistory.insert(0, receipt);
    clearCart();
  }

  void addToCart(Food food, List<Addons> selectedAddons) {
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      bool isSameFood = item.food == food;
      bool isSameAddons = const ListEquality().equals(item.selectedAddons, selectedAddons);
      return isSameFood && isSameAddons;
    });

    if (cartItem != null) {
      cartItem.quantity++;
    } else {
      _cart.add(CartItem(food: food, selectedAddons: selectedAddons));
    }
    notifyListeners();
  }

  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);
    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
    }
    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0.0;
    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;
      for (Addons addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }
      total += itemTotal * cartItem.quantity;
    }
    return total;
  }

  int getTotalItemCount() {
    int count = 0;
    for (CartItem item in _cart) {
      count += item.quantity;
    }
    return count;
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  /*
  H E L P E R S
  */

  String displayCartRecipt() {
    final receipt = StringBuffer();
    receipt.writeln("Here's your Receipt.");
    receipt.writeln();

    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln("-----------");

    for (final cartItem in _cart) {
      receipt.writeln("${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}");
      if (cartItem.selectedAddons.isNotEmpty) {
        receipt.writeln(" Add-ons: ${_formatAddons(cartItem.selectedAddons)}");
      }
      receipt.writeln();
    }
    receipt.writeln("----------");
    receipt.writeln();
    receipt.writeln("Total Items: ${getTotalItemCount()}");
    receipt.writeln("Total Price: ${_formatPrice(getTotalPrice())}");

    return receipt.toString();
  }

  String _formatPrice(double price) {
    return "₹${price.toStringAsFixed(2)}";
  }

  String _formatAddons(List<Addons> addons) {
    return addons.map((addon) => "${addon.name} (${_formatPrice(addon.price)})").join(",");
  }
}