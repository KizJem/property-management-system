import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CalendarDashboard(
        dates: [],
        rooms: {},
        currentMonth: DateTime.now().month,
        currentYear: DateTime.now().year,
      ),
    );
  }
}

class CalendarDashboard extends StatefulWidget {
  final List<Map<String, String>> dates;
  final Map<String, List<String>> rooms;
  final int currentMonth;
  final int currentYear;

  const CalendarDashboard({
    super.key,
    required this.dates,
    required this.rooms,
    required this.currentMonth,
    required this.currentYear,
  });

  @override
  State<CalendarDashboard> createState() => _CalendarDashboardState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      IterableProperty<String>(
        'dates',
        dates.map((e) => e['date'] ?? '').toList(),
      ),
    );
    properties.add(
      DiagnosticsProperty<Map<String, List<String>>>('rooms', rooms),
    );
    properties.add(IntProperty('currentMonth', currentMonth));
    properties.add(IntProperty('currentYear', currentYear));
  }
}

class _CalendarDashboardState extends State<CalendarDashboard> {
  bool _sidebarExpanded = true;
  final double _sidebarWidth = 150;
  final double _sidebarCollapsedWidth = 48;
  final Map<String, String> _roomStatus = {};

  @override
  Widget build(BuildContext context) {
    final effectiveDates = widget.dates.isEmpty
        ? List.generate(31, (index) {
            final date = DateTime(
              widget.currentYear,
              widget.currentMonth,
              index + 1,
            );
            return {
              'weekday': DateFormat('E').format(date),
              'date': DateFormat('MMM d').format(date),
            };
          })
        : widget.dates;

    final effectiveRooms = widget.rooms.isEmpty
        ? {
            'STANDARD SINGLE ROOMS': [
              'Standard Single - Room No. 100',
              'Standard Single - Room No. 101',
              'Standard Single - Room No. 102',
              'Standard Single - Room No. 103',
              'Standard Single - Room No. 104',
              'Standard Single - Room No. 105',
            ],
            'SUPERIOR SINGLE ROOMS': [
              'Superior Single - Room No. 106',
              'Superior Single - Room No. 107',
              'Superior Single - Room No. 108',
            ],
            'STANDARD DOUBLE ROOMS': [
              'Standard Double - Room No. 201',
              'Standard Double - Room No. 202',
              'Standard Double - Room No. 203',
              'Standard Double - Room No. 204',
            ],
          }
        : widget.rooms;

    final mainContent = LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox.expand(
          child: Column(
            children: [
              Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.meeting_room,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Rooms',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: effectiveDates.map((dateMap) {
                            return SizedBox(
                              width: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dateMap['weekday'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    dateMap['date'] ?? '',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildRoomTypeSection(
                        'STANDARD SINGLE ROOMS',
                        effectiveRooms,
                      ),
                      _buildRoomTypeSection(
                        'SUPERIOR SINGLE ROOMS',
                        effectiveRooms,
                      ),
                      _buildRoomTypeSection(
                        'STANDARD DOUBLE ROOMS',
                        effectiveRooms,
                      ),
                    ],
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
        title: const Text('Hotel Management System'),
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
                        isHeader: true,
                        showText: true,
                      ),
                      _buildSidebarItem(
                        Icons.login,
                        'Check-in Logs',
                        showText: true,
                      ),
                      _buildSidebarItem(
                        Icons.list_alt,
                        'Activity Logs',
                        showText: true,
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

  Widget _buildRoomTypeSection(String title, Map<String, List<String>> rooms) {
    final roomList = rooms[title] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ...roomList.map(
          (room) => Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
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
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        widget.dates.isEmpty ? 31 : widget.dates.length,
                        (index) {
                          return Container(
                            width: 80,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: const Text(''),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarItem(
    IconData icon,
    String title, {
    bool isHeader = false,
    bool showText = true,
    bool centerIcon = false,
  }) {
    return Tooltip(
      message: showText ? '' : title,
      child: InkWell(
        onTap: isHeader ? null : () {},
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: centerIcon ? 0 : 12,
            horizontal: showText ? 8 : 0,
          ),
          constraints: const BoxConstraints(minHeight: 48, maxHeight: 60),
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

  Widget _buildStatusDropdown(String roomId) {
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
          {'key': 'blocked', 'color': Colors.black, 'label': 'Blocked'},
          {'key': 'house_use', 'color': Colors.purple, 'label': 'House Use'},
        ],
      },
    ];

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
          border: Border.all(color: Colors.black),
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          );
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
                        border: Border.all(color: Colors.black),
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
    properties.add(
      DiagnosticsProperty<bool>('_sidebarExpanded', _sidebarExpanded),
    );
    properties.add(DoubleProperty('_sidebarWidth', _sidebarWidth));
    properties.add(
      DoubleProperty('_sidebarCollapsedWidth', _sidebarCollapsedWidth),
    );
    properties.add(
      DiagnosticsProperty<Map<String, String>>('_roomStatus', _roomStatus),
    );
  }
}
