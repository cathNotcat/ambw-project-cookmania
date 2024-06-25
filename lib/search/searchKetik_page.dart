import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:cookmania/search/searchResult_page.dart';

class SearchKetikPage extends StatefulWidget {
  const SearchKetikPage({Key? key}) : super(key: key);

  @override
  _SearchKetikPageState createState() => _SearchKetikPageState();
}

class _SearchKetikPageState extends State<SearchKetikPage> {
  final DatabaseReference _resepRef = FirebaseDatabase.instance.ref().child('resep');
  List<Map<dynamic, dynamic>> _initialResults = [];
  List<Map<dynamic, dynamic>> _searchResults = [];
  bool _isLoading = true;
  bool _showInitial = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    _resepRef
        .orderByChild('nama')
        .limitToFirst(10)
        .onValue
        .listen((event) {
      List<Map<dynamic, dynamic>> initialResults = [];
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? values = event.snapshot.value as Map<dynamic, dynamic>?;
        if (values != null) {
          Set<String> seenNames = {};
          values.forEach((key, value) {
            if (value is Map<dynamic, dynamic>) {
              if (!seenNames.contains(value['nama'])) {
                seenNames.add(value['nama']);
                initialResults.add(value);
              }
            }
          });
        }
      }
      setState(() {
        _initialResults = initialResults;
        _isLoading = false;
      });
    }, onError: (Object error, StackTrace stackTrace) {
      print('Firebase Database Error: $error');
    });
  }

  void _searchResep(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
        _showInitial = true;
      });
      return;
    }

    String searchTerm = query.toLowerCase();
    List<Map<dynamic, dynamic>> searchResults = [];

    Set<String> seenNames = {};
    _initialResults.forEach((resep) {
      String judul = resep['nama']?.toLowerCase() ?? '';
      if (judul.contains(searchTerm) && !seenNames.contains(resep['nama'])) {
        seenNames.add(resep['nama']);
        searchResults.add(resep);
      }
    });

    setState(() {
      _searchResults = searchResults;
      _showInitial = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: TextField(
                  onChanged: (value) {
                    _searchResep(value);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Ketikkan bahan...',
                    hintStyle: TextStyle(fontSize: 16.0),
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _showInitial
                    ? _buildInitialResults()
                    : _searchResults.isNotEmpty
                        ? _buildSearchResults()
                        : const Center(
                            child: Text(
                              'No results found',
                              style: TextStyle(fontSize: 16.0, color: Colors.grey),
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialResults() {
    return FirebaseAnimatedList(
      query: _resepRef,
      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
        if (index < _initialResults.length) {
          final resep = _initialResults[index];
          return ListTile(
            title: Text(resep['nama'] ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchResultPage(nama: resep['nama']?? '')),
              );
            },
          );
        } else {
          return const SizedBox(); 
        }
      },
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        if (index < _searchResults.length) {
          final resep = _searchResults[index];
          return ListTile(
            title: Text(resep['nama'] ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchResultPage(nama: resep['nama'] ?? '')),
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
