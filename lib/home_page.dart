import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _japanController = PageController();
  final _koreaController = PageController();
  final _italyController = PageController();

  @override
  void dispose() {
    _japanController.dispose();
    _koreaController.dispose();
    _italyController.dispose();
    super.dispose();
  }

  Widget buildPageView(
      PageController controller, List<Map<String, String>> images) {
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
            activeDotColor: Colors.deepPurple,
            dotColor: Colors.deepPurple.shade100,
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ----------------------------------TITLE----------------------------------
                const Center(
                  child: Text(
                    "COOKMANIA",
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20.0),
                // ----------------------------------SEARCH BAR----------------------------------
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Center(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Ketikkan bahan...',
                        hintStyle: TextStyle(fontSize: 16.0),
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('Ayam'),
                        onSelected: (bool selected) {},
                      ),
                      const SizedBox(width: 8.0),
                      FilterChip(
                        label: const Text('Sapi'),
                        onSelected: (bool selected) {},
                      ),
                      const SizedBox(width: 8.0),
                      FilterChip(
                        label: const Text('Kambing'),
                        onSelected: (bool selected) {},
                      ),
                      const SizedBox(width: 8.0),
                      FilterChip(
                        label: const Text('Kangkung'),
                        onSelected: (bool selected) {},
                      ),
                      const SizedBox(width: 8.0),
                      FilterChip(
                        label: const Text('Pisang'),
                        onSelected: (bool selected) {},
                      ),
                      const SizedBox(width: 8.0),
                      FilterChip(
                        label: const Text('Telur'),
                        onSelected: (bool selected) {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                // ----------------------------------TAB BAR----------------------------------
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Pilihan Negara Lain',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(
                            text: 'Japan',
                          ),
                          Tab(
                            text: 'Korea',
                          ),
                          Tab(
                            text: 'Italy',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 300,
                        child: TabBarView(
                          children: [
                            buildPageView(
                              _japanController,
                              [
                                {
                                  'path': 'lib/images/japan1.jpg',
                                  'name': 'Salmon Sushi'
                                },
                                {
                                  'path': 'lib/images/japan2.jpg',
                                  'name': 'Niku Udon'
                                },
                              ],
                            ),
                            buildPageView(
                              _koreaController,
                              [
                                {
                                  'path': 'lib/images/korea1.jpg',
                                  'name': 'Jjajangmyeon'
                                },
                                {
                                  'path': 'lib/images/korea2.jpg',
                                  'name': 'Tteokbokki'
                                },
                              ],
                            ),
                            buildPageView(
                              _italyController,
                              [
                                {
                                  'path': 'lib/images/itali1.jpg',
                                  'name': 'Cheese Raviolli'
                                },
                                {
                                  'path': 'lib/images/itali2.jpg',
                                  'name': 'Delicious Tiramisu for Dessert'
                                },
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // ----------------------------------List View----------------------------------
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bahan Pilihan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
