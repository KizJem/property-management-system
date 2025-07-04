import 'package:flutter/material.dart';
import 'calendardashboard.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/calendar': (context) => CalendarDashboard(
          dates: List.generate(9, (index) => 'DATE'),
          rooms: {
            'STANDARD SINGLE ROOMS': [
              'Standard Single - Room No. 100',
              'Standard Single - Room No. 101',
              'Standard Single - Room No. 102',
              'Standard Single - Room No. 103',
              'Standard Single - Room No. 104',
              'Standard Single - Room No. 105',
            ],
            'SUPERIOR SINGLE ROOMS': [
              'Superior Single - Room No. 106',
              'Superior Single - Room No. 107',
              'Superior Single - Room No. 108',
              'Superior Single - Room No. 109',
              'Superior Single - Room No. 200',
            ],
            'STANDARD DOUBLE ROOMS': [
              'Standard Double - Room No. 201',
              'Standard Double - Room No. 202',
              'Standard Double - Room No. 203',
              'Standard Double - Room No. 204',
            ],
          },
        ),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Welcome! Login Successful')),
    );
  }
}
