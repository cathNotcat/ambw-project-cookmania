import 'package:cookmania/archive_page.dart';
import 'package:cookmania/edit_resep.dart';
import 'package:cookmania/home_page.dart';
import 'package:cookmania/profilepage/login_page.dart';
import 'package:cookmania/profilepage/profile_page.dart';
import 'package:cookmania/profilepage/register_page.dart';
import 'package:cookmania/recipe_page_fix.dart';
import 'package:cookmania/upload_recipe_fix.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      // home: ProfilePage(),
      // home: LoginPage(),
      // home: ArchivePage(),
      // home: UploadRecipe(),
      // home: RecipePage(user:"user1",recipeKey: '1'),
      // home: EditRecipe(recipeKey: '17'),
    );
  }
}
