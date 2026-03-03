import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/my_current_location.dart';
import 'package:untitled/components/my_description_box.dart';
import 'package:untitled/components/my_drawer.dart';
import 'package:untitled/components/my_food_tile.dart';
import 'package:untitled/components/my_sliver_app_bar.dart';
import 'package:untitled/components/my_tab_bar.dart';
import 'package:untitled/food_page.dart';
import 'package:untitled/models/food.dart';
import 'package:untitled/models/restaurant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  GoogleMapController? _mapController;
  LatLng _currentPos = const LatLng(19.0760, 72.8777); // Default to Mumbai

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: FoodCategory.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String getUserDisplayName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return "Guest User";

    // Return email if available, otherwise return phone number
    return user.email ?? user.phoneNumber ?? "Anonymous";
  }

  List<Food> _filterMenuByCategory(FoodCategory category, List<Food> fullMenu) {
    return fullMenu.where((food) => food.category == category).toList();
  }

  List<Widget> getFoodInThisCategory(List<Food> fullMenu) {
    return FoodCategory.values.map((category) {
      List<Food> categoryMenu = _filterMenuByCategory(category, fullMenu);

      return ListView.builder(
        itemCount: categoryMenu.length,
        physics: const NeverScrollableScrollPhysics(),
        // ADDED: Padding makes the list feel "breathable"
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemBuilder: (context, index) {
          final food = categoryMenu[index];
          return Padding(
            // ADDED: Spacing between tiles
            padding: const EdgeInsets.only(bottom: 12),
            child: FoodTile(
              food: food,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodPage(food: food),
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const MyDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          MySliverAppBar(
            title: MyTabBar(tabController: _tabController),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Polished Divider
                Divider(
                  indent: 80,
                  endIndent: 80,
                  thickness: 1,
                  color: Theme.of(context).colorScheme.tertiary,
                ),

                // Location & Description
                const MyCurrentLocation(),
                const MyDescriptionBox(),

                // Placeholder for Map on Home Page
                SizedBox(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(target: _currentPos, zoom: 14),
                    onMapCreated: (controller) => _mapController = controller,
                    onCameraMove: (position) {
                      setState(() {
                        _currentPos = position.target;
                      });
                    },
                    markers: {
                      Marker(markerId: const MarkerId('pickup'), position: _currentPos),
                    },
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
        body: Consumer<Restaurant>(
          builder: (context, restaurant, child) => Container(
            color: Theme.of(context).colorScheme.surface,
            child: TabBarView(
              controller: _tabController,
              children: getFoodInThisCategory(restaurant.menu),
            ),
          ),
        ),
      ),
    );
  }
}