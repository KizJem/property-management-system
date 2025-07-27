import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'landingpage.dart'; // ✅ Import this

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = false;
  bool _invalidUsername = false;
  bool _invalidPassword = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final usernameCorrect = _usernameController.text == 'admin';
      final passwordCorrect = _passwordController.text == 'adminpms';

      if (!usernameCorrect && !passwordCorrect) {
        setState(() {
          _invalidUsername = true;
          _invalidPassword = true;
        });
        return;
      } else if (!usernameCorrect) {
        setState(() {
          _invalidUsername = true;
          _invalidPassword = false;
        });
        return;
      } else if (!passwordCorrect) {
        setState(() {
          _invalidUsername = false;
          _invalidPassword = true;
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _invalidUsername = false;
        _invalidPassword = false;
      });

      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/api/v1/adminlogin'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': _usernameController.text,
            'password': _passwordController.text,
            'name': _nameController.text,
          }),
        );

        if (!mounted) return;

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome, ${_nameController.text}!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${responseData['message']}')),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // LEFT COLUMN
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 30.0),
              alignment: Alignment.center,
              child: Container(
                width: 650,
                height: 650,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/sign-in-left.jpg',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Image.asset(
                            'assets/images/cba-logo.png',
                            width: 200,
                          ),
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          'assets/images/PMS-white-logo.png',
                          width: 250,
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Image.asset(
                            'assets/images/tagline.png',
                            width: 250,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // RIGHT COLUMN with Back Arrow + Login Form
          Expanded(
            child: Stack(
              children: [
                // Back Arrow
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LandingPage(),
                        ),
                      );
                    },
                  ),
                ),

                // Form Area
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60.0,
                        vertical: 40.0,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/PMS-logo-2.png',
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Admin access to system reports, logs, and controls.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 32),

                            _buildInputField(
                              controller: _usernameController,
                              label: 'Username',
                              icon: Icons.person,
                              invalid: _invalidUsername,
                              errorMessage: 'Invalid username',
                            ),
                            const SizedBox(height: 2),

                            _buildInputField(
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock,
                              obscureText: true,
                              invalid: _invalidPassword,
                              errorMessage: 'Invalid password',
                            ),
                            const SizedBox(height: 2),

                            // Admin Name
                            SizedBox(
                              width: 500,
                              height: 60,
                              child: TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Admin\'s Name',
                                  prefixIcon: Icon(Icons.badge),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 15),

                            _isLoading
                                ? const CircularProgressIndicator()
                                : SizedBox(
                                    width: 500,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: _login,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFFDD41A,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color: Color(0xFF171300),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    bool invalid = false,
    required String errorMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 500,
          height: 60,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, color: invalid ? Colors.red : null),
              labelStyle: TextStyle(color: invalid ? Colors.red : null),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: invalid ? Colors.red : Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: invalid ? Colors.red : Colors.blue,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label'.toLowerCase();
              }
              return null;
            },
          ),
        ),
        if (invalid)
          Transform.translate(
            offset: const Offset(0, -8),
            child: Container(
              width: 500,
              child: Text(
                errorMessage,
                textAlign: TextAlign.end,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
