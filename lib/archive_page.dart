import 'package:cookmania/home_page.dart';
import 'package:cookmania/profilepage/profile_page.dart';
import 'package:cookmania/search/searchKetik_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({Key? key}) : super(key: key);

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
    DataSnapshot userSnapshot = await _dbRef
        .orderByChild('username')
        .equalTo(_username!)
        .once()
        .then((event) => event.snapshot);

    if (userSnapshot.exists) {
      DataSnapshot userNode = userSnapshot.children.first;
      DataSnapshot archiveSnapshot = userNode.child('archive');

      dynamic archiveValue = archiveSnapshot.value;

      if (archiveValue is List) {
        for (var value in archiveValue) {
          DataSnapshot childSnapshot =
              await _dbResepRef.child(value.toString()).get();

          if (childSnapshot.exists) {
            String judul = childSnapshot.child('judul').value as String? ?? '';
            String foto = childSnapshot.child('foto').value as String? ?? '';
            String deskripsi =
                childSnapshot.child('deskripsi').value as String? ?? '';
            print('judul: $judul');

            setState(() {
              _resepList.add({
                'judul': judul,
                'deskripsi': deskripsi,
                'foto': 'lib/images/$foto',
              });
            });
            print(_resepList);
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
                        Image.network(
                          _resepList[index]['foto']!,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          _resepList[index]['judul']!,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          _resepList[index]['deskripsi']!,
                          style: const TextStyle(fontSize: 12.0),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
              // Navigasi ke halaman upload
              break;
            case 3:
              // Tidak melakukan apa-apa karena sudah berada di halaman Archive
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



// import 'package:cookmania/home_page.dart';
// import 'package:cookmania/profilepage/profile_page.dart';
// import 'package:cookmania/search/searchKetik_page.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ArchivePage extends StatefulWidget {
//   const ArchivePage({super.key});

//   @override
//   State<ArchivePage> createState() => _ArchivePageState();
// }

// class _ArchivePageState extends State<ArchivePage> {
//   final DatabaseReference _dbRef =
//       FirebaseDatabase.instance.ref().child('profile');
//   final DatabaseReference _dbResepRef =
//       FirebaseDatabase.instance.ref().child('resep');

//   late Future<List<Map<String, String>>> _dataFuture;

//   String? _username;

//   @override
//   void initState() {
//     super.initState();
//     _loadUsername();
//     // _dataFuture = _getData();
//   }

//   Future<void> _loadUsername() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _username = prefs.getString('username');
//       print('username: $_username');
//       _getData();
//       // _dataFuture = _getData();
//     });
//   }

//   Future<void> _getData() async {
//     DataSnapshot userSnapshot = await _dbRef
//         .orderByChild('username')
//         .equalTo(_username!)
//         .once()
//         .then((event) => event.snapshot);

//     if (userSnapshot.exists) {
//       DataSnapshot userNode = userSnapshot.children.first;
//       DataSnapshot archiveSnapshot = userNode.child('archive');

//       dynamic archiveValue = archiveSnapshot.value;

//       if (archiveValue is List) {
//         for (var value in archiveValue) {
//           DataSnapshot childSnapshot =
//               await _dbResepRef.child(value.toString()).get();

//           if (childSnapshot.exists) {
//             String judul = childSnapshot.child('judul').value as String? ?? '';
//             String foto = childSnapshot.child('foto').value as String? ?? '';
//             String deskripsi =
//                 childSnapshot.child('deskripsi').value as String? ?? '';

//             print('judul: $judul, deskripsi: $deskripsi, foto: $foto');
//           } else {
//             print('Resep dengan id $value tidak ditemukan.');
//           }
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // ----------------------------------TITLE----------------------------------
//               const Center(
//                 child: Text(
//                   "COOKMANIA",
//                   style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 20.0),
//               Container(
//                 height: 500,
//                 child: GridView.count(
//                   primary: false,
//                   padding: const EdgeInsets.all(10.0),
//                   crossAxisSpacing: .1,
//                   mainAxisSpacing: .1,
//                   crossAxisCount: 2,
//                   children: List.generate(4, (index) {
//                     return Card(
//                       child: Container(
//                         padding: const EdgeInsets.all(1),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Image.asset('lib/images/foto.png',
//                                 height: 120, fit: BoxFit.cover),
//                             Text(
//                               'Judul',
//                               style: TextStyle(fontSize: 16.0),
//                             ),
//                             Text(
//                               'Deskripsi',
//                               style: TextStyle(fontSize: 12.0),
//                               maxLines: 1,
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(
//               label: "Home", icon: Icon(Icons.home_outlined)),
//           BottomNavigationBarItem(
//               label: "Search", icon: Icon(Icons.search_outlined)),
//           BottomNavigationBarItem(
//               label: "Upload", icon: Icon(Icons.add_box_rounded)),
//           BottomNavigationBarItem(
//               label: "Archive", icon: Icon(Icons.bookmark_outline)),
//           BottomNavigationBarItem(
//               label: "Profile", icon: Icon(Icons.person_2_outlined)),
//         ],
//         currentIndex: 3,
//         onTap: (int index) {
//           switch (index) {
//             case 0:
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => const HomePage(),
//                 ),
//               );
//               break;
//             case 1:
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => const SearchKetikPage(),
//                 ),
//               );
//               break;
//             case 2:
//               // Navigator.of(context).push(
//               //   MaterialPageRoute(
//               //     builder: (context) => UploadPage(),
//               //   ),
//               // );
//               break;
//             case 3:
//               break;
//             case 4:
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => const ProfilePage(),
//                 ),
//               );
//               break;
//           }
//         },
//         selectedItemColor: Colors.yellow.shade800,
//         unselectedItemColor: Colors.grey,
//         selectedLabelStyle: TextStyle(color: Colors.yellow.shade800),
//         showUnselectedLabels: true,
//       ),
//     );
//   }
// }
