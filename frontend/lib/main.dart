import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'actvitylogs.dart';
import 'calendardashboard.dart';
import 'guestrecords.dart';
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
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(), // App starts at login screen
      routes: {
        '/login': (context) => const LoginPage(), // <-- REGISTERED!
        '/home': (context) => const HomePage(),
        '/guestrecords': (context) => const GuestRecordsPage(),
        '/activitylogs': (context) => const ActivityLogsPage(),
        '/calendar': (context) {
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
          return CalendarDashboard(
            dates: dates,
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
            currentMonth: currentMonth,
            currentYear: currentYear,
          );
        },
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome! Login Successful'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/calendar'),
              child: const Text('Go to Calendar'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/guestrecords'),
              child: const Text('Go to Guest Records'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/activitylogs'),
              child: const Text('Go to Activity Logs'),
            ),
          ],
        ),
      ),
    );
  }
}
