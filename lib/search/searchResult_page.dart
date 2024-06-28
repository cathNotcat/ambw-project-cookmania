import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cookmania/recipe_page_fix.dart';

class SearchResultPage extends StatefulWidget {
  final String nama;

  const SearchResultPage({Key? key, required this.nama}) : super(key: key);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final DatabaseReference _resepRef =
      FirebaseDatabase.instance.ref().child('resep');
  final DatabaseReference _profileRef = FirebaseDatabase.instance
      .ref()
      .child('profile'); // Reference to profile node
  List<Map<dynamic, dynamic>> _searchResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSearchResults();
  }

  void _loadSearchResults() {
    _resepRef.orderByChild('nama').equalTo(widget.nama).onValue.listen((event) {
      List<Map<dynamic, dynamic>> searchResults = [];
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? values =
            event.snapshot.value as Map<dynamic, dynamic>?;
        if (values != null) {
          values.forEach((key, value) {
            if (value is Map<dynamic, dynamic>) {
              value['id'] = key; // Add the key as an ID
              searchResults.add(value);
            }
          });
        }
      }
      setState(() {
        _searchResults = searchResults;
        _isLoading = false;
      });
    }, onError: (Object error, StackTrace stackTrace) {
      print('Firebase Database Error: $error');
    });
  }

  // Method to fetch creator's name based on id_creator matching with username
  Future<String> _getCreatorName(String idCreator) async {
    // Fetch all profiles
    DataSnapshot snapshot = await _profileRef.get();
    if (snapshot.value != null) {
      Map<dynamic, dynamic>? profiles =
          snapshot.value as Map<dynamic, dynamic>?;
      if (profiles != null) {
        for (var profile in profiles.entries) {
          if (profile.value is Map<dynamic, dynamic> &&
              profile.value['username'] == idCreator) {
            return profile.value['nama'] ??
                ''; // Adjust 'name' based on your database structure
          }
        }
      }
    }
    return ''; // Return empty string if no match found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for ${widget.nama}'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _searchResults.isNotEmpty
              ? ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final resep = _searchResults[index];
                    return FutureBuilder(
                      future: _getCreatorName(
                          resep['id_creator'] ?? ''), // Pass id_creator here
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          String creatorName =
                              snapshot.data ?? ''; // Retrieved creator's name
                          return _buildRecipeCard(resep, creatorName);
                        }
                      },
                    );
                  },
                )
              : Center(
                  child: Text(
                    'No results found for ${widget.nama}',
                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                ),
    );
  }

  Widget _buildRecipeCard(Map<dynamic, dynamic> resep, String creatorName) {
    String imageName =
        resep['foto'] ?? ''; // Replace with actual field name in Firebase
    String deskripsi = resep['deskripsi'] ?? '';
    String idResep = resep['id'] ?? ''; // Recipe ID

    // Constructing image path relative to pubspec.yaml
    String imageUrl =
        'lib/images/$imageName'; // Adjust path as per your folder structure

    return GestureDetector(
      onTap: () {
        _navigateToRecipePage(idResep); // Navigate to RecipePage on tap
      },
      child: Card(
        margin: EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side: Image
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage(
                            imageUrl), // Use AssetImage for local assets
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  // Right side: Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          capitalizeEachWord(resep['judul'] ?? ''),
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          deskripsi,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(Icons.person, size: 20.0),
                            SizedBox(width: 8.0),
                            Text(creatorName, style: TextStyle(fontSize: 14.0)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Icon(Icons.bookmark_border, size: 35.0),
            ),
          ],
        ),
      ),
    );
  }

  String capitalizeEachWord(String input) {
    if (input.isEmpty) return input;
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  void _navigateToRecipePage(String resepKey) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipePage(user: "user1", recipeKey: resepKey),
      ),
    );
  }
}
