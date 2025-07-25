import 'package:flutter/material.dart';

class GuestRecordsPage extends StatefulWidget {
  final String studentName;
  const GuestRecordsPage({super.key, required this.studentName});

  @override
  State<GuestRecordsPage> createState() => _GuestRecordsPageState();
}

class _GuestRecordsPageState extends State<GuestRecordsPage> {
  bool _sidebarExpanded = false;

  final List<Map<String, String>> guests = [
    {'guest': 'Juan Dela Cruz', 'bookings': '4', 'nights': '5', 'room': '101'},
    {'guest': 'Alexis Santos', 'bookings': '2', 'nights': '3', 'room': '101'},
    {'guest': 'Desiree Boo', 'bookings': '1', 'nights': '4', 'room': '106'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: _sidebarExpanded ? 180 : 60,
            color: const Color(0xFF291F16),
            child: Column(
              children: [
                _buildSidebarHeader(),
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
                      _buildSidebarItem(
                        Icons.bed,
                        'Guest Records',
                        null,
                        isActive: true,
                      ),
                      _buildSidebarItem(Icons.access_time, 'Activity Logs', () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/activitylogs',
                          arguments: {'studentName': widget.studentName},
                        );
                      }),
                    ],
                  ),
                ),
                _buildSidebarFooter(),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                _buildHeader('Guest Records'),
                Expanded(
                  child: Container(
                    color: const Color(0xFFFFFBF2), //GR body bg
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        _buildTableHeaders(),
                        const Divider(
                          color: Color(0xFF291F16),
                          thickness: 0.8,
                          height: 20,
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: guests.length,
                            separatorBuilder: (_, __) => const Divider(
                              color: Color(0xFF291F16),
                              thickness: 0.8,
                              height: 20,
                            ),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_sidebarExpanded)
            Image.asset('assets/images/PMS-logo-2.png', width: 30, height: 30),
          IconButton(
            icon: Icon(
              _sidebarExpanded ? Icons.chevron_left : Icons.chevron_right,
              size: 20,
              color: const Color(0xFF897249),
            ),
            onPressed: () =>
                setState(() => _sidebarExpanded = !_sidebarExpanded),
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

  Widget _buildSidebarFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: _sidebarExpanded
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_circle, color: Color(0xFFFFFBF2), size: 20),
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
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      height: 70,
      padding: const EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      color: const Color(0xFFFFFBF2), //GR bg
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF291F16),
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildTableHeaders() {
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
            child: const Text('View'),
          ),
        ),
      ],
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
