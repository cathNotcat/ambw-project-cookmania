import 'package:cookmania/home_page.dart';
import 'package:cookmania/profilepage/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kotaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseReference _profileRef =
      FirebaseDatabase.instance.ref().child('profile');

  String? _emailError;
  String? _usernameError;

  @override
  void dispose() {
    _namaController.dispose();
    _kotaController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      String nama = _namaController.text.trim();
      String kota = _kotaController.text.trim();
      String email = _emailController.text.trim();
      String username = _usernameController.text.trim();
      String password = _passwordController.text;

      bool userExists = false;

      await _profileRef
          .orderByChild('username')
          .equalTo(username)
          .once()
          .then((DatabaseEvent event) {
        dynamic snapshotValue = event.snapshot.value;
        if (snapshotValue != null && snapshotValue is Map<dynamic, dynamic>) {
          userExists = true;
          setState(() {
            _usernameError = 'Username tidak tersedia';
          });
        }
      });

      if (!userExists) {
        await _profileRef
            .orderByChild('email')
            .equalTo(email)
            .once()
            .then((DatabaseEvent event) {
          dynamic snapshotValue = event.snapshot.value;
          if (snapshotValue != null && snapshotValue is Map<dynamic, dynamic>) {
            userExists = true;
            setState(() {
              _emailError = 'Email tidak tersedia';
            });
          }
        });
      }

      if (!userExists) {
        _profileRef.push().set({
          'nama': nama,
          'kota': kota,
          'email': email,
          'username': username,
          'password': password,
          'foto': 'foto.png',
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Register berhasil.')),
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Register tidak berhasil.')),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Register',
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),
                  // ----------------------------------NAMA----------------------------------
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(249, 168, 37, 1),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silakan isi nama anda';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  // ----------------------------------KOTA----------------------------------
                  TextFormField(
                    controller: _kotaController,
                    decoration: const InputDecoration(
                      labelText: 'Kota Asal',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(249, 168, 37, 1),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silakan isi kota anda';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  // ----------------------------------USERNAME----------------------------------
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(249, 168, 37, 1),
                        ),
                      ),
                      errorText: _usernameError,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silakan isi username anda';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  // ----------------------------------EMAIL----------------------------------
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(249, 168, 37, 1),
                        ),
                      ),
                      errorText: _emailError,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silakan isi email anda';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),

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
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silakan isi password anda';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade800,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _register,
                      child: const Text('Register'),
                    ),
                  ),
                  const SizedBox(height: 10.0),
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
                        onTap: _login,
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
                  const SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => const HomePage()));
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.yellow.shade800,
                        decorationColor: Colors.yellow.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
