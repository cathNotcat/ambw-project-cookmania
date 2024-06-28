import 'package:cookmania/archive_page.dart';
import 'package:cookmania/home_page.dart';
import 'package:cookmania/profilepage/login_page.dart';
import 'package:cookmania/profilepage/register_page.dart';
import 'package:cookmania/search/searchKetik_page.dart';
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

  late Future<Map<String, String>> _dataFuture;

  late Future<Map<String, List<Map<String, String>>>> _resepFuture;

  String? _username;
  String? _userkey;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _dataFuture = _getData();
    _resepFuture = _getResepData();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
      print('username: $_username');
      _dataFuture = _getData();
      _resepFuture = _getResepData();
    });
  }

  Future<Map<String, List<Map<String, String>>>> _getResepData() async {
    DataSnapshot snapshot = await _dbResepRef.get();
    Map<String, List<Map<String, String>>> data = {
      'resep': [],
    };

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
        };
        data['resep']?.add(item);
      }
    }
    return data;
  }

  Future<Map<String, String>> _getData() async {
    if (_username != null) {
      DataSnapshot snapshot = await _dbRef
          .orderByChild('username')
          .equalTo(_username)
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
    }
    return {};
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            FutureBuilder<Map<String, String>>(
              future: _dataFuture,
              builder: (context, snapshot) {
                if (_username == null) {
                  return _loggedOut();
                } else {
                  return _loggedIn(snapshot.data!);
                }
                // if (snapshot.hasError) {
                //   return Center(child: Text('Error: ${snapshot.error}'));
                // } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                //   return _loggedOut();
                // } else {
                //   return _loggedIn(snapshot.data!);
                // }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => const HomePage(),
              //   ),
              // );
              break;
            case 1:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SearchKetikPage(),
                ),
              );
              break;
            case 2:
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

  Widget _loggedIn(Map<String, String> userData) {
    return FutureBuilder<Map<String, List<Map<String, String>>>>(
      future: _resepFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Map<String, List<Map<String, String>>> data = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
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
                          "${userData['nama']}",
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "@${userData['username']}",
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40.0),
                const Text(
                  "Resep saya",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                // const SizedBox(height: 10.0),
                ResepWidget(details: data['resep']!),
                const SizedBox(height: 40.0),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                      onPressed: () async {
                        _logout();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                      },
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.yellow[800],
                          foregroundColor: Colors.black),
                      child: const Text(
                        "Log Out",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class ResepWidget extends StatelessWidget {
  final List<Map<String, String>> details;

  const ResepWidget({required this.details, Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: ListView.builder(
        itemCount: details.length,
        itemBuilder: (context, index) {
          if (index >= details.length) {
            return Container();
          }
          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        child: Image.asset(
                          details[index]['foto']!,
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
                                details[index]['judul']!,
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: Text(
                                details[index]['deskripsi']!,
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
              ),
            ],
          );
        },
      ),
    );
  }
}
