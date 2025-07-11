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

  //ALIGNED ROW WIDGET
  /// Helper widget to align label and value in a row
  Widget _buildAlignedRow(String label, String? value, {bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label Column
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
          // Colon Column (fixed width for perfect vertical alignment)
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
          // Value Column
          Expanded(
            child: Text(
              value ?? '',
              style: TextStyle(
                fontSize: 14,
                color: isEmail ? Colors.blue : Colors.black,
                decoration: isEmail
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows pop-up with detailed log
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

              // Block 1: Action Info
              _buildAlignedRow('Action Type', log['action']),
              const SizedBox(height: 24),

              // Block 2: Stay Info
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

              // Block 3: Guest Info
              _buildAlignedRow('Guest Name', 'Juan Dela Cruz'),
              const SizedBox(height: 1),
              _buildAlignedRow('Phone No.', '0997 – 456 – 7453'),
              const SizedBox(height: 1),
              _buildAlignedRow('Email', 'jdcruz@gmail.com'),
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
