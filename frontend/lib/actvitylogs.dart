import 'package:flutter/material.dart';
import 'availablecell.dart';
import 'occupiedcell.dart';
import 'reservecell.dart';

class ActivityLogsPage extends StatefulWidget {
  final String studentName;
  const ActivityLogsPage({super.key, required this.studentName});

  @override
  State<ActivityLogsPage> createState() => _ActivityLogsPageState();
}

class _ActivityLogsPageState extends State<ActivityLogsPage> {
  bool _sidebarExpanded = true;

  final List<Map<String, String>> logs = [
    {
      'dateTime': 'June 4, 2025\n09:45 AM',
      'staff': 'Lily Cruz',
      'action': 'Transfer',
      'room': '101',
    },
    {
      'dateTime': 'June 4, 2025\n07:26 AM',
      'staff': 'Lily Cruz',
      'action': 'Reservation',
      'room': '101',
    },
    {
      'dateTime': 'June 3, 2025\n03:58 PM',
      'staff': 'Arman Cruz',
      'action': 'Check-Out',
      'room': '106',
    },
    {
      'dateTime': 'May 31, 2025\n03:55 PM',
      'staff': 'Arman Cruz',
      'action': 'Check-In',
      'room': '106',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: _sidebarExpanded ? 180 : 60,
            color: const Color(0xFF291F16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_sidebarExpanded)
                        Image.asset(
                          'assets/images/PMS-logo-2.png',
                          width: 30,
                          height: 30,
                        ),
                      IconButton(
                        icon: Icon(
                          _sidebarExpanded
                              ? Icons.chevron_left
                              : Icons.chevron_right,
                          size: 20,
                          color: const Color(0xFF897249),
                        ),
                        onPressed: () => setState(
                          () => _sidebarExpanded = !_sidebarExpanded,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _buildSidebarItem(Icons.calendar_today, 'Calendar', () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/calendar',
                          arguments: {'studentName': widget.studentName},
                        );
                      }),
                      _buildSidebarItem(Icons.bed, 'Guest Records', () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/guestrecords',
                          arguments: {'studentName': widget.studentName},
                        );
                      }),
                      _buildSidebarItem(
                        Icons.access_time,
                        'Activity Logs',
                        null,
                        isActive: true,
                      ),
                      _buildSidebarItem(Icons.check_box, 'Available Cell', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AvailableCellPage(
                              roomType: 'STANDARD SINGLE ROOMS',
                              roomNumber: 'Standard Single - Room No. 100',
                              checkInDate:
                                  DateTime.now(), // or any default/mock value
                              checkOutDate: DateTime.now().add(
                                const Duration(days: 1),
                              ),
                            ),
                          ),
                        );
                      }),
                      _buildSidebarItem(Icons.book_online, 'Reserve Cell', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReservecellPage(),
                          ),
                        );
                      }),
                      _buildSidebarItem(Icons.hotel, 'Occupied Cell', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OccupiedCellPage(),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: _sidebarExpanded
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.account_circle,
                        color: Color(0xFFFFFBF2),
                        size: 20,
                      ),
                      if (_sidebarExpanded) ...[
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.studentName,
                            style: const TextStyle(
                              color: Color(0xFFFFFBF2),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamedAndRemoveUntil('/login', (route) => false),
                          child: const Icon(
                            Icons.logout,
                            size: 18,
                            color: Color(0xFF897249),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 70,
                  padding: const EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  color: const Color(0xFFFFF1AB),
                  child: const Text(
                    'Activity Logs',
                    style: TextStyle(
                      color: Color(0xFF291F16),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    color: const Color(0xFFFFF1AB),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'DATE & TIME',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'STAFF NAME',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'ACTION TYPE',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'ROOM NO.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'DETAILS',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Expanded(
                          child: ListView.separated(
                            itemCount: logs.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final log = logs[index];
                              return Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(log['dateTime'] ?? ''),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(log['staff'] ?? ''),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(log['action'] ?? ''),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(log['room'] ?? ''),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextButton(
                                      onPressed: () => _showLogDetails(log),
                                      child: const Text('View'),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
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

  Widget _buildSidebarItem(
    IconData icon,
    String title,
    VoidCallback? onTap, {
    bool isActive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF3B2F25) : Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: _sidebarExpanded
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: const Color(0xFF897249)),
              if (_sidebarExpanded) ...[
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFFFFBF2),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showLogDetails(Map<String, String> log) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(40),
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Action Details',
                    style: TextStyle(
                      fontSize: 20, // Match your design
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Log Timestamp:\nMMM DD, YYYY - 00:00 AM',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),

              const SizedBox(height: 30),
              // Action Type
              _buildDetailRow('Action Type', log['action']),
              const SizedBox(height: 14),

              // Staff Name & Room Number
              _buildDetailRow('Staff Name', log['staff']),
              _buildDetailRow('Room Number', log['room']),
              _buildDetailRow('No. of Guests', '1'),
              _buildDetailRow('Stay Duration', 'June 5, 2025 - June 9, 2025'),
              const SizedBox(height: 14),

              // Guest info (replace with real values as needed)
              _buildDetailRow('Guest Name', 'Juan Dela Cruz'),
              _buildDetailRow('Phone Number', '09774567453'),
              _buildDetailRow('Email', 'None'),
              _buildDetailRow('Special Requests', 'None'),
              const SizedBox(height: 18),

              // Lock note
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.lock, size: 15, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    'Logs are read-only and cannot be edited or deleted.',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
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

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130, // <-- adjust to your label length for neatness
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          const SizedBox(
            width: 12,
            child: Text(
              ':',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
