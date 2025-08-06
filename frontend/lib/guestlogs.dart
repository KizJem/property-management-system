import 'package:flutter/material.dart';
import 'calendardashboard.dart';
import 'landingpage.dart';

class GuestLogsPage extends StatelessWidget {
  const GuestLogsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🔴 RED HEADER SECTION
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: Color(0xFF9B000A)),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 🔴 Left: Logo and System Text
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/pms-logo-white.png',
                        height: 130,
                        width: 130,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 12),
                      Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'PROPERTY MANAGEMENT SYSTEM',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Hello, Receptionist!',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // 🟡 Right: Tabs and Logout
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Calendar Tab
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      CalendarDashboard(
                                        dates: [], // Use actual dates list
                                        rooms: {}, // Use actual rooms map
                                        currentMonth: DateTime.now().month,
                                        currentYear: DateTime.now().year,
                                        studentName: 'Receptionist',
                                      ),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          child: const Text(
                            'Calendar',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // Guest Logs Tab (Active)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD400),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Guest Logs',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9B000A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 35),

                      // Logout
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                'Confirm Logout',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: const Text(
                                'Are you sure you want to log out?',
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LandingPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 8,
                          ),
                          child: const Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 🔘 Placeholder for Guest Logs Body Content
          Expanded(
            child: Center(
              child: Text(
                'Guest Logs Content Here',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'calendardashboard.dart';
// import 'landingpage.dart';

// class GuestLogsPage extends StatelessWidget {
//   final List<Map<String, String>> dates;
//   final Map<String, List<String>> rooms;
//   final int currentMonth;
//   final int currentYear;
//   final String studentName;

//   const GuestLogsPage({
//     Key? key,
//     required this.dates,
//     required this.rooms,
//     required this.currentMonth,
//     required this.currentYear,
//     required this.studentName,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           // 🔴 HEADER SECTION
//           Container(
//             width: double.infinity,
//             decoration: const BoxDecoration(color: Color(0xFF9B000A)),
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: SizedBox(
//               height: 120,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   // 🔴 Left Section
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Image.asset(
//                         'assets/images/pms-logo-white.png',
//                         height: 130,
//                         width: 130,
//                         fit: BoxFit.contain,
//                       ),
//                       const SizedBox(width: 12),
//                       Container(
//                         margin: const EdgeInsets.only(bottom: 25),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Text(
//                               'PROPERTY MANAGEMENT SYSTEM',
//                               style: TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontSize: 25,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             const SizedBox(height: 2),
//                             Text(
//                               'Hello, $studentName!',
//                               style: const TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),

//                   // 🟡 Right Section
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       // 🔙 Calendar Tab
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushReplacement(
//                             context,
//                             PageRouteBuilder(
//                               pageBuilder:
//                                   (context, animation, secondaryAnimation) =>
//                                       CalendarDashboard(
//                                         dates: dates,
//                                         rooms: rooms,
//                                         currentMonth: currentMonth,
//                                         currentYear: currentYear,
//                                         studentName: studentName,
//                                       ),
//                               transitionDuration: Duration.zero,
//                               reverseTransitionDuration: Duration.zero,
//                             ),
//                           );
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 18,
//                           ),
//                           child: const Text(
//                             'Calendar',
//                             style: TextStyle(
//                               fontFamily: 'Poppins',
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),

//                       // 🟡 Guest Logs Tab (Active)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 18,
//                         ),
//                         decoration: const BoxDecoration(
//                           color: Color(0xFFFFD400),
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10),
//                           ),
//                         ),
//                         child: const Text(
//                           'Guest Logs',
//                           style: TextStyle(
//                             fontFamily: 'Poppins',
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF9B000A),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 35),

//                       // 🚪 Logout
//                       GestureDetector(
//                         onTap: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               title: const Text(
//                                 'Confirm Logout',
//                                 style: TextStyle(
//                                   fontFamily: 'Poppins',
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               content: const Text(
//                                 'Are you sure you want to log out?',
//                                 style: TextStyle(fontFamily: 'Poppins'),
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   child: const Text(
//                                     'Cancel',
//                                     style: TextStyle(
//                                       fontFamily: 'Poppins',
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                     Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             const LandingPage(),
//                                       ),
//                                     );
//                                   },
//                                   child: const Text(
//                                     'Logout',
//                                     style: TextStyle(
//                                       fontFamily: 'Poppins',
//                                       color: Colors.red,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 18,
//                             horizontal: 8,
//                           ),
//                           child: const Icon(
//                             Icons.logout,
//                             color: Colors.white,
//                             size: 30,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // 🧾 Body Placeholder
//           Expanded(
//             child: Center(
//               child: Text(
//                 'Guest Logs Content Here',
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
