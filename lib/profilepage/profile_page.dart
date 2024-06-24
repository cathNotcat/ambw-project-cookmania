import 'package:cookmania/home_page.dart';
import 'package:cookmania/profilepage/login_page.dart';
import 'package:cookmania/profilepage/register_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
            const SizedBox(height: 20.0), _loggedOut(),
          ],
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
        currentIndex: 4,
        onTap: (int index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
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

  Widget _loggedOut() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              style: FilledButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 219, 103),
                  foregroundColor: Colors.black),
              child: const Text(
                "Log In",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              )),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RegisterPage()));
              },
              style: FilledButton.styleFrom(
                  backgroundColor: Colors.yellow[800],
                  foregroundColor: Colors.black),
              child: const Text(
                "Register",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              )),
        ),
      ],
    );
  }

  Widget _loggedIn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Username",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const Text(
          "Email",
          style: TextStyle(fontSize: 18.0),
        ),
        const Divider(height: 20, thickness: 1),
        const SizedBox(height: 10.0),
        const Text(
          "Resep saya",
          style: TextStyle(fontSize: 20.0),
        ),
        const SizedBox(height: 20.0),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Image.asset(
                'lib/images/indo1.jpg',
                width: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              Wrap(
                direction: Axis.vertical,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: const Text(
                      "Judul",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: const Text(
                      "Deskripsi panjang yang seharusnya membungkus ke baris berikutnya jika tidak ada cukup ruang di satu baris.",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 40.0),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              style: FilledButton.styleFrom(
                  backgroundColor: Colors.yellow[800],
                  foregroundColor: Colors.black),
              child: const Text(
                "Log Out",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              )),
        ),
      ],
    );
  }
}
