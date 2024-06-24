import 'package:flutter/material.dart';

class PilihanBahan extends StatelessWidget {
  final List<String> bahanIMG = [
    "chicken.png",
    "beef.png",
    "pork.png",
    "fish.png",
    "crab.png",
    "shrimp.png"
  ];
  final List<String> bahanText = [
    "Ayam",
    "Sapi",
    "Babi",
    "Ikan",
    "Kepiting",
    "Udang"
  ];

  PilihanBahan({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: List.generate(bahanIMG.length, (index) {
          return Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('lib/images/${bahanIMG[index]}', height: 70),
                Text(bahanText[index]),
              ],
            ),
          );
        }),
      ),
    );
  }
}
