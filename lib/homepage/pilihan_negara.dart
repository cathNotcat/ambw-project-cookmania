import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PilihanNegara extends StatefulWidget {
  const PilihanNegara({super.key});

  @override
  State<PilihanNegara> createState() => _PilihanNegaraState();
}

class _PilihanNegaraState extends State<PilihanNegara> {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('resep');

  late Future<Map<String, List<Map<String, String>>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _getData();
  }

  Future<Map<String, List<Map<String, String>>>> _getData() async {
    DataSnapshot snapshot = await _dbRef.get();
    Map<String, List<Map<String, String>>> data = {
      'Indonesian': [],
      'Chinese': [],
      'Japanese': [],
    };

    for (var entry in snapshot.children) {
      String? negara = entry.child('negara').value as String?;
      String? judul = entry.child('judul').value as String?;
      String? foto = entry.child('foto').value as String?;
      // print('Judul: $judul, Foto: $foto, Negara: $negara');

      if (negara != null && judul != null && foto != null) {
        Map<String, String> item = {
          'path': 'lib/images/$foto',
          'name': judul,
        };

        if (negara.toLowerCase() == 'indonesian') {
          data['Indonesian']!.add(item);
        } else if (negara.toLowerCase() == 'chinese') {
          data['Chinese']!.add(item);
        } else if (negara.toLowerCase() == 'japanese') {
          data['Japanese']!.add(item);
        }
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<Map<String, String>>>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Map<String, List<Map<String, String>>> data = snapshot.data!;

          return SizedBox(
            height: 300,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    indicatorColor: Color.fromARGB(255, 245, 155, 11),
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 245, 155, 11)),
                    tabs: [
                      Tab(text: 'Indonesian'),
                      Tab(text: 'Chinese'),
                      Tab(text: 'Japanese'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: TabBarView(
                      children: [
                        PageViewWidget(images: data['Indonesian']!),
                        PageViewWidget(images: data['Chinese']!),
                        PageViewWidget(images: data['Japanese']!),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class PageViewWidget extends StatelessWidget {
  final List<Map<String, String>> images;

  const PageViewWidget({required this.images, super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: controller,
            children: images.map((image) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        image['path']!,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        child: Text(
                          image['name']!,
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
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10.0),
        SmoothPageIndicator(
          controller: controller,
          count: images.length,
          effect: JumpingDotEffect(
            activeDotColor: Colors.yellow.shade800,
            dotColor: const Color.fromARGB(255, 252, 226, 185),
            dotHeight: 10,
            dotWidth: 10,
            spacing: 16,
            verticalOffset: 10,
            jumpScale: 1.5,
          ),
        ),
      ],
    );
  }
}
