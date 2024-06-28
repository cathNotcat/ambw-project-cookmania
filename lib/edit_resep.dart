// import 'dart:js_interop';

import 'package:cookmania/home_page.dart';
import 'package:cookmania/profilepage/profile_page.dart';
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
  // final TextEditingController _countryController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _porsiController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _kaloriController = TextEditingController();

  final TextEditingController _ingredientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _stepController = TextEditingController();

  final List<Map<String, dynamic>> _ingredients = [];
  final List<String> _steps = [];

  String dropdownNegaraValue =
      'Indonesian'; // Default value or initialize as needed
  List<String> listNegara = ['Indonesian', 'Chinese', 'Japanese'];

  String dropdownKategoriValue =
      'Ayam'; // Default value or initialize as needed
  List<String> listKategori = [
    'Ayam',
    'Daging',
    'Babi',
    'Ikan',
    'Kepiting',
    'Udang'
  ]; // Dropdown options

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
          _costController.text = recipe['biaya'].toString();
          _porsiController.text = recipe['porsi'].toString();
          _durationController.text = recipe['durasi'].toString();
          _kaloriController.text = recipe['kalori'].toString();
          dropdownNegaraValue = recipe['negara'];
          dropdownKategoriValue = recipe['kategori'];

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

  Future<void> _deleteRecipe() async {
    try {
      await _recipeRef.child(widget.recipeKey).remove();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resep berhasil dihapus')),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ),
      );
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => const HomePage(),
      //   ),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus resep: $e')),
      );
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
        stepsMap[(i + 1).toString()] = _steps[i];
      }
      updatedFields['langkah'] = stepsMap;
    }
    if (dropdownNegaraValue.isNotEmpty) {
      updatedFields['negara'] = dropdownNegaraValue;
    }
    if (dropdownKategoriValue.isNotEmpty) {
      updatedFields['kategori'] = dropdownKategoriValue;
    }

    if (updatedFields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada perubahan untuk diperbarui')),
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
        const SnackBar(content: Text('Resep berhasil diperbarui')),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ),
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
        backgroundColor: Color.fromARGB(255, 240, 240, 225),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2.0, // Nilai ini mengatur ketebalan shadow
          shadowColor: Colors.black87,
          title: Text('Upload Resep'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            OutlinedButton(
              onPressed: _updateRecipe,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Sudut border
                ),
                side: BorderSide(color: Colors.grey),
              ),
              child: Text(
                "Update",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
            SizedBox(width: 16.0),
            FilledButton(
              onPressed: _deleteRecipe,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Sudut border
                ),
                backgroundColor: Colors.orange,
              ),
              child: Text(
                "Hapus",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 16.0),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          // Informasi Resep
          Container(
            color: Colors.white,
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Informasi Resep
                      Text(
                        'Informasi Resep',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'Judul: Mie goreng suka-suka',
                          hintStyle: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black38,
                              fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black38, width: 2.0)),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _descriptionController,
                        maxLines: null,
                        maxLength: 1500,
                        decoration: InputDecoration(
                          hintMaxLines: 4,
                          hintText:
                              'Cerita dibalik masakan ini. Apa atau siapa yang menginspirasimu? Apa yang membuatnya istimewa? Bagaimana caramu menikmatinya?',
                          hintStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black38,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),

                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          SizedBox(
                            width:
                                120.0, // Tentukan lebar yang konsisten untuk teks label
                            child: Text(
                              'Biaya ',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _costController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Rp 200000',
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black38,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          SizedBox(
                            width:
                                120.0, // Tentukan lebar yang konsisten untuk teks label
                            child: Text(
                              'Kalori ',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _kaloriController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: '120 kalori',
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black38,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          SizedBox(
                            width:
                                120.0, // Tentukan lebar yang konsisten untuk teks label
                            child: Text(
                              'Jumlah sajian ',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _porsiController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: '2 porsi',
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black38,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(children: [
                        SizedBox(
                          width:
                              120.0, // Tentukan lebar yang konsisten untuk teks label
                          child: Text(
                            'Durasi ',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _durationController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: '20 menit',
                              hintStyle: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black38,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ]),

                      SizedBox(height: 16.0),
                      Row(children: [
                        SizedBox(
                          width:
                              120.0, // Tentukan lebar yang konsisten untuk teks label
                          child: Text(
                            'NegaraAsal ',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DropdownMenu<String>(
                          initialSelection: dropdownNegaraValue,
                          onSelected: (String? value) {
                            setState(() {
                              dropdownNegaraValue = value!;
                            });
                          },
                          // menu
                          dropdownMenuEntries: listNegara
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                              value: value,
                              label: value,
                              style: MenuItemButton.styleFrom(

                                  // backgroundColor: Colors.orange,
                                  // foregroundColor: Colors.grey,
                                  ),
                            );
                          }).toList(),
                        ),
                      ]),

                      SizedBox(height: 16.0),
                      Row(children: [
                        SizedBox(
                          width:
                              120.0, // Tentukan lebar yang konsisten untuk teks label
                          child: Text(
                            'Kategori ',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DropdownMenu<String>(
                          initialSelection: dropdownKategoriValue,
                          onSelected: (String? value) {
                            setState(() {
                              dropdownKategoriValue = value!;
                            });
                          },
                          dropdownMenuEntries: listKategori
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                              value: value,
                              label: value,
                            );
                          }).toList(),
                        ),
                      ])
                    ])),
          ),

          SizedBox(height: 16.0),
          //
          Container(
            color: Colors.white, // Warna latar belakang container
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bahan-bahan',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ingredientController,
                          decoration: InputDecoration(
                            hintText: 'Nama bahan',
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
                          if (_ingredientController.text.isNotEmpty &&
                              _amountController.text.isNotEmpty) {
                            setState(() {
                              _ingredients.add({
                                'nama': _ingredientController.text,
                                'takaran': _amountController.text,
                              });
                              _ingredientController.clear();
                              _amountController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Column(
                    children: [
                      ..._ingredients.asMap().entries.map((entry) {
                        var index = entry.key;
                        var ingredient = entry.value;
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                  '${ingredient['nama']} - ${ingredient['takaran']}'),
                              trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      _ingredients.remove(ingredient);
                                    });
                                  }),
                            ),
                            if (index < _ingredients.length - 1)
                              const Divider(), // Add divider except for the last item
                          ],
                        );
                      }).toList(),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16.0),
          Container(
              color: Colors.white, // Warna latar belakang container
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Langkah-langkah',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _stepController,
                        decoration: InputDecoration(
                          hintText: 'Langkah-langkah',
                          hintStyle: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if (_stepController.text.isNotEmpty) {
                                setState(() {
                                  _steps.add(_stepController.text);
                                  _stepController.clear();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Column(
                        children: [
                          ..._steps.asMap().entries.map((entry) {
                            var index = entry.key;
                            var step = entry.value;
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(step),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        _steps.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                                if (index < _steps.length - 1)
                                  Divider(), // Add divider except for the last item
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                      // SizedBox(height: 16.0),
                    ],
                  )))
        ])));
    //
  }
}
