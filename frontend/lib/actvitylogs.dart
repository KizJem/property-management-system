import 'package:flutter/material.dart';

class ActivityLogsPage extends StatefulWidget {
  const ActivityLogsPage({super.key});

  @override
  State<ActivityLogsPage> createState() => _ActivityLogsPageState();
}

class _ActivityLogsPageState extends State<ActivityLogsPage> {
  bool _sidebarExpanded = true;
  final double _sidebarWidth = 150;

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
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => setState(() => _sidebarExpanded = !_sidebarExpanded),
          tooltip: _sidebarExpanded ? 'Collapse sidebar' : 'Expand sidebar',
        ),
        title: const Text('System Name'),
      ),
      body: Row(
        children: [
          _sidebarExpanded
              ? Container(
                  width: _sidebarWidth,
                  color: Colors.grey[200],
                  child: Column(
                    children: [
                      _buildSidebarItem(
                        icon: Icons.calendar_today,
                        title: 'Calendar',
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          '/calendar',
                        ),
                      ),
                      _buildSidebarItem(
                        icon: Icons.login,
                        title: 'Guest Records',
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          '/guestrecords',
                        ),
                      ),
                      _buildSidebarItem(
                        icon: Icons.list_alt,
                        title: 'Activity Logs',
                        isHeader: true,
                      ),
                      _buildSidebarItem(
                        icon: Icons.check_box,
                        title: 'Available Cell',
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          '/availablecell',
                        ),
                      ),
                      _buildSidebarItem(
                        icon: Icons.table_rows,
                        title: 'Reserve Cell',
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          '/reservecell',
                        ),
                      ),
                      _buildSidebarItem(
                        icon: Icons.bed,
                        title: 'Occupied Cell',
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          '/occupiedcell',
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '  Activity Logs',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
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

  /// Sidebar item builder with icons (same style as Calendar page)
  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool isHeader = false,
  }) {
    return Material(
      color: isHeader ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: isHeader ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          constraints: const BoxConstraints(minHeight: 48),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: isHeader ? Colors.black : null),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                    fontSize: isHeader ? 16 : 14,
                    color: isHeader ? Colors.black : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows pop-up with detailed log
  void _showLogDetails(Map<String, String> log) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 400,
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
              const SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  text: 'Action Type: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  children: [TextSpan(text: log['action'])],
                ),
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: 'Staff Name: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  children: [TextSpan(text: log['staff'])],
                ),
              ),
              Text.rich(
                TextSpan(
                  text: 'Room Number: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  children: [TextSpan(text: log['room'])],
                ),
              ),
              const SizedBox(height: 10),
              const Text.rich(
                TextSpan(
                  text: 'No. of Guests: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  children: [TextSpan(text: '1')],
                ),
              ),
              const Text.rich(
                TextSpan(
                  text: 'Stay Duration: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  children: [TextSpan(text: 'JUN 5, 2025 - JUN 9, 2025')],
                ),
              ),
              const SizedBox(height: 10),
              const Text.rich(
                TextSpan(
                  text: 'Guest Name: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  children: [TextSpan(text: 'Juan Dela Cruz')],
                ),
              ),
              const Text.rich(
                TextSpan(
                  text: 'Phone Number: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  children: [TextSpan(text: '09774567453')],
                ),
              ),
              const Text.rich(
                TextSpan(
                  text: 'Email: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  children: [TextSpan(text: 'None')],
                ),
              ),
              const Text.rich(
                TextSpan(
                  text: 'Special Requests: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  children: [TextSpan(text: 'None')],
                ),
              ),
              const SizedBox(height: 20),
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
