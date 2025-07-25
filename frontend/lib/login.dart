import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'calendardashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = false;
  bool _invalidUsername = false;
  bool _invalidPassword = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      // Client-side validation for default credentials
      final usernameCorrect = _usernameController.text == 'frontdesk';
      final passwordCorrect = _passwordController.text == 'frontdeskpms';

      // Check all possible cases
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
          Uri.parse('http://localhost:3000/api/v1/login'),
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
          final now = DateTime.now();
          final currentMonth = now.month;
          final currentYear = now.year;
          final daysInMonth = DateUtils.getDaysInMonth(
            currentYear,
            currentMonth,
          );
          final dates = List.generate(daysInMonth, (index) {
            final date = DateTime(currentYear, currentMonth, index + 1);
            return {
              'weekday': DateFormat('E').format(date),
              'date': DateFormat('MMM d').format(date),
            };
          });

          final rooms = {
            'STANDARD SINGLE ROOMS': [
              'Standard Single - Room No. 100',
              'Standard Single - Room No. 101',
              'Standard Single - Room No. 102',
              'Standard Single - Room No. 103',
              'Standard Single - Room No. 104',
            ],
            'SUPERIOR SINGLE ROOMS': [
              'Superior Single - Room No. 105',
              'Superior Single - Room No. 106',
              'Superior Single - Room No. 107',
              'Superior Single - Room No. 108',
              'Superior Single - Room No. 109',
            ],
            'STANDARD DOUBLE ROOMS': [
              'Standard Double - Room No. 200',
              'Standard Double - Room No. 201',
              'Standard Double - Room No. 202',
              'Standard Double - Room No. 203',
              'Standard Double - Room No. 204',
            ],
            'DELUXE ROOMS': [
              'Deluxe - Room No. 205',
              'Deluxe - Room No. 206',
              'Deluxe - Room No. 207',
              'Deluxe - Room No. 208',
              'Deluxe - Room No. 209',
            ],
            'FAMILY ROOMS': [
              'Family - Room No. 300',
              'Family - Room No. 301',
              'Family - Room No. 302',
              'Family - Room No. 303',
            ],
            'EXECUTIVE ROOMS': [
              'Executive - Room No. 304',
              'Executive - Room No. 305',
              'Executive - Room No. 306',
              'Executive - Room No. 307',
            ],
            'SUITE ROOMS': ['Suite - Room No. 308', 'Suite - Room No. 309'],
          };

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CalendarDashboard(
                dates: dates,
                rooms: rooms,
                currentMonth: currentMonth,
                currentYear: currentYear,
                studentName: _nameController.text,
              ),
            ),
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
          // LEFT COL (Image)
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
                      // Background image
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/sign-in-left.jpg',
                          fit: BoxFit.fill,
                        ),
                      ),
                      // Top (CBA logo)
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
                      // Center (PMS white logo)
                      Center(
                        child: Image.asset(
                          'assets/images/PMS-white-logo.png',
                          width: 250,
                        ),
                      ),
                      // Bottom (Tagline)
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

          // RIGHT COL (Sign In Form)
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 90.0,
                    right: 60.0,
                    top: 40.0,
                    bottom: 40.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Image.asset(
                          'assets/images/PMS-logo-2.png',
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(height: 10),
                        // Title
                        const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 12),

                        // Subtitle
                        const Text(
                          'Your training in hotel operations begins here. Simulate real front desk operations and guest experiences.',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 32),

                        // Username Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 500,
                              height: 60,
                              child: TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: TextStyle(
                                    color: _invalidUsername ? Colors.red : null,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: _invalidUsername ? Colors.red : null,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _invalidUsername
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _invalidUsername
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _invalidUsername
                                          ? Colors.red
                                          : Colors.blue,
                                    ),
                                  ),
                                  errorText: null,
                                  errorStyle: TextStyle(color: Colors.red),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter username';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            if (_invalidUsername)
                              Transform.translate(
                                offset: Offset(
                                  0,
                                  -8,
                                ), // Move message 8 pixels up
                                child: Container(
                                  width: 500,
                                  child: Text(
                                    'Invalid username',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),

                        // Password Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 500,
                              height: 60,
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: _invalidPassword ? Colors.red : null,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: _invalidPassword ? Colors.red : null,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _invalidPassword
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _invalidPassword
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _invalidPassword
                                          ? Colors.red
                                          : Colors.blue,
                                    ),
                                  ),
                                  errorText: null,
                                  errorStyle: TextStyle(color: Colors.red),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            if (_invalidPassword)
                              Transform.translate(
                                offset: Offset(
                                  0,
                                  -8,
                                ), // Move message 8 pixels up
                                child: Container(
                                  width: 500,
                                  child: Text(
                                    'Invalid password',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),

                        // Name Field
                        SizedBox(
                          width: 500,
                          height: 60,
                          child: TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Student\'s Name',
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

                        // Sign In Button
                        _isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: 500,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFDD41A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
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
          ),
        ],
      ),
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
