import 'dart:convert';
import 'package:flutter/material.dart';
import 'discover.dart';
import 'home.dart';
import 'scan.dart';
import 'view_species.dart';

class fishScreen extends StatefulWidget {
  const fishScreen({super.key});

  @override
  _fishScreenState createState() => _fishScreenState();
}

class _fishScreenState extends State<fishScreen> {
  List<Map<String, dynamic>> fishData = [];
  bool isLoading = true; // For displaying a loading indicator

  @override
  void initState() {
    super.initState();
    loadfishData();
  }

  Future<void> loadfishData() async {
    try {
      // Load the species_data.json file
      final String response =
          await DefaultAssetBundle.of(context).loadString('assets/species_data.json');
      List<dynamic> data = jsonDecode(response);

      List<Map<String, dynamic>> fish = data
          .where((species) =>
              species["name"]?.toLowerCase() == "anemone" ||
              species["name"]?.toLowerCase() == "shark" ||
              species["name"]?.toLowerCase() == "goldfish" ||
              species["name"]?.toLowerCase() == "whale")
          .cast<Map<String, dynamic>>() // Ensure the data is cast correctly
          .toList();

      setState(() {
        fishData = fish;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading species data: $e');
      setState(() {
        isLoading = false; // Stop loading even if there is an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Fish",
          style: TextStyle(
            fontFamily: 'Minecraft',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : fishData.isEmpty
                        ? const Center(
                            child: Text(
                              "No fishes found!",
                              style: TextStyle(
                                fontFamily: 'Minecraft',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Two columns
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1, // Square cards
                            ),
                            itemCount: fishData.length,
                            itemBuilder: (context, index) {
                              final fish = fishData[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewSpeciesPage(
                                        speciesData: fish,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.asset(
                                          fish["headerImage"] ?? 'assets/placeholder.jpg',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      fish["name"] ?? "Unknown fish",
                                      style: const TextStyle(
                                        fontFamily: 'Minecraft',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
          // Bottom Navigation Bar
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Container(
                height: 65,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  currentIndex: 1, // Highlight fish tab
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedItemColor: Colors.redAccent.withOpacity(0.9),
                  unselectedItemColor: Colors.white.withOpacity(0.9),
                  selectedFontSize: 14,
                  unselectedFontSize: 12,
                  iconSize: 24,
                  type: BottomNavigationBarType.fixed,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_filled),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.camera_alt),
                      label: 'Scan',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.manage_search_rounded),
                      label: 'Discover',
                    ),
                  ],
                  onTap: (index) {
                    if (index == 0) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const HomePage(),
                          transitionsBuilder: (_, anim, __, child) => FadeTransition(
                            opacity: anim,
                            child: child,
                          ),
                        ),
                      );
                    } else if (index == 1) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const ScanPage(),
                          transitionsBuilder: (_, anim, __, child) => FadeTransition(
                            opacity: anim,
                            child: child,
                          ),
                        ),
                      );
                    } else if (index == 2) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const DiscoverScreen(),
                          transitionsBuilder: (_, anim, __, child) => FadeTransition(
                            opacity: anim,
                            child: child,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
