import 'package:cookmania/archive_page.dart';
import 'package:cookmania/homepage/pilihan_bahan.dart';
import 'package:cookmania/homepage/pilihan_negara.dart';
import 'package:cookmania/profilepage/profile_page.dart';
import 'package:cookmania/upload_recipe_fix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cookmania/search/searchKetik_page.dart'; // Import the SearchKetikPage
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pilihanMenu = 0;
  final _japanController = PageController();
  final _koreaController = PageController();
  final _italyController = PageController();
  final List<String> bahanIMG = <String>[
    "chicken.png",
    "beef.png",
    "pork.png",
    "fish.png",
    "crab.png",
    "shrimp.png"
  ];
  final List<String> bahanText = <String>[
    "Ayam",
    "Sapi",
    "Babi",
    "Ikan",
    "Kepiting",
    "Udang"
  ];
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  @override
  void dispose() {
    _japanController.dispose();
    _koreaController.dispose();
    _italyController.dispose();
    super.dispose();
  }

  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
      print('username: $_username');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ----------------------------------TITLE----------------------------------
              const Center(
                child: Text(
                  "COOKMANIA",
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20.0),
              // ----------------------------------SEARCH BAR----------------------------------
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          SearchKetikPage(),
                    ),
                  );
                },
                child: Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Center(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Ketikkan bahan...',
                        hintStyle: TextStyle(fontSize: 16.0),
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                      enabled:
                          false, // Disable the TextField to prevent editing
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              // ----------------------------------TAB BAR----------------------------------
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pilihan Negara',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const PilihanNegara(),
              // ----------------------------------Grid View----------------------------------
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pilihan Bahan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              PilihanBahan(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              label: "Home", icon: Icon(Icons.home_outlined)),
          BottomNavigationBarItem(
              label: "Search", icon: Icon(Icons.search_outlined)),
          BottomNavigationBarItem(
              label: "Upload", icon: Icon(Icons.add_box_rounded)),
          BottomNavigationBarItem(
              label: "Archive", icon: Icon(Icons.bookmark_outline)),
          BottomNavigationBarItem(
              label: "Profile", icon: Icon(Icons.person_2_outlined)),
        ],
        currentIndex: pilihanMenu,
        onTap: (int index) {
          setState(() {
            pilihanMenu = index;
          });

          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      SearchKetikPage(),
                ),
              );
              break;
            case 2:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UploadRecipe(),
                ),
              );
              break;
            case 3:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ArchivePage(),
                ),
              );
              break;
            case 4:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
              break;
          }
        },
        selectedItemColor: Colors.yellow.shade800,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(color: Colors.yellow.shade800),
        showUnselectedLabels: true,
      ),
    );
  }
}
