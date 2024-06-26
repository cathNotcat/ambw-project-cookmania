import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class EditRecipe extends StatefulWidget {
  final String recipeKey;

  const EditRecipe({super.key, required this.recipeKey});

  @override
  // ignore: library_private_types_in_public_api
  _EditRecipeState createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  final DatabaseReference _recipeRef =
      FirebaseDatabase.instance.ref().child('resep');

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _porsiController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _kaloriController = TextEditingController();

  final TextEditingController _ingredientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _stepController = TextEditingController();

  List<Map<String, dynamic>> _ingredients = [];
  List<String> _steps = [];

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    try {
      DataSnapshot snapshot = await _recipeRef.child(widget.recipeKey).get();
      if (snapshot.exists) {
        Map<String, dynamic> recipe =
            Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          _titleController.text = recipe['judul'];
          _descriptionController.text = recipe['deskripsi'];
          _countryController.text = recipe['negara'];
          _costController.text = recipe['biaya'].toString();
          _porsiController.text = recipe['porsi'].toString();
          _durationController.text = recipe['durasi'].toString();
          _kaloriController.text = recipe['kalori'].toString();

          // Memuat bahan
          DataSnapshot bahanSnapshot = snapshot.child('bahan');
          for (var entry in bahanSnapshot.children) {
            String nama = entry.child('nama').value as String? ?? '';
            String takaran = entry.child('takaran').value as String? ?? '';
            _ingredients.add({'nama': nama, 'takaran': takaran});
          }

          // Memuat langkah
          DataSnapshot langkahSnapshot = snapshot.child('langkah');
          for (var entry in langkahSnapshot.children) {
            String value = entry.value as String? ?? '';
            _steps.add(value);
          }
          // _ingredients = List<Map<String, dynamic>>.from(recipe['bahan']);
          // print(_ingredients);
          // _steps = List<String>.from(recipe['langkah']);
          // print(_steps);
        });
      }
    } catch (e) {
      print('Error loading recipe: $e');
    }
  }

  Future<void> _updateRecipe() async {
    Map<String, dynamic> updatedFields = {};

    if (_titleController.text.isNotEmpty) {
      updatedFields['judul'] = _titleController.text;
    }
    if (_descriptionController.text.isNotEmpty) {
      updatedFields['deskripsi'] = _descriptionController.text;
    }
    if (_countryController.text.isNotEmpty) {
      updatedFields['negara'] = _countryController.text;
    }
    if (_costController.text.isNotEmpty) {
      updatedFields['biaya'] = int.tryParse(_costController.text) ?? 0;
    }
    if (_porsiController.text.isNotEmpty) {
      updatedFields['porsi'] = int.tryParse(_porsiController.text) ?? 0;
    }
    if (_durationController.text.isNotEmpty) {
      updatedFields['durasi'] = int.tryParse(_durationController.text) ?? 0;
    }
    if (_kaloriController.text.isNotEmpty) {
      updatedFields['kalori'] = int.tryParse(_kaloriController.text) ?? 0;
    }
    if (_ingredients.isNotEmpty) {
      Map<String, dynamic> ingredientsMap = {};
      for (int i = 0; i < _ingredients.length; i++) {
        ingredientsMap[(i + 1).toString()] = _ingredients[i];
      }
      updatedFields['bahan'] = ingredientsMap;
    }
    if (_steps.isNotEmpty) {
      Map<String, dynamic> stepsMap = {};
      for (int i = 0; i < _steps.length; i++) {
        stepsMap[(i+1).toString()] = _steps[i];
      }
      updatedFields['langkah'] = stepsMap;
    }

    if (updatedFields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak ada perubahan untuk diperbarui')),
      );
      return;
    }

    // Map<String, dynamic> stepsMap = {};
    // for (int i = 1; i < _steps.length; i++) {
    //   stepsMap[i.toString()] = _steps[i];
    // }

    String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
    updatedFields['tanggal'] = formattedDate;

    _recipeRef.child(widget.recipeKey).update(updatedFields).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resep berhasil diperbarui')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui resep: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Recipe'),
        actions: [
          ElevatedButton(
            onPressed: _updateRecipe,
            child: Text(
              "Update",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Judul Resep',
                hintStyle:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Deskripsi',
                hintStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _countryController,
              decoration: InputDecoration(
                hintText: 'Negara Asal',
                hintStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _costController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Biaya',
                hintStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _porsiController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Porsi',
                hintStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Durasi',
                hintStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _kaloriController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Kalori',
                hintStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ingredientController,
                    decoration: InputDecoration(
                      hintText: 'Bahan',
                      hintStyle: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      hintText: 'Takaran',
                      hintStyle: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _ingredients.add({
                        'nama': _ingredientController.text,
                        'takaran': _amountController.text,
                      });
                      _ingredientController.clear();
                      _amountController.clear();
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            for (var ingredient in _ingredients)
              ListTile(
                title: Text('${ingredient['nama']} - ${ingredient['takaran']}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _ingredients.remove(ingredient);
                    });
                  },
                ),
              ),
            SizedBox(height: 16.0),
            TextField(
              controller: _stepController,
              decoration: InputDecoration(
                hintText: 'Langkah-langkah',
                hintStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _steps.add(_stepController.text);
                      _stepController.clear();
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0),
            for (var step in _steps)
              ListTile(
                title: Text(step),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _steps.remove(step);
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
