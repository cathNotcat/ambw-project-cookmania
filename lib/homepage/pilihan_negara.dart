import 'package:cookmania/recipe_page_fix.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PilihanNegara extends StatefulWidget {
  const PilihanNegara({Key? key}) : super(key: key);

  @override
  State<PilihanNegara> createState() => _PilihanNegaraState();
}

class _PilihanNegaraState extends State<PilihanNegara> {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('resep');
  late Future<Map<String, List<Map<String, String>>>> _dataFuture;
  late String _username; // to store the username from SharedPreferences

  @override
  void initState() {
    super.initState();
    _dataFuture = _getData();
    _loadUsername(); // Load username from SharedPreferences
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username =
          prefs.getString('username') ?? ''; // Replace 'username' with your key
    });
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

      if (negara != null && judul != null && foto != null) {
        Map<String, String> item = {
          'path': 'lib/images/$foto',
          'name': judul,
          'recipeKey': entry.key!, // Store the recipe key here
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
                        PageViewWidget(
                            images: data['Indonesian']!, username: _username),
                        PageViewWidget(
                            images: data['Chinese']!, username: _username),
                        PageViewWidget(
                            images: data['Japanese']!, username: _username),
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

class PageViewWidget extends StatefulWidget {
  final List<Map<String, String>> images;
  final String username;

  const PageViewWidget({required this.images, required this.username, Key? key})
      : super(key: key);

  @override
  State<PageViewWidget> createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  List<bool> _isArchived = [];

  @override
  void initState() {
    super.initState();
    _isArchived = List<bool>.filled(widget.images.length, false);
  }

  void _toggleBookmark(int index) {
    setState(() {
      _isArchived[index] = !_isArchived[index];
    });
  }

  void _navigateToRecipePage(int index) {
    String recipeKey = widget.images[index]['recipeKey']!;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RecipePage(user: widget.username, recipeKey: recipeKey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: controller,
            children: widget.images.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, String> image = entry.value;
              return GestureDetector(
                onTap: () => _navigateToRecipePage(index),
                child: Padding(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                image['name']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10.0),
        SmoothPageIndicator(
          controller: controller,
          count: widget.images.length,
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

// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// class PilihanNegara extends StatefulWidget {
//   const PilihanNegara({super.key});

//   @override
//   State<PilihanNegara> createState() => _PilihanNegaraState();
// }

// class _PilihanNegaraState extends State<PilihanNegara> {
//   final DatabaseReference _dbRef =
//       FirebaseDatabase.instance.ref().child('resep');

//   late Future<Map<String, List<Map<String, String>>>> _dataFuture;

//   @override
//   void initState() {
//     super.initState();
//     _dataFuture = _getData();
//   }

//   Future<Map<String, List<Map<String, String>>>> _getData() async {
//     DataSnapshot snapshot = await _dbRef.get();
//     Map<String, List<Map<String, String>>> data = {
//       'Indonesian': [],
//       'Chinese': [],
//       'Japanese': [],
//     };

//     for (var entry in snapshot.children) {
//       String? negara = entry.child('negara').value as String?;
//       String? judul = entry.child('judul').value as String?;
//       String? foto = entry.child('foto').value as String?;
//       // print('Judul: $judul, Foto: $foto, Negara: $negara');

//       if (negara != null && judul != null && foto != null) {
//         Map<String, String> item = {
//           'path': 'lib/images/$foto',
//           'name': judul,
//         };

//         if (negara.toLowerCase() == 'indonesian') {
//           data['Indonesian']!.add(item);
//         } else if (negara.toLowerCase() == 'chinese') {
//           data['Chinese']!.add(item);
//         } else if (negara.toLowerCase() == 'japanese') {
//           data['Japanese']!.add(item);
//         }
//       }
//     }
//     return data;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Map<String, List<Map<String, String>>>>(
//       future: _dataFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else {
//           Map<String, List<Map<String, String>>> data = snapshot.data!;

//           return SizedBox(
//             height: 300,
//             child: DefaultTabController(
//               length: 3,
//               child: Column(
//                 children: [
//                   const TabBar(
//                     indicatorColor: Color.fromARGB(255, 245, 155, 11),
//                     labelStyle:
//                         TextStyle(color: Color.fromARGB(255, 245, 155, 11)),
//                     tabs: [
//                       Tab(text: 'Indonesian'),
//                       Tab(text: 'Chinese'),
//                       Tab(text: 'Japanese'),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Expanded(
//                     child: TabBarView(
//                       children: [
//                         PageViewWidget(images: data['Indonesian']!),
//                         PageViewWidget(images: data['Chinese']!),
//                         PageViewWidget(images: data['Japanese']!),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }
// }

// class PageViewWidget extends StatefulWidget {
//   final List<Map<String, String>> images;

//   const PageViewWidget({required this.images, super.key});

//   @override
//   State<PageViewWidget> createState() => _PageViewWidgetState();
// }

// class _PageViewWidgetState extends State<PageViewWidget> {
//   List<bool> _isArchived = [];

//   @override
//   void initState() {
//     super.initState();
//     _isArchived = List<bool>.filled(widget.images.length, false);
//   }

//   void _toggleBookmark(int index) {
//     setState(() {
//       _isArchived[index] = !_isArchived[index];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final PageController controller = PageController();

//     return Column(
//       children: [
//         Expanded(
//           child: PageView(
//             controller: controller,
//             children: widget.images.asMap().entries.map((entry) {
//               int index = entry.key;
//               Map<String, String> image = entry.value;
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10.0),
//                       child: Image.asset(
//                         image['path']!,
//                         width: MediaQuery.of(context).size.width,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 0.0,
//                       left: 0.0,
//                       right: 0.0,
//                       child: Container(
//                         color: Colors.black.withOpacity(0.5),
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 5.0, horizontal: 10.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               image['name']!,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () => _toggleBookmark(index),
//                               child: Icon(
//                                 _isArchived[index]
//                                     ? Icons.bookmark
//                                     : Icons.bookmark_outline,
//                                 color: const Color.fromARGB(255, 248, 175, 18),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//         const SizedBox(height: 10.0),
//         SmoothPageIndicator(
//           controller: controller,
//           count: widget.images.length,
//           effect: JumpingDotEffect(
//             activeDotColor: Colors.yellow.shade800,
//             dotColor: const Color.fromARGB(255, 252, 226, 185),
//             dotHeight: 10,
//             dotWidth: 10,
//             spacing: 16,
//             verticalOffset: 10,
//             jumpScale: 1.5,
//           ),
//         ),
//       ],
//     );
//   }
// }
