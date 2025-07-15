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
      home: const LoginPage(),

      // Static named routes
      routes: {'/login': (context) => const LoginPage()},

      // Custom routing to support passing arguments like studentName
      onGenerateRoute: (settings) {
        if (settings.name == '/calendar') {
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

          final args = settings.arguments as Map<String, dynamic>? ?? {};
          final studentName = args['studentName'] ?? 'Guest';

          return MaterialPageRoute(
            builder: (_) => CalendarDashboard(
              dates: dates,
              rooms: {
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
              },
              currentMonth: currentMonth,
              currentYear: currentYear,
              studentName: studentName,
            ),
          );
        } else if (settings.name == '/guestrecords') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          return MaterialPageRoute(
            builder: (_) =>
                GuestRecordsPage(studentName: args['studentName'] ?? 'Guest'),
          );
        } else if (settings.name == '/activitylogs') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          return MaterialPageRoute(
            builder: (_) =>
                ActivityLogsPage(studentName: args['studentName'] ?? 'Guest'),
          );
        }

        return null; // fallback
      },
    );
  }
}
