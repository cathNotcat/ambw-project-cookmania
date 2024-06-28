// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class UploadRecipe extends StatefulWidget {
  final String user;
  const UploadRecipe({super.key, required this.user});

  @override
  _UploadRecipeState createState() => _UploadRecipeState();
}

class _UploadRecipeState extends State<UploadRecipe> {
  final DatabaseReference _recipeRef =
      FirebaseDatabase.instance.ref().child('resep');

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _namaMakananController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _porsiController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _kaloriController = TextEditingController();

  final TextEditingController _ingredientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _stepController = TextEditingController();

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

  final List<Map<String, dynamic>> _ingredients = [];
  final List<String> _steps = [];

  final DatabaseReference _allresepRef =
      FirebaseDatabase.instance.ref().child('resep');

  var recipeCount = 0;
  var key;

  @override
  void initState() {
    super.initState();
    print('user: ${widget.user}');

    // _getRecipeCount();s
  }

  // Future<void> _getRecipeCount() async {
  //   try {
  //     // Use once() to fetch a single snapshot
  //     DataSnapshot snapshot = await _allresepRef.get();

  //     int count = snapshot.value != null ? (snapshot.value as Map).length : 0;
  //     key = (count + 1).toString();

  //     print("key" + key);
  //   } catch (e) {
  //     print('Error fetching recipe count: $e');
  //   }
  // }

  Future<void> _saveRecipe() async {
    // Validate input
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _namaMakananController.text.isEmpty ||
        _costController.text.isEmpty ||
        _ingredients.isEmpty ||
        _steps.isEmpty ||
        _porsiController.text.isEmpty ||
        _durationController.text.isEmpty ||
        _kaloriController.text.isEmpty ||
        dropdownNegaraValue.isEmpty ||
        dropdownKategoriValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua kolom harus diisi')),
      );
      return;
    }

    // Convert numerical values
    int cost = int.tryParse(_costController.text) ?? 0;
    int porsi = int.tryParse(_porsiController.text) ?? 0;
    int duration = int.tryParse(_durationController.text) ?? 0;
    int kalori = int.tryParse(_kaloriController.text) ?? 0;

    print("cek pckd:  $cost   $duration $kalori $porsi" );

    Map<String, dynamic> ingredientsMap = {};
    for (int i = 1; i < _ingredients.length; i++) {
      ingredientsMap[i.toString()] = _ingredients[i];
    }

    // Convert list of steps to a map with unique keys
    Map<String, dynamic> stepsMap = {};
    for (int i = 1; i < _steps.length; i++) {
      stepsMap[i.toString()] = _steps[i];
    }

    print("masuk sini");
    String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());

    print(formattedDate);

    var komentar = {
      '0': '', // Inisialisasi komentar dengan key 0
    };

    _recipeRef.push().set({
      'judul': _titleController.text,
      'deskripsi': _descriptionController.text,
      'nama': _namaMakananController.text,
      'negara': dropdownNegaraValue,
      'biaya': cost,
      'bahan': _ingredients,
      'langkah': _steps,
      'porsi': porsi,
      'durasi': duration,
      'kalori': kalori,
      'id_creator': widget.user,
      'komentar': komentar,
      'foto': "default.png",
      'tanggal': formattedDate,
      'kategori': dropdownKategoriValue,
    }).then((_) {
      // Berhasil menyimpan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resep berhasil diunggah')),
      );
      // Reset input setelah disimpan
      _titleController.clear();
      _descriptionController.clear();
      _costController.clear();
      _ingredientController.clear();
      _stepController.clear();
      _porsiController.clear();
      _durationController.clear();
      _kaloriController.clear();
      _namaMakananController.clear();

      setState(() {
        _ingredients.clear();
        _steps.clear();
      });
    }).catchError((error) {
      // Gagal menyimpan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunggah resep: $error')),
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
            FilledButton(
              onPressed: _saveRecipe,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Sudut border
                ),
                // primary: Colors.white,
                backgroundColor: Colors.orange,
              ),
              child: Text(
                "Simpan",
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
                                150.0, // Tentukan lebar yang konsisten untuk teks label
                            child: Text(
                              'Nama makanan',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _namaMakananController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Mie goreng',
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
                                150.0, // Tentukan lebar yang konsisten untuk teks label
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
                                150.0, // Tentukan lebar yang konsisten untuk teks label
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
                                150.0, // Tentukan lebar yang konsisten untuk teks label
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
                              150.0, // Tentukan lebar yang konsisten untuk teks label
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
                              150.0, // Tentukan lebar yang konsisten untuk teks label
                          child: Text(
                            'Negara Asal ',
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
                              150.0, // Tentukan lebar yang konsisten untuk teks label
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
                            hintText: 'Garam',
                            hintStyle: TextStyle(
                                fontSize: 16.0, color: Colors.black38),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          decoration: InputDecoration(
                            hintText: '1 sdt',
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black38,
                            ),
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
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Bahan dan takaran tidak boleh kosong')),
                            );
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
                          hintText:
                              'Panaskan minyak, tumis bawang putih, hingga harum',
                          hintStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black38,
                          ),
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if (_stepController.text.isNotEmpty) {
                                setState(() {
                                  _steps.add(_stepController.text);
                                  _stepController.clear();
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Langkah tidak boleh kosong')),
                                );
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
