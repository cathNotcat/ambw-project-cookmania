import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PilihanNegara extends StatefulWidget {
  const PilihanNegara({super.key});

  @override
  State<PilihanNegara> createState() => _PilihanNegaraState();
}

class _PilihanNegaraState extends State<PilihanNegara> {
  final DatabaseReference _dbref =
      FirebaseDatabase.instance.ref().child('resep');

  late Future<Map<String, List<Map<String, String>>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchDataFromFirebase();
  }

  Future<Map<String, List<Map<String, String>>>> fetchDataFromFirebase() async {
    DataSnapshot snapshot = await _dbref.get();
    Map<String, List<Map<String, String>>> data = {};
    snapshot.children.forEach((recipeSnapshot) {
      String country = recipeSnapshot.child('negara').value as String;
      String title = recipeSnapshot.child('judul').value as String;
      String path = recipeSnapshot.child('path').value
          as String; // Assuming you also store the image path

      if (!data.containsKey(country)) {
        data[country] = [];
      }
      data[country]!.add({'path': path, 'name': title});
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(
                  text: 'Indonesian',
                ),
                Tab(
                  text: 'Chinese',
                ),
                Tab(
                  text: 'Japanese',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<Map<String, List<Map<String, String>>>>(
                future: _dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading data'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  } else {
                    return TabBarView(
                      children: [
                        PageViewWidget(
                            images: snapshot.data!['Indonesian'] ?? []),
                        PageViewWidget(images: snapshot.data!['Chinese'] ?? []),
                        PageViewWidget(
                            images: snapshot.data!['Japanese'] ?? []),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
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
