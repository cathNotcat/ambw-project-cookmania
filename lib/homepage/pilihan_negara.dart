import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PilihanNegara extends StatelessWidget {
  const PilihanNegara({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: const DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
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
            SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                children: [
                  PageViewWidget(
                    images: [
                      {
                        'path': 'lib/images/indo1.jpg',
                        'name': 'Nasi Goreng Abang2'
                      },
                      {
                        'path': 'lib/images/indo2.jpg',
                        'name': 'Nasi Goreng Ayam'
                      },
                      {
                        'path': 'lib/images/indo3.jpg',
                        'name': 'Dori Telur Asin'
                      },
                    ],
                  ),
                  PageViewWidget(
                    images: [
                      {
                        'path': 'lib/images/chinese1.jpg',
                        'name': 'Nasi Goreng Kepiting'
                      },
                      {
                        'path': 'lib/images/chinese2.jpg',
                        'name': 'Nasi Goreng Lapjiong'
                      },
                      {
                        'path': 'lib/images/chinese3.jpg',
                        'name': 'Ayam Saos Inggris'
                      },
                    ],
                  ),
                  PageViewWidget(
                    images: [
                      {
                        'path': 'lib/images/japan1.jpg',
                        'name': 'Ayam Tepanyaki'
                      },
                      {
                        'path': 'lib/images/japan2.jpg',
                        'name': 'Sapi Tepanyaki'
                      },
                      {
                        'path': 'lib/images/japan3.jpg',
                        'name': 'Udang Tempura'
                      },
                    ],
                  ),
                ],
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
