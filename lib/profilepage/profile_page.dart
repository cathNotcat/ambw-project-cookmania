import 'package:cookmania/archive_page.dart';
import 'package:cookmania/edit_resep.dart';
import 'package:cookmania/home_page.dart';
import 'package:cookmania/profilepage/login_page.dart';
import 'package:cookmania/profilepage/register_page.dart';
import 'package:cookmania/search/searchKetik_page.dart';
import 'package:cookmania/upload_recipe_fix.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('profile');
  final DatabaseReference _dbResepRef =
      FirebaseDatabase.instance.ref().child('resep');

  String? _username;
  String? _userkey;
  Map<String, String> _userData = {};
  Map<String, List<Map<String, String>>> _resepData = {'resep': []};

  @override
  void initState() {
    super.initState();
    print("ProfilePage initState called");
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    if (username != null) {
      setState(() {
        _username = username;
      });

      Map<String, String> userData = await _getData(username);
      Map<String, List<Map<String, String>>> resepData = await _getResepData();

      setState(() {
        _userData = userData;
        _resepData = resepData;
      });
    }
  }

  Future<Map<String, String>> _getData(String username) async {
    DataSnapshot snapshot = await _dbRef
        .orderByChild('username')
        .equalTo(username)
        .once()
        .then((event) => event.snapshot);

    if (snapshot.value != null) {
      Map<dynamic, dynamic> data = snapshot.value as Map;
      Map<String, String> userData = {};
      data.forEach((key, value) {
        _userkey = key;
        userData['nama'] = value['nama'];
        userData['username'] = value['username'];
      });
      return userData;
    }
    return {};
  }

  Future<Map<String, List<Map<String, String>>>> _getResepData() async {
    DataSnapshot snapshot = await _dbResepRef.get();
    Map<String, List<Map<String, String>>> data = {'resep': []};

    for (var entry in snapshot.children) {
      String? idCreator = entry.child('id_creator').value as String?;
      String? judul = entry.child('judul').value as String?;
      String? deskripsi = entry.child('deskripsi').value as String?;
      String? foto = entry.child('foto').value as String?;

      if (idCreator == _userkey &&
          deskripsi != null &&
          judul != null &&
          foto != null) {
        Map<String, String> item = {
          'judul': judul,
          'deskripsi': deskripsi,
          'foto': 'lib/images/$foto',
          'recipeKey': entry.key!,
        };
        data['resep']?.add(item);
      }
    }

    print('Data: $data');
    return data;
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "COOKMANIA",
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20.0),
                _username == null ? _loggedOut() : _loggedIn(),
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
          currentIndex: 4,
          onTap: (int index) {
            switch (index) {
              case 0:
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
                break;
              case 1:
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchKetikPage(),
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
                break;
            }
          },
          selectedItemColor: Colors.yellow.shade800,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(color: Colors.yellow.shade800),
          showUnselectedLabels: true,
        ),
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
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.asset(
                'lib/images/foto.png',
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 20),
                      Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${_userData['nama']}",
                style: const TextStyle(
                  fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "@${_userData['username']}",
                style: const TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.red,
            onPressed: () async {
              _logout();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
        const SizedBox(height: 40.0),
        const Text(
          "Resep saya",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        ResepWidget(
          details: _resepData['resep']!,
          username: _username.toString(),
        ),
        const SizedBox(height: 40.0),
      ],
    );
  }
}

class ResepWidget extends StatefulWidget {
  final List<Map<String, String>> details;
  final String username;

  const ResepWidget({required this.details, required this.username, Key? key});

  @override
  State<ResepWidget> createState() => _ResepWidgetState();
}

class _ResepWidgetState extends State<ResepWidget> {
  void _navigateToRecipePage(int index) {
    String recipeKey = widget.details[index]['recipeKey']!;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditRecipe(
            recipeKey: recipeKey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: ListView.builder(
        itemCount: widget.details.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _navigateToRecipePage(index),
            child: Card(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    child: Image.asset(
                      widget.details[index]['foto']!,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Text(
                            widget.details[index]['judul']!,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Text(
                            widget.details[index]['deskripsi']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
