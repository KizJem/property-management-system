import 'package:flutter/material.dart';
import 'userlogin.dart';
import 'adminlogin.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Outer background
      body: Padding(
        padding: const EdgeInsets.all(32.0), // Outer white margin
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/landing-page-bg.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              // Red overlay with 80% opacity
              Positioned.fill(
                child: Container(
                  color: const Color(0xCC9B111E), // 80% opacity red
                ),
              ),

              // Foreground content
              Row(
                children: [
                  // LEFT PANEL
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(120, 60, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/cba-header.png',
                            width: 400,
                          ),
                          const SizedBox(height: 30),
                          Image.asset(
                            'assets/images/pms-header.png',
                            width: 450,
                          ),
                          const SizedBox(height: 32),
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
                                      builder: (context) =>
                                          const AdminLoginPage(),
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
                                          onPressed: () =>
                                              Navigator.pop(context),
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

                  // RIGHT PANEL
                  // RIGHT PANEL
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double imageWidth =
                            constraints.maxWidth * 0.85; // use 85% of space
                        imageWidth = imageWidth > 480
                            ? 480
                            : imageWidth; // cap at 480px

                        return Container(
                          padding: const EdgeInsets.only(
                            top: 0,
                            right: 20,
                          ), // reduced
                          alignment: Alignment.topRight,
                          child: Image.asset(
                            'assets/images/frontdesk.png',
                            width: imageWidth,
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required String label, required VoidCallback onTap}) {
    return SizedBox(
      width: 150,
      height: 45,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
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
          backgroundColor: const Color(0xFFFFD700),
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
        child: const Icon(Icons.info_outline, size: 30, color: Colors.white),
      ),
    );
  }
}
