import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'actvitylogs.dart';
import 'calendardashboard.dart';
import 'guestrecords.dart';
import 'userlogin.dart';
import 'landingpage.dart';
import 'adminlogin.dart';

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
      home: const LandingPage(),

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
                  '100 Standard Single',
                  '101 Standard Single',
                  '102 Standard Single',
                  '103 Standard Single',
                  '104 Standard Single',
                ],
                'SUPERIOR SINGLE ROOMS': [
                  '105 Superior Single',
                  '106 Superior Single',
                  '107 Superior Single',
                  '108 Superior Single',
                  '109 Superior Single',
                ],
                'STANDARD DOUBLE ROOMS': [
                  '200 Standard Double',
                  '201 Standard Double',
                  '202 Standard Double',
                  '203 Standard Double',
                  '204 Standard Double',
                ],
                'DELUXE ROOMS': [
                  '205 Deluxe',
                  '206 Deluxe',
                  '207 Deluxe',
                  '208 Deluxe',
                  '209 Deluxe',
                ],
                'FAMILY ROOMS': [
                  '300 Family',
                  '301 Family',
                  '302 Family',
                  '303 Family',
                ],
                'EXECUTIVE ROOMS': [
                  '304 Executive',
                  '305 Executive',
                  '306 Executive',
                  '307 Executive',
                ],
                'SUITE ROOMS': ['308 Suite', '309 Suite'],
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
