import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final DatabaseReference _resepRef =
      FirebaseDatabase.instance.ref().child('resep').child('1');
  final DatabaseReference _profileRef =
      FirebaseDatabase.instance.ref().child('profile');

  Map<String, dynamic> bahan = {};
  Map<String, dynamic> langkah = {};
  Map<String, dynamic> komentar = {};
  var judul = "";
  var deskripsi = "";
  var kalori = "";
  var durasi = "";
  var biaya = "";
  var negara = "";
  var porsi = ""; // Belum digunakan
  var foto = "";
  var id_creator = ""; // Belum digunakan
  var tanggal = ""; // Belum digunakan

  var username = "";
  var nama = "";
  var kota = "";
  var foto_prof = "";

  TextEditingController _commentController = TextEditingController();

  late Future<void> _data;

  @override
  void initState() {
    super.initState();
    _loadDataResep();
  }

  Future<void> _saveComment() async {
    DataSnapshot snapshot = await _resepRef.child('komentar').get();

    int count = snapshot.value != null ? (snapshot.value as Map).length : 0;
     String key = (count + 1).toString();

    String comment = _commentController.text;
    if (comment.isNotEmpty) {
      try {
        await _resepRef.child('komentar').child(key).set({
          'nama': 'Ninin',
          'komen': comment,
        });
        _commentController.clear();
        _loadDataResep();
      } catch (e) {
        print('Error saving comment: $e');
      }
    }
  }

  Future<void> _loadDataResep() async {
    try {
      DataSnapshot snapshot = await _resepRef.get();
      if (snapshot.exists) {
        setState(() {
          judul = snapshot.child('judul').value as String? ?? "Default Judul";
          deskripsi = snapshot.child('deskripsi').value as String? ?? "Default Deskripsi";
          kalori = snapshot.child('kalori').value.toString();
          biaya = snapshot.child('biaya').value.toString();
          negara = snapshot.child('negara').value as String? ?? "";
          durasi = snapshot.child('durasi').value.toString();
          foto = snapshot.child('foto').value as String? ?? "";
          id_creator = snapshot.child('id_creator').value as String? ?? "";
          tanggal = snapshot.child('tanggal').value as String? ?? "";
          _loadDataProfile(id_creator);

          // Memuat bahan
          DataSnapshot bahanSnapshot = snapshot.child('bahan');
          bahan = {};
          bahanSnapshot.children.forEach((entry) {
            String nama = entry.child('nama').value as String? ?? '';
            String takaran = entry.child('takaran').value as String? ?? '';
            bahan[entry.key ?? ''] = {'nama': nama, 'takaran': takaran};
          });

          // Memuat langkah
          DataSnapshot langkahSnapshot = snapshot.child('langkah');
          langkah = {};
          langkahSnapshot.children.forEach((entry) {
            langkah[entry.key ?? ''] = entry.value as String? ?? '';
          });

          DataSnapshot komentarSnapshot = snapshot.child('komentar');
          komentar = {};
          komentarSnapshot.children.forEach((entry) {
            String nama = entry.child('nama').value as String? ?? '';
            String komen = entry.child('komen').value as String? ?? '';
            komentar[entry.key ?? ''] = {'nama': nama, 'komen': komen};
          });

          print(langkah);
        });
      }
    } catch (e) {
      print('Error fetching recipe data: $e');
    }
  }

  Future<void> _loadDataProfile(String id_creator) async {
    try {
      DataSnapshot snapshot = await _profileRef.child(id_creator).get();
      if (snapshot.exists) {
        setState(() {
          nama = snapshot.child('nama').value as String? ?? "";
          username = snapshot.child('username').value as String? ?? "";
          kota = snapshot.child('kota').value as String? ?? "";
          foto_prof = snapshot.child('foto').value as String? ?? "";

          print(nama);
          print(foto_prof);
        });
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.file_download_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_border_rounded),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ----------------------------------IMAGE----------------------------------
              Image.asset(
                'lib/images/' + foto,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              // ----------------------------------TITLE AND RATING----------------------------------
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              judul,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'lib/images/beef.png',
                                height: 50.0,
                                width: 50.0,
                                // fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                                width: 10), // Jarak antara ClipOval dan Column

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nama,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "@" + username,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                    Text(
                                      kota,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            "Follow",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      deskripsi,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Diunggah pada tanggal " + tanggal ,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(
                      color: Colors.grey,
                      thickness: 1, // Ketebalan garis
                      height: 20, // Tinggi garis
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Negara Asal",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                negara,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Durasi",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                durasi + "menit",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Kalori",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                kalori + "/porsi",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Biaya",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Rp" + biaya,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1, // Ketebalan garis
                      height: 20, // Tinggi garis
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Bahan-bahan",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    ...bahan.entries.map((entry) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.value['nama'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    entry.value['takaran'],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            color: Color.fromARGB(255, 205, 205, 205),
                            thickness: 1,
                            height: 20,
                          ),
                        ],
                      );
                    }).toList(),
                    SizedBox(height: 10),
                    Text(
                      "Langkah-langkah",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    ...langkah.entries.map((entry) {
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    entry.key,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.value,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                      // maxLines: 2, // Maksimum 2 baris
                                      // overflow: TextOverflow.visible
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Color.fromARGB(255, 205, 205, 205),
                            thickness: 1,
                            height: 20,
                          ),
                        ],
                      );
                    }),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          color: Colors.black,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Komentar",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "1",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ...komentar.entries.map((entry) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(height: 20),
                              Text(
                                entry.value['nama'] + ". ",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    height: 2),
                              ),
                              SizedBox(width: 5),
                              Text(
                                entry.value['komen'],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    height: 2),
                              )
                            ],
                          ),
                        ],
                      );
                    }),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'lib/images/chicken.png',
                            height: 50.0,
                            width: 50.0,
                            // fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0), // Padding horizontal Container
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2.0), // Padding vertical
                              hintText: 'Masukkan teks...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )),
                        IconButton(
                            onPressed: _saveComment,
                            icon: const Icon(Icons.send_outlined))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}