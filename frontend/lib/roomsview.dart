// roomsview.dart
import 'package:flutter/material.dart';

class RoomsView extends StatelessWidget {
  const RoomsView({super.key});

  final List<Map<String, String>> rooms = const [
    {'number': '100', 'type': 'Standard Single Room'},
    {'number': '101', 'type': 'Standard Single Room'},
    {'number': '102', 'type': 'Standard Single Room'},
    {'number': '103', 'type': 'Standard Single Room'},
    {'number': '104', 'type': 'Standard Single Room'},
    {'number': '105', 'type': 'Superior Single Room'},
    {'number': '106', 'type': 'Superior Single Room'},
    {'number': '107', 'type': 'Superior Single Room'},
    {'number': '108', 'type': 'Superior Single Room'},
    {'number': '109', 'type': 'Superior Single Room'},
    {'number': '200', 'type': 'Standard Double Room'},
    {'number': '201', 'type': 'Standard Double Room'},
    {'number': '202', 'type': 'Standard Double Room'},
    {'number': '203', 'type': 'Standard Double Room'},
    {'number': '204', 'type': 'Standard Double Room'},
    {'number': '205', 'type': 'Deluxe Room'},
    {'number': '206', 'type': 'Deluxe Room'},
    {'number': '207', 'type': 'Deluxe Room'},
    {'number': '208', 'type': 'Deluxe Room'},
    {'number': '209', 'type': 'Deluxe Room'},
    {'number': '300', 'type': 'Family Room'},
    {'number': '301', 'type': 'Family Room'},
    {'number': '302', 'type': 'Family Room'},
    {'number': '303', 'type': 'Family Room'},
    {'number': '304', 'type': 'Executive Room'},
    {'number': '305', 'type': 'Executive Room'},
    {'number': '306', 'type': 'Executive Room'},
    {'number': '307', 'type': 'Executive Room'},
    {'number': '308', 'type': 'Suite Room'},
    {'number': '309', 'type': 'Suite Room'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: GridView.builder(
        itemCount: rooms.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (context, index) {
          final room = rooms[index];
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    room['number']!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    room['type']!,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
