import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class CalendarDashboard extends StatefulWidget {
  final List<Map<String, String>> dates;
  final Map<String, List<String>> rooms;
  final int currentMonth;
  final int currentYear;

  const CalendarDashboard({
    Key? key,
    required this.dates,
    required this.rooms,
    required this.currentMonth,
    required this.currentYear,
  }) : super(key: key);

  @override
  State<CalendarDashboard> createState() => _CalendarDashboardState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<String>('dates', dates.map((e) => e['date'] ?? '').toList()));
    properties.add(DiagnosticsProperty<Map<String, List<String>>>('rooms', rooms));
  }
}

class _CalendarDashboardState extends State<CalendarDashboard> {
  bool _sidebarExpanded = true;
  final double _sidebarWidth = 150;
  final double _sidebarCollapsedWidth = 48;
  final Map<String, String> _roomStatus = {}; // Track room statuses

  @override
  Widget build(BuildContext context) {
    final mainContent = LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox.expand(
          child: Column(
            children: [
              // Sticky date header
              Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 200,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.meeting_room, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Rooms',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    // Date headers
                    ...widget.dates.map((dateMap) {
                      return Container(
                        width: 80, // Match the width of the date columns in the rows
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dateMap['weekday'] ?? '',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              dateMap['date'] ?? '',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              // Scrollable room rows
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight - 48, // 48 is approx header height
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          _buildRoomTypeSection('STANDARD SINGLE ROOMS'),
                          _buildRoomTypeSection('SUPERIOR SINGLE ROOMS'),
                          _buildRoomTypeSection('STANDARD DOUBLE ROOMS'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildSidebarItem(Icons.calendar_today, 'Calendar', isHeader: true, showText: true),
                      _buildSidebarItem(Icons.login, 'Check-in Logs', showText: true),
                      _buildSidebarItem(Icons.list_alt, 'Activity Logs', showText: true),
                    ],
                  ),
                ),
                Expanded(child: mainContent),
              ],
            )
          : mainContent,
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, {bool isHeader = false, bool showText = true, bool centerIcon = false}) {
    return Tooltip(
      message: showText ? '' : title,
      child: InkWell(
        onTap: isHeader ? null : () {},
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: centerIcon ? 0 : 12,
            horizontal: showText ? 8 : 0,
          ),
          constraints: const BoxConstraints(
            minHeight: 48,
            maxHeight: 60,
          ),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
          ),
          child: showText
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                            fontSize: isHeader ? 16 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Icon(icon, size: 24),
                ),
        ),
      ),
    );
  }

  Widget _buildRoomTypeSection(String title) {
    final roomList = widget.rooms[title] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...roomList.map((room) => Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 300, 
                child: Padding(
                  padding: const EdgeInsets.only(left: 8), 
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          room,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      _buildStatusDropdown(room),
                    ],
                  ),
                ),
              ),
              // Date cells for this room
              SizedBox(
                width: widget.dates.length * 80, // Match header width
                child: Row(
                  children: List.generate(widget.dates.length, (index) {
                    return Container(
                      width: 80, // Match header width
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey.shade300)),
                      ),
                      child: const Text(''),
                    );
                  }),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildStatusDropdown(String roomId) {
    // Define status options with color, label, and section
    const statusSections = [
      {
        'section': 'AVAILABLE',
        'items': [
          {
            'key': 'vacant_clean_inspected',
            'color': Colors.green,
            'label': 'Vacant, Clean, Inspected',
          },
          {
            'key': 'vacant_dirty',
            'color': Colors.yellow,
            'label': 'Vacant, Dirty',
          },
        ],
      },
      {
        'section': 'OCCUPIED',
        'items': [
          {
            'key': 'occupied_clean',
            'color': Colors.red,
            'label': 'Occupied, Clean',
          },
          {
            'key': 'occupied_dirty',
            'color': Colors.orange,
            'label': 'Occupied, Dirty',
          },
        ],
      },
      {
        'section': 'UNAVAILABLE',
        'items': [
          {
            'key': 'out_of_order',
            'color': Colors.grey,
            'label': 'Out of Order',
          },
          {
            'key': 'blocked',
            'color': Colors.black,
            'label': 'Blocked',
          },
          {
            'key': 'house_use',
            'color': Colors.purple,
            'label': 'House Use',
          },
        ],
      },
    ];

    // Find the current status key
    String currentStatus = _roomStatus[roomId] ?? 'vacant_clean_inspected';
    Color currentColor = Colors.green;
    for (var section in statusSections) {
      for (var item in section['items'] as List) {
        if (item['key'] == currentStatus) {
          currentColor = item['color'] as Color;
        }
      }
    }

    return PopupMenuButton<String>(
      icon: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: currentColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 2),
        ),
      ),
      itemBuilder: (context) {
        List<PopupMenuEntry<String>> entries = [];
        for (var section in statusSections) {
          entries.add(
            PopupMenuItem<String>(
              enabled: false,
              child: Text(
                section['section'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
          ); // <-- moved closing parenthesis here
          for (var item in section['items'] as List) {
            entries.add(
              PopupMenuItem<String>(
                value: item['key'] as String,
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: item['color'] as Color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item['label'] as String,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return entries;
      },
      onSelected: (status) {
        setState(() {
          _roomStatus[roomId] = status;
        });
      },
      tooltip: 'Housekeeping status',
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('_sidebarExpanded', _sidebarExpanded));
    properties.add(DoubleProperty('_sidebarWidth', _sidebarWidth));
    properties.add(DoubleProperty('_sidebarCollapsedWidth', _sidebarCollapsedWidth));
    properties.add(DiagnosticsProperty<Map<String, String>>('_roomStatus', _roomStatus));
  }
}