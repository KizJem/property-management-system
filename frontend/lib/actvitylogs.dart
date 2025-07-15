import 'package:flutter/material.dart';
import 'availablecell.dart';
import 'occupiedcell.dart';
import 'reservecell.dart';

class ActivityLogsPage extends StatefulWidget {
  const ActivityLogsPage({super.key});

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
                      _buildSidebarItem(
                        Icons.calendar_today,
                        'Calendar',
                        () => Navigator.pushReplacementNamed(
                          context,
                          '/calendar',
                        ),
                      ),
                      _buildSidebarItem(
                        Icons.bed,
                        'Guest Records',
                        () => Navigator.pushReplacementNamed(
                          context,
                          '/guestrecords',
                        ),
                      ),
                      _buildSidebarItem(
                        Icons.access_time,
                        'Activity Logs',
                        null,
                        isActive: true,
                      ),
                      _buildSidebarItem(
                        Icons.check_box,
                        'Available Cell',
                        () => Navigator.pushReplacementNamed(
                          context,
                          '/availablecell',
                        ),
                      ),
                      _buildSidebarItem(
                        Icons.book_online,
                        'Reserve Cell',
                        () => Navigator.pushReplacementNamed(
                          context,
                          '/reservecell',
                        ),
                      ),
                      _buildSidebarItem(
                        Icons.hotel,
                        'Occupied Cell',
                        () => Navigator.pushReplacementNamed(
                          context,
                          '/occupiedcell',
                        ),
                      ),
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
                        const Expanded(
                          child: Text(
                            'Lilo Cruz',
                            style: TextStyle(
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
                      color: Color(0xFF291F16), //291F16
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
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        alignment: Alignment.centerLeft,
                                        minimumSize: const Size(40, 20),
                                      ),
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

  Widget _buildAlignedRow(String label, String? value, {bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
            child: Text(
              ':',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '',
              style: TextStyle(
                fontSize: 14,
                color: isEmail ? Colors.black : Colors.black,
                decoration: isEmail ? TextDecoration.none : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showLogDetails(Map<String, String> log) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          padding: const EdgeInsets.all(35),
          width: 460,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Action Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Log Timestamp:\nMMM DD, YYYY - 00:00 AM',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildAlignedRow('Action Type', log['action']),
              const SizedBox(height: 24),
              _buildAlignedRow('Staff Name', log['staff']),
              const SizedBox(height: 1),
              _buildAlignedRow('Room Number', log['room']),
              const SizedBox(height: 1),
              _buildAlignedRow('No. of Guests', '1'),
              const SizedBox(height: 1),
              _buildAlignedRow(
                'Stay Duration',
                'June 05, 2025 – June 09, 2025',
              ),
              const SizedBox(height: 24),
              _buildAlignedRow('Guest Name', 'Juan Dela Cruz'),
              const SizedBox(height: 1),
              _buildAlignedRow('Phone No.', '0997 – 456 – 7453'),
              const SizedBox(height: 1),
              _buildAlignedRow('Email', 'jdcruz@gmail.com', isEmail: true),
              const SizedBox(height: 1),
              _buildAlignedRow('Special Requests', 'None'),
              const SizedBox(height: 24),
              const Text(
                '🔒 Logs are read-only and cannot be edited or deleted.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
