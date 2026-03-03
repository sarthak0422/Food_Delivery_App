import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/my_buttons.dart';
import 'package:untitled/models/restaurant.dart';
import 'package:untitled/payment_success_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool isAddingNewCard = false;
  int? selectedCardIndex;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Confirm delete dialog
  void confirmDelete(int index, Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Card?"),
        content: const Text("Are you sure you want to remove this card?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              restaurant.removeCard(index);
              setState(() {
                if (selectedCardIndex == index) selectedCardIndex = null;
              });
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Handle Pay button logic
  void userTappedPay(Restaurant restaurant) {
    // 1. If user is filling the form
    if (isAddingNewCard || restaurant.myCards.isEmpty) {
      if (!formKey.currentState!.validate()) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Save Card?"),
          content: const Text("Would you like to save this card for future payments?"),
          actions: [
            // Option: Just Pay (Temporary)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showFinalPaymentConfirm(restaurant, isTemporary: true);
              },
              child: const Text("No, Just Pay"),
            ),
            // Option: Save and then pay
            TextButton(
              onPressed: () {
                restaurant.addCard(cardNumber, expiryDate, cardHolderName);

                setState(() {
                  selectedCardIndex = restaurant.myCards.length - 1;
                  isAddingNewCard = false;
                  // Clear form fields
                  cardNumber = ''; expiryDate = ''; cardHolderName = ''; cvvCode = '';
                });

                Navigator.pop(context);

                // Animate carousel to the new card
                _pageController.animateToPage(
                  restaurant.myCards.length - 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );

                _showFinalPaymentConfirm(restaurant);
              },
              child: const Text("Save & Pay"),
            ),
          ],
        ),
      );
    } else {
      // 2. User is picking from Saved Cards
      _showFinalPaymentConfirm(restaurant);
    }
  }

  // Final Step: Ask user to confirm the charge
  void _showFinalPaymentConfirm(Restaurant restaurant, {bool isTemporary = false}) {
    String last4 = "";

    // Safety check for substring
    if (isTemporary) {
      last4 = cardNumber.length >= 4 ? cardNumber.substring(cardNumber.length - 4) : "****";
    } else {
      int index = selectedCardIndex ?? 0;
      if (restaurant.myCards.isNotEmpty) {
        final card = restaurant.myCards[index];
        last4 = card.number.length >= 4 ? card.number.substring(card.number.length - 4) : "****";
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Payment"),
        content: Text("Proceed with payment using card ending in $last4?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaymentSuccessPage()),
              );
            },
            child: const Text("Confirm & Pay"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("P A Y M E N T"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Consumer<Restaurant>(
        builder: (context, restaurant, child) {
          bool showForm = restaurant.myCards.isEmpty || isAddingNewCard;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 10),

                // 1️⃣ SAVED CARDS SECTION
                if (restaurant.myCards.isNotEmpty && !isAddingNewCard)
                  Column(
                    children: [
                      const Text("Select a Card", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 240,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: restaurant.myCards.length,
                          onPageChanged: (i) => setState(() => selectedCardIndex = i),
                          itemBuilder: (context, index) {
                            final card = restaurant.myCards[index];
                            bool isSelected = (selectedCardIndex ?? 0) == index;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              transform: isSelected ? Matrix4.identity() : Matrix4.identity()..scale(0.85),
                              child: Stack(
                                children: [
                                  CreditCardWidget(
                                    cardNumber: card.number,
                                    expiryDate: card.expiry,
                                    cardHolderName: card.holder,
                                    cvvCode: '***',
                                    showBackView: false,
                                    onCreditCardWidgetChange: (p0) {},
                                    cardBgColor: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.shade800,
                                  ),
                                  if (isSelected)
                                    const Positioned(
                                      bottom: 25, right: 35,
                                      child: Icon(Icons.check_circle, color: Colors.white, size: 30),
                                    ),
                                  Positioned(
                                    right: 25, top: 15,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.white),
                                      onPressed: () => confirmDelete(index, restaurant),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // Dot Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          restaurant.myCards.length,
                              (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: (selectedCardIndex ?? 0) == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: (selectedCardIndex ?? 0) == index
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      if (restaurant.myCards.length < 3)
                        TextButton.icon(
                          onPressed: () => setState(() => isAddingNewCard = true),
                          icon: const Icon(Icons.add_card),
                          label: const Text("Add Another Card"),
                        ),
                    ],
                  ),

                // 2️⃣ NEW CARD FORM
                if (showForm)
                  Column(
                    children: [
                      const Text("Enter Card Details", style: TextStyle(fontWeight: FontWeight.bold)),
                      CreditCardWidget(
                        cardNumber: cardNumber,
                        expiryDate: expiryDate,
                        cardHolderName: cardHolderName,
                        cvvCode: cvvCode,
                        showBackView: isCvvFocused,
                        onCreditCardWidgetChange: (p0) {},
                      ),
                      CreditCardForm(
                        cardNumber: cardNumber,
                        expiryDate: expiryDate,
                        cardHolderName: cardHolderName,
                        cvvCode: cvvCode,
                        formKey: formKey,
                        onCreditCardModelChange: (data) {
                          setState(() {
                            cardNumber = data.cardNumber;
                            expiryDate = data.expiryDate;
                            cardHolderName = data.cardHolderName;
                            cvvCode = data.cvvCode;
                          });
                        },
                      ),
                      if (restaurant.myCards.isNotEmpty)
                        TextButton(
                          onPressed: () => setState(() => isAddingNewCard = false),
                          child: const Text("Cancel & Use Saved Card"),
                        ),
                    ],
                  ),

                const SizedBox(height: 25),
                MyButton(onTap: () => userTappedPay(restaurant), text: "Pay Now", child: null,),
              ],
            ),
          );
        },
      ),
    );
  }
}