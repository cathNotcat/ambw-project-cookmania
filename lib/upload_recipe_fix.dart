// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:intl/intl.dart';

// class UploadRecipe extends StatefulWidget {
//   const UploadRecipe({Key? key}) : super(key: key);

//   @override
//   _UploadRecipeState createState() => _UploadRecipeState();
// }

// class _UploadRecipeState extends State<UploadRecipe> {
//   final DatabaseReference _recipeRef =
//       FirebaseDatabase.instance.ref().child('resep');

//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _countryController = TextEditingController();
//   final TextEditingController _costController = TextEditingController();
//   final TextEditingController _porsiController = TextEditingController();
//   final TextEditingController _durationController = TextEditingController();
//   final TextEditingController _kaloriController = TextEditingController();

//   final TextEditingController _ingredientController = TextEditingController();
//   final TextEditingController _amountController = TextEditingController();
//   final TextEditingController _stepController = TextEditingController();

//   List<Map<String, dynamic>> _ingredients = [];
//   List<String> _steps = [];

//   final DatabaseReference _allresepRef =
//       FirebaseDatabase.instance.ref().child('resep');

//   var recipeCount = 0;
//   var key;

//   @override
//   void initState() {
//     super.initState();
//     _getRecipeCount();
//   }

//   Future<void> _getRecipeCount() async {
//     try {
//       // Use once() to fetch a single snapshot
//       DataSnapshot snapshot = await _allresepRef.get();

//       int count = snapshot.value != null ? (snapshot.value as Map).length : 0;
//       key = (count + 1).toString();
//       // if (dataSnapshot.value != null && dataSnapshot.value is Map) {
//       //   setState(() {
//       //     // Assuming 'resep' node contains map structure
//       //     recipeCount = dataSnapshot.value.hashCode;
//       //   });
//       // }
//       print("key" + key);
//     } catch (e) {
//       print('Error fetching recipe count: $e');
//     }
//   }

//   Future<void> _saveRecipe() async {
//     // Validate input
//     if (_titleController.text.isEmpty ||
//         _descriptionController.text.isEmpty ||
//         _countryController.text.isEmpty ||
//         _costController.text.isEmpty ||
//         _ingredients.isEmpty ||
//         _steps.isEmpty ||
//         _porsiController.text.isEmpty ||
//         _durationController.text.isEmpty ||
//         _kaloriController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Semua kolom harus diisi')),
//       );
//       return;
//     }

//     // Convert numerical values
//     int cost = int.tryParse(_costController.text) ?? 0;
//     int porsi = int.tryParse(_porsiController.text) ?? 0;
//     int duration = int.tryParse(_durationController.text) ?? 0;
//     int kalori = int.tryParse(_kaloriController.text) ?? 0;

//     // Get the number of existing recipes

//     // DataSnapshot snapshot = await _recipeRef.get();
//     // int count = snapshot.value != null ? (snapshot.value as Map).length : 0;
//     // String key = (count + 1).toString();
//     // Simpan resep ke Firebase Database
//     // Convert list of maps to a map with unique keys

//     Map<String, dynamic> ingredientsMap = {};
//     for (int i = 1; i < _ingredients.length; i++) {
//       ingredientsMap[i.toString()] = _ingredients[i];
//     }

//     // Convert list of steps to a map with unique keys
//     Map<String, dynamic> stepsMap = {};
//     for (int i = 1; i < _steps.length; i++) {
//       stepsMap[i.toString()] = _steps[i];
//     }

//     print("masuk sini");
//     String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());

//     print(formattedDate);

//     _recipeRef.push().set({
//       'judul': _titleController.text,
//       'deskripsi': _descriptionController.text,
//       'negara': _countryController.text,
//       'biaya': cost,
//       'bahan': _ingredients,
//       'langkah': _steps,
//       'porsi': porsi,
//       'durasi': duration,
//       'kalori': kalori,
//       'id_creator': 'user1',
//       'komentar': {},
//       'foto': "default.png",
//       'tanggal': formattedDate,
//     }).then((_) {
//       // Berhasil menyimpan
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Resep berhasil diunggah')),
//       );
//       // Reset input setelah disimpan
//       _titleController.clear();
//       _descriptionController.clear();
//       _countryController.clear();
//       _costController.clear();
//       _ingredientController.clear();
//       _stepController.clear();
//       _porsiController.clear();
//       _durationController.clear();
//       _kaloriController.clear();

//       setState(() {
//         _ingredients.clear();
//         _steps.clear();
//       });
//     }).catchError((error) {
//       // Gagal menyimpan
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Gagal mengunggah resep: $error')),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload Recipe'),
//         actions: [
//           ElevatedButton(
//             onPressed: _saveRecipe,
//             child: Text(
//               "Simpan",
//               style: TextStyle(
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title Input
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(
//                 hintText: 'Judul Resep',
//                 hintStyle:
//                     TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16.0),

//             // Description Input
//             TextField(
//               controller: _descriptionController,
//               maxLines: 3,
//               decoration: InputDecoration(
//                 hintText: 'Deskripsi',
//                 hintStyle:
//                     TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16.0),

//             // Country Input
//             TextField(
//               controller: _countryController,
//               decoration: InputDecoration(
//                 hintText: 'Negara Asal',
//                 hintStyle:
//                     TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16.0),

//             // Cost Input
//             TextField(
//               controller: _costController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 hintText: 'Biaya',
//                 hintStyle:
//                     TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16.0),

//             TextField(
//               controller: _porsiController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 hintText: 'porsi',
//                 hintStyle:
//                     TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16.0),

//             TextField(
//               controller: _durationController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 hintText: 'Durasi',
//                 hintStyle:
//                     TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16.0),

//             TextField(
//               controller: _kaloriController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 hintText: 'Kalori',
//                 hintStyle:
//                     TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                 border: OutlineInputBorder(),
//               ),
//             ),

//             SizedBox(height: 16.0),

//             // Ingredients Input
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _ingredientController,
//                     decoration: InputDecoration(
//                       hintText: 'Bahan',
//                       hintStyle: TextStyle(
//                           fontSize: 16.0, fontWeight: FontWeight.bold),
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8.0),
//                 Expanded(
//                   child: TextField(
//                     controller: _amountController,
//                     decoration: InputDecoration(
//                       hintText: 'Takaran',
//                       hintStyle: TextStyle(
//                           fontSize: 16.0, fontWeight: FontWeight.bold),
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.add),
//                   onPressed: () {
//                     setState(() {
//                       _ingredients.add({
//                         'nama': _ingredientController.text,
//                         'takaran': _amountController.text,
//                       });
//                       _ingredientController.clear();
//                       _amountController.clear();
//                     });
//                   },
//                 ),
//               ],
//             ),
//             SizedBox(height: 16.0),
//             for (var ingredient in _ingredients)
//               ListTile(
//                 title: Text('${ingredient['nama']} - ${ingredient['takaran']}'),
//                 trailing: IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () {
//                     setState(() {
//                       _ingredients.remove(ingredient);
//                     });
//                   },
//                 ),
//               ),
//             SizedBox(height: 16.0),

//             // Steps Input
//             // Steps Input
//             TextField(
//               controller: _stepController,
//               decoration: InputDecoration(
//                 hintText: 'Langkah-langkah',
//                 hintStyle:
//                     TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                 border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.add),
//                   onPressed: () {
//                     setState(() {
//                       _steps.add(_stepController.text);
//                       _stepController.clear();
//                     });
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             for (var step in _steps)
//               ListTile(
//                 title: Text(step),
//                 trailing: IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () {
//                     setState(() {
//                       _steps.remove(step);
//                     });
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
