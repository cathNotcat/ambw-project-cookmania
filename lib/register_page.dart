import 'package:cookmania/home_page.dart';
import 'package:cookmania/login_page.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // DatabaseReference _profileRef =
  //     FirebaseDatabase.instance.reference().child('profile');

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    print("to login page");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  // void _register() {
  //   if (_formKey.currentState!.validate()) {
  //     String username = _usernameController.text.trim();
  //     String email = _emailController.text.trim();
  //     String password = _passwordController.text;

  //     // Generate a unique key for the user
  //     String userId = _profileRef.push().key ?? '';

  //     // Save user data to Firebase Realtime Database
  //     _profileRef.child(userId).set({
  //       'username': username,
  //       'email': email,
  //       'password': password,
  //     }).then((value) {
  //       // Navigate to home page or show success message
  //       print('User registered successfully');
  //       // Navigate to another page or show success message
  //       Navigator.of(context).pop(); // Example: Navigate back to login page
  //     }).catchError((error) {
  //       print('Failed to register user: $error');
  //       // Handle error, show error message to user, etc.
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ----------------------------------TITLE----------------------------------
                const Text(
                  'Register',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                // ----------------------------------EMAIL----------------------------------
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(249, 168, 37, 1),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                // ----------------------------------USERNAME----------------------------------
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(249, 168, 37, 1),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                // ----------------------------------PASSWORD----------------------------------
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(249, 168, 37, 1),
                      ),
                    ),
                  ),
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                // ----------------------------------BUTTON----------------------------------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow.shade800,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      textStyle: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Register'),
                  ),
                ),
                const SizedBox(height: 20.0),
                // ----------------------------------REGISTER----------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sudah punya akun? ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _login();
                      },
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          color: Colors.yellow.shade800,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.yellow.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
