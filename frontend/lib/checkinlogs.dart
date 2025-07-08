import 'package:flutter/material.dart';
import 'calendar_dashboard.dart'; // Make sure this import is correct
import 'activity_logs_page.dart'; // Replace with your actual Activity Logs file

class CheckInLogsPage extends StatefulWidget {
  const CheckInLogsPage({super.key});

  @override
  State<CheckInLogsPage> createState() => _CheckInLogsPageState();
}

class _CheckInLogsPageState extends State<CheckInLogsPage> {
  bool _sidebarExpanded = true;
  final double _sidebarWidth = 150;
  final double _sidebarCollapsedWidth = 48;

  final List<Map<String, String>> guests = [
    {'guest': 'Juan Dela Cruz', 'bookings': '4', 'nights': '5', 'room': '101'},
    {'guest': 'Alexis Santos', 'bookings': '2', 'nights': '3', 'room': '101'},
    {'guest': 'Desiree Boo', 'bookings': '1', 'nights': '4', 'room': '106'},
  ];

  @override
  Widget build(BuildContext context) {
    final mainContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: const Text(
            'Check-In Logs',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: const Color(0xFFF5F0F5),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildTableHeader(),
                const Divider(thickness: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: guests.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final guest = guests[index];
                      return _buildGuestRow(guest);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => setState(() => _sidebarExpanded = !_sidebarExpanded),
          tooltip: _sidebarExpanded ? 'Collapse sidebar' : 'Expand sidebar',
        ),
        title: const Text('System Name'),
      ),
      body: _sidebarExpanded
          ? Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _sidebarWidth,
                  color: Colors.grey[200],
                  child: Column(
                    children: [
                      _buildSidebarItem(
                        Icons.calendar_today,
                        'Calendar',
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const CalendarDashboard(
                                    dates: [],
                                    rooms: {},
                                    currentMonth: 1,
                                    currentYear: 2025,
                                  ),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                      ),
                      _buildSidebarItem(
                        Icons.login,
                        'Check-in Logs',
                        isHeader: true,
                      ),
                      _buildSidebarItem(
                        Icons.list_alt,
                        'Activity Logs',
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const ActivityLogsPage(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(child: mainContent),
              ],
            )
          : mainContent,
    );
  }

  Widget _buildSidebarItem(
    IconData icon,
    String title, {
    bool isHeader = false,
    VoidCallback? onTap,
  }) {
    return Tooltip(
      message: _sidebarExpanded ? '' : title,
      child: InkWell(
        onTap: isHeader ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          constraints: const BoxConstraints(minHeight: 48, maxHeight: 60),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
            color: isHeader ? Colors.grey[300] : null,
          ),
          child: _sidebarExpanded
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Icon(icon, size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: isHeader
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: isHeader ? 16 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(child: Icon(icon, size: 24)),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Row(
      children: const [
        Expanded(
          flex: 4,
          child: Text(
            'GUEST NAME',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'TOTAL BOOKINGS',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'TOTAL NIGHTS',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'MOST USED ROOM',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'BOOKING HISTORY',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestRow(Map<String, String> guest) {
    return Row(
      children: [
        Expanded(flex: 4, child: Text(guest['guest'] ?? '')),
        Expanded(flex: 2, child: Text(guest['bookings'] ?? '')),
        Expanded(flex: 2, child: Text(guest['nights'] ?? '')),
        Expanded(flex: 2, child: Text(guest['room'] ?? '')),
        Expanded(
          flex: 2,
          child: TextButton(
            onPressed: () => _showGuestDialog(guest),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              minimumSize: const Size(40, 20),
            ),
            child: const Text('[View]'),
          ),
        ),
      ],
    );
  }

  void _showGuestDialog(Map<String, String> guest) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Booking History - ${guest['guest']}'),
        content: Text(
          'Total Bookings: ${guest['bookings']}\n'
          'Total Nights: ${guest['nights']}\n'
          'Most Used Room: ${guest['room']}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
