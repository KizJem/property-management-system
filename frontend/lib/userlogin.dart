import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'calendardashboard.dart';
import 'landingpage.dart';

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
  bool _obscurePassword = true; // 👁️ Password visibility toggle

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final usernameCorrect = _usernameController.text == 'frontdesk';
      final passwordCorrect = _passwordController.text == 'frontdeskpms';

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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isError = false,
    required String errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity, // changed from 500 to full width
          height: 60,
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? _obscurePassword : false,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.black),
              prefixIcon: Icon(icon, color: Colors.black),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
          ),
        ),
        if (isError)
          Transform.translate(
            offset: const Offset(0, -8),
            child: Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                errorText,
                style: const TextStyle(color: Colors.red, fontSize: 12),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        const SizedBox(height: 8),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // LEFT PANEL
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/login-bg.png',
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.centerLeft,
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        color: const Color(0xCCFFBD00), // 80% opacity yellow
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Welcome,\nStudent!',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 56,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // RIGHT PANEL
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Login Form
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/pms-logo-yellow.png',
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFFBD00),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Simulate real front desk operations and guest experiences.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // USERNAME FIELD
                            _buildTextField(
                              controller: _usernameController,
                              label: 'Username',
                              icon: Icons.person,
                              isError: _invalidUsername,
                              errorText: 'Invalid username',
                            ),

                            // PASSWORD FIELD
                            _buildTextField(
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock,
                              isPassword: true,
                              isError: _invalidPassword,
                              errorText: 'Invalid password',
                            ),

                            // FRONTDESK FULL NAME FIELD
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: "Full Name",
                                  labelStyle: TextStyle(color: Colors.black),
                                  prefixIcon: Icon(
                                    Icons.badge,
                                    color: Colors.black,
                                  ),
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 15),

                            // SIGN IN BUTTON
                            _isLoading
                                ? const CircularProgressIndicator()
                                : SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: _login,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFFFBD00,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),

                            // Rounded Yellow Bottom
                            Transform.translate(
                              offset: const Offset(0, 25),
                              child: Container(
                                width: double.infinity,
                                height: 100,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFA80504),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(200),
                                    topRight: Radius.circular(200),
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

                // TOP RIGHT BACK BUTTON & YELLOW PANEL
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LandingPage()),
                      );
                    },
                    child: Container(
                      width: 450,
                      height: 200,
                      decoration: const BoxDecoration(
                        color: Color(0xFFA80504),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(80),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 50.0,
                            right: 100.0,
                          ),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFFBD00),
                            ),
                            child: const Icon(
                              Icons.chevron_left,
                              size: 35,
                              color: Color(0xFFA80504),
                            ),
                          ),
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
}
