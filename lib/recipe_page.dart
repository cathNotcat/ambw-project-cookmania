import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final DatabaseReference _itemsRef =
      FirebaseDatabase.instance.ref().child('resep').child('1');

  late Future<Map<String, dynamic>> _data;

  @override
  void initState() {
    super.initState();
    _data = _getData();
  }

  Future<Map<String, dynamic>> _getData() async {
    DataSnapshot snapshot = await _itemsRef.get();

    // Inisialisasi struktur data yang sesuai
    Map<String, dynamic> data = {
      'judul': '',
      'deskripsi': [
        {'': ''},
      ],
    };

    // Ambil data dari snapshot
    String? judul = snapshot.child('judul').value as String?;
    String? deskripsi = snapshot.child('deskripsi').value as String?;

    // Tambahkan data ke dalam struktur yang diinginkan
    if (judul != null && deskripsi != null) {
      data['judul'] = [
        {'judul': judul}
      ];
      data['deskripsi'] = [
        {'deskripsi': deskripsi}
      ];
    }

    print('Judul: $judul, Deskripsi: $deskripsi');

    return data;
  }

  // Future<Map<String, List<Map<String, String>>>> _getData() async {
  //   DataSnapshot snapshot = await _itemsRef.get();

  //   for (var entry in snapshot.children) {
  //     String? judul = entry.child('judul').value as String?;
  //     String? deskripsi = entry.child('deskripsi').value as String?;
  //     List<String> bahan = entry.child('bahan').value as List<String>;
  //     Map<String, List<Map<String, String>>> data = {
  //       // 'judul': judul,
  //       // 'deskripsi': deskripsi,
  //     };

  //     return data;
  //   }
  // }

  @override
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
                'lib/images/japan1.jpg',
                height: 200,
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
                            "Chicken Katsu",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "4.5",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                            SizedBox(
                                width: 10), // Jarak antara ClipOval dan Column

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Lalalla",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "@Lalalulu",
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
                                      "Surabaya",
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
                      "deskripsi yang panjang pokoknya.......",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Diunggah pada tanggal 18 September 2021",
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
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Jepang",
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
                                "Negara Asal",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Jepang",
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
                                "Negara Asal",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Jepang",
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
                                "Negara Asal",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Jepang",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ayam",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "1/2 ekor",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        )
                      ],
                    ),
                    Divider(
                      color: Color.fromARGB(255, 205, 205, 205),
                      thickness: 1, // Ketebalan garis
                      height: 20, // Tinggi garis
                    ),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "1.",
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
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet.",
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
                    Image(
                      image: AssetImage('lib/images/chicken.png'),
                      height: 100,
                      width: 100,
                    ),
                    Divider(
                      color: Color.fromARGB(255, 205, 205, 205),
                      thickness: 1, // Ketebalan garis
                      height: 20, // Tinggi garis
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          color: Colors.black,
                        ),
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
                    Text(
                      "Lihat semua komentar",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
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
                        SizedBox(width: 10),
                        Text(
                          "Beni. Enakk banget",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
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
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2.0), // Padding vertical
                              hintText: 'Masukkan teks...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ))
                      ],
                    ),
                    Divider(
                      color: Color.fromARGB(255, 205, 205, 205),
                      thickness: 1, // Ketebalan garis
                      height: 20, // Tinggi garis
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Resep Lainnya",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              'lib/images/japan2.jpg',
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              "Chicken Katsu",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    'lib/images/chicken.png',
                                    height: 30.0,
                                    width: 30.0,
                                    // fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Lalalla",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset(
                              'lib/images/japan2.jpg',
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              "Chicken Katsu",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    'lib/images/chicken.png',
                                    height: 30.0,
                                    width: 30.0,
                                    // fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Lalalla",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              // ----------------------------------ADDITIONAL TEXT----------------------------------
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       "SUKA BANGETTTT",
              //       style: const TextStyle(
              //         color: Colors.black,
              //         fontSize: 16.0,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
