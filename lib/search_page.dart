import 'package:cookmania/home_page.dart';
import 'package:cookmania/profilepage/profile_page.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
          child: Column(
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
              Container(
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
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Resep Terbaru',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                height: 300,
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.grey[300],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Judul'),
                                Text('Deskripsi singkat'),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Image.asset(
                              'lib/images/foto.png',
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
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
        currentIndex: 1,
        onTap: (int index) {
          debugPrint(index.toString());
          switch (index) {
            case 0:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
              break;
            case 1:
              break;
            case 2:
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => BookmarkPage(),
              //   ),
              // );
              break;
            case 3:
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => TopFoodPage(),
              //   ),
              // );
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
