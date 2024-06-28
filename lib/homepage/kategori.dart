import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class KategoriPage extends StatefulWidget {
  final String kategori;

  const KategoriPage({required this.kategori, Key? key}) : super(key: key);

  @override
  _KategoriPageState createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  final DatabaseReference _dbResepRef = FirebaseDatabase.instance.ref().child('resep');
  late Future<List<Map<String, String>>> _resepFuture;

  @override
  void initState() {
    super.initState();
    _resepFuture = _getResepData();
  }

  Future<List<Map<String, String>>> _getResepData() async {
    print('Querying for category: ${widget.kategori}');
    DataSnapshot snapshot = await _dbResepRef.orderByChild('kategori').equalTo(widget.kategori.toLowerCase()).get();
    List<Map<String, String>> resepList = [];

    for (var entry in snapshot.children) {
      String? judul = entry.child('judul').value as String?;
      String? foto = entry.child('foto').value as String?;

      if (judul != null && foto != null) {
        resepList.add({
          'judul': judul,
          'foto': 'lib/images/$foto',
        });
      }
    }
    return resepList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('${widget.kategori}')),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0, bottom: 20),
        child: FutureBuilder<List<Map<String, String>>>(
          future: _resepFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No recipes found.'));
            } else {
              List<Map<String, String>> resepList = snapshot.data!;
              return ListView.builder(
                itemCount: resepList.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: double.infinity,
                    child: Card(
                      child: Stack(
                        children: [
                          Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            child: Image.asset(
                              resepList[index]['foto']!,      
                              width: double.infinity,   
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                          const SizedBox(width: 10),
                          Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            
                            color: Colors.black.withOpacity(0.5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: 
                                Text(
                                  resepList[index]['judul']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
