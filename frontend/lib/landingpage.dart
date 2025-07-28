import 'package:flutter/material.dart';
import 'userlogin.dart';
import 'adminlogin.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White outer background
      body: Padding(
        padding: const EdgeInsets.all(32.0), // Outer white margin
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF9B111E), // Deep red inner content
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // LEFT PANEL
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(80, 60, 80, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CBA HEADER IMAGE
                      Image.asset('assets/images/cba-header.png', width: 500),
                      const SizedBox(height: 50),

                      // PMS HEADER IMAGE
                      Image.asset('assets/images/pms-header.png', width: 500),
                      const SizedBox(height: 16),

                      // Buttons
                      Row(
                        children: [
                          _buildButton(
                            label: 'Student',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          _buildButton(
                            label: 'Admin',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AdminLoginPage(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          _buildCircleButton(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('About'),
                                  content: const Text(
                                    'This Property Management System is a simulation platform for Hospitality Management students.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // RIGHT PANEL: Front desk illustration
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 60, right: 100),
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    'assets/images/frontdesk.png',
                    width: 420,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required String label, required VoidCallback onTap}) {
    return SizedBox(
      width: 200,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFBD00),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.zero, // Prevent extra padding
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({required VoidCallback onTap}) {
    return SizedBox(
      width: 40,
      height: 40,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFBD00),
          shape: const CircleBorder(), // Circle shape
          padding: EdgeInsets.zero, // Remove extra space
        ),
        child: const Icon(Icons.info_outline, color: Color(0xFFFFFFFF)),
      ),
    );
  }
}
