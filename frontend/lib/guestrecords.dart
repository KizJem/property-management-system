import 'package:flutter/material.dart';

class GuestRecordsPage extends StatefulWidget {
  const GuestRecordsPage({super.key});

  @override
  State<GuestRecordsPage> createState() => _CheckInLogsPageState();
}

class _CheckInLogsPageState extends State<GuestRecordsPage> {
  bool _sidebarExpanded = true;
  final double _sidebarWidth = 150;

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
                        isHeader: true,
                      ),
                      _buildSidebarItem(
                        icon: Icons.list_alt,
                        title: 'Activity Logs',
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          '/activitylogs',
                        ),
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
                    '  Guest Records',
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

  /// Sidebar item builder with icon (matches CalendarDashboard)
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

  void _showGuestDialog(Map<String, String> guest) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Booking History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text("Booking 1: 101 (Jul 15–18)"),
              SizedBox(height: 8),
              Text("Booking 2: 101 (Jul 1–3)"),
              SizedBox(height: 8),
              Text("Booking 3: 105 (Jun 21–23)"),
              SizedBox(height: 8),
              Text("Booking 4: 101 (May 6–9)"),
            ],
          ),
        ),
      ),
    );
  }
}
