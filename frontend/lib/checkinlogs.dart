import 'package:flutter/material.dart';

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
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _sidebarExpanded ? _sidebarWidth : _sidebarCollapsedWidth,
            color: Colors.grey[200],
            child: Column(
              children: [
                _buildSidebarItem(
                  icon: Icons.calendar_today,
                  title: 'Calendar',
                  onTap: () => Navigator.pushNamed(context, '/calendar'),
                ),
                _buildSidebarItem(
                  icon: Icons.login,
                  title: 'Check-in Logs',
                  isHeader: true,
                ),
                _buildSidebarItem(
                  icon: Icons.list_alt,
                  title: 'Activity Logs',
                  onTap: () => Navigator.pushNamed(context, '/activitylogs'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  child: const Text(
                    '  Check-In Logs',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color(0xFFF5F0F5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        Row(
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
                        ),
                        const Divider(),
                        Expanded(
                          child: ListView.separated(
                            itemCount: guests.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final guest = guests[index];
                              return Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(guest['guest'] ?? ''),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(guest['bookings'] ?? ''),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(guest['nights'] ?? ''),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(guest['room'] ?? ''),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextButton(
                                      onPressed: () => _showGuestDialog(guest),
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
            ),
          ),
        ],
      ),
    );
  }

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
              if (_sidebarExpanded) const SizedBox(width: 8),
              if (_sidebarExpanded)
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: isHeader
                          ? FontWeight.bold
                          : FontWeight.normal,
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
