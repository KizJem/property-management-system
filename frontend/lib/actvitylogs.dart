import 'package:flutter/material.dart';

class ActivityLogsPage extends StatefulWidget {
  const ActivityLogsPage({super.key});

  @override
  State<ActivityLogsPage> createState() => _ActivityLogsPageState();
}

class _ActivityLogsPageState extends State<ActivityLogsPage> {
  bool _sidebarExpanded = true;
  final double _sidebarWidth = 150;
  final double _sidebarCollapsedWidth = 48;

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
    final contentHeader = Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      alignment: Alignment.centerLeft,
      child: const Text(
        '  Activity Logs',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );

    final mainContent = Column(
      children: [
        contentHeader,
        Expanded(
          child: Container(
            color: const Color(0xFFF5F0F5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                          Expanded(flex: 3, child: Text(log['dateTime'] ?? '')),
                          Expanded(flex: 3, child: Text(log['staff'] ?? '')),
                          Expanded(flex: 3, child: Text(log['action'] ?? '')),
                          Expanded(flex: 2, child: Text(log['room'] ?? '')),
                          Expanded(
                            flex: 2,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text('[View]'),
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
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => setState(() => _sidebarExpanded = !_sidebarExpanded),
          tooltip: _sidebarExpanded ? 'Collapse sidebar' : 'Expand sidebar',
        ),
        title: const Text('System Name'),
        backgroundColor: Colors.black87,
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
                        onTap: () => Navigator.pushNamed(context, '/calendar'),
                      ),
                      _buildSidebarItem(
                        Icons.login,
                        'Check-in Logs',
                        onTap: () {
                          // Implement check-in logs navigation
                        },
                      ),
                      _buildSidebarItem(
                        Icons.list_alt,
                        'Activity Logs',
                        onTap: () {
                          // Only navigate if not already on Activity Logs
                          if (ModalRoute.of(context)?.settings.name !=
                              '/activitylogs') {
                            Navigator.pushReplacementNamed(
                              context,
                              '/activitylogs',
                            );
                          }
                        },
                        isHeader:
                            ModalRoute.of(context)?.settings.name ==
                            '/activitylogs',
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
}
