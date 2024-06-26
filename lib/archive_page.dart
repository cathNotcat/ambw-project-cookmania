import 'package:cookmania/home_page.dart';
import 'package:cookmania/profilepage/profile_page.dart';
import 'package:cookmania/search/searchKetik_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('profile');
  final DatabaseReference _dbResepRef =
      FirebaseDatabase.instance.ref().child('resep');

  List<Map<String, String>> _resepList = [];
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
      print('username: $_username');
      _getData();
    });
  }

  Future<void> _getData() async {
    // ambil id dari username
    DataSnapshot userSnapshot = await _dbRef
        .orderByChild('username')
        .equalTo(_username!)
        .once()
        .then((event) => event.snapshot);

    if (userSnapshot.exists) {
      DataSnapshot userNode = userSnapshot.children.first;
      DataSnapshot archiveSnapshot = userNode.child('archive');

      dynamic archiveValue = archiveSnapshot.value;

      // archive dari id tersebut dibuka terus dimasukin list
      // if (archiveValue is List) {
      //   for (var value in archiveValue) {

      // archive dalam map
      if (archiveValue is Map) {
        for (var value in archiveValue.values) {
          DataSnapshot childSnapshot =
              await _dbResepRef.child(value.toString()).get();
          // untuk setiap id_resep, ambil data dari "resep"
          if (childSnapshot.exists) {
            String judul = childSnapshot.child('judul').value as String? ?? '';
            String foto = childSnapshot.child('foto').value as String? ?? '';
            String id_creator =
                childSnapshot.child('id_creator').value as String? ?? '';

            // ambil username berdasarkan id_creator
            DataSnapshot creatorSnapshot = await _dbRef.child(id_creator).get();
            String creatorUsername = '';
            if (creatorSnapshot.exists) {
              creatorUsername =
                  creatorSnapshot.child('username').value as String? ?? '';
            }

            setState(() {
              _resepList.add({
                'judul': judul,
                'foto': 'lib/images/$foto',
                'creator': '@$creatorUsername',
              });
            });
          } else {
            print('Resep dengan id $value tidak ditemukan.');
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "COOKMANIA",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Resep Tersimpan",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20.0),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: _resepList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                            child: Image.network(
                              _resepList[index]['foto']!,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _resepList[index]['creator']!,
                              style: const TextStyle(
                                  color: Colors.black45, fontSize: 12.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _resepList[index]['judul']!,
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
              label: "Profile", icon: Icon(Icons.person_outline)),
        ],
        currentIndex: 3,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
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
        selectedLabelStyle: const TextStyle(color: Colors.yellow),
        showUnselectedLabels: true,
      ),
    );
  }
}
