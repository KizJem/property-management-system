import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    properties.add(
      IterableProperty<String>(
        'dates',
        dates.map((e) => e['date'] ?? '').toList(),
      ),
    );
    properties.add(
      DiagnosticsProperty<Map<String, List<String>>>('rooms', rooms),
    );
  }
}

class _CalendarDashboardState extends State<CalendarDashboard> {
  // Returns the header date string for the calendar header (e.g., "8 Aug 2021")
  String _getHeaderDateString() {
    final day = _currentStartDay;
    final date = DateTime(_selectedYear, _selectedMonth, day);
    final monthName = _monthAbbr(date.month);
    return "$day $monthName ${date.year}";
  }

  bool _sidebarExpanded = true;
  final double _sidebarWidth = 150;
  final double _sidebarCollapsedWidth = 48;
  final Map<String, String> _roomStatus = {}; // Track room statuses
  int _selectedMonth = DateTime.now().month - 1; // 0-based for dropdown
  int _selectedYear = DateTime.now().year;
  void _showMonthYearPicker(BuildContext context) async {
    int tempMonth = _selectedMonth;
    int tempYear = _selectedYear;
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Select Month and Year'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<int>(
                value: tempMonth,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                items: List.generate(
                  12,
                  (i) => DropdownMenuItem(
                    value: i,
                    child: Text(_monthAbbr(i + 1)),
                  ),
                ),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      tempMonth = val;
                    });
                  }
                },
              ),
              const SizedBox(width: 12),
              DropdownButton<int>(
                value: tempYear,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                items: List.generate(10, (i) {
                  int year = DateTime.now().year - 5 + i;
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year.toString()),
                  );
                }),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      tempYear = val;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedMonth = tempMonth;
                  _selectedYear = tempYear;
                });
                Navigator.of(ctx).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.currentMonth;
    _selectedYear = widget.currentYear;
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _selectedMonth = now.month;
      _selectedYear = now.year;
    });
    // Optionally, update dates here if you want to regenerate the grid
  }

  void _changeMonth(int month) {
    setState(() {
      _selectedMonth = month;
    });
    // Optionally, update dates here if you want to regenerate the grid
  }

  void _changeYear(int delta) {
    setState(() {
      _selectedYear += delta;
    });
    // Optionally, update dates here if you want to regenerate the grid
  }

  List<Map<String, String>> _generateDatesForMonth(
    int year,
    int month, {
    int startDay = 1,
    int daysToShow = 7,
  }) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final endDay = (startDay + daysToShow - 1).clamp(1, daysInMonth);
    return List.generate(endDay - startDay + 1, (i) {
      final date = DateTime(year, month, startDay + i);
      return {
        'weekday': [
          'Sun',
          'Mon',
          'Tue',
          'Wed',
          'Thu',
          'Fri',
          'Sat',
        ][date.weekday % 7],
        'date': "${_monthAbbr(date.month)} ${date.day}",
      };
    });
  }

  String _monthAbbr(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  int _currentStartDay = 1;
  // Remove days to show limit: show all days in the month

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
    final dates = _generateDatesForMonth(
      _selectedYear,
      _selectedMonth,
      startDay: 1,
      daysToShow: daysInMonth,
    );
    final mainContent = LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox.expand(
          child: Column(
            children: [
              // Calendar header with single filter button
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rooms column header (empty, to align with room cells)
                    Container(
                      width: 300,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.black26, width: 2),
                        ),
                      ),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(
                          Icons.filter_list,
                          color: Colors.black54,
                        ),
                        label: Text(
                          "${_monthAbbr(_selectedMonth + 1)} ${_selectedYear}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () => _showMonthYearPicker(context),
                      ),
                    ),
                    // Date headers (aligned with date cells)
                    ...dates.map((dateMap) {
                      return Container(
                        width: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            right: BorderSide(color: Colors.grey.shade300),
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dateMap['weekday'] ?? '',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dateMap['date']?.split(' ').last ?? '',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
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
                      minHeight:
                          constraints.maxHeight -
                          48, // 48 is approx header height
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          _buildRoomTypeSection('STANDARD SINGLE ROOMS', dates),
                          _buildRoomTypeSection('SUPERIOR SINGLE ROOMS', dates),
                          _buildRoomTypeSection('STANDARD DOUBLE ROOMS', dates),
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
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/activitylogs',
                          );
                        },
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
    bool showText = true,
    bool centerIcon = false,
    VoidCallback? onTap,
  }) {
    return Tooltip(
      message: showText ? '' : title,
      child: InkWell(
        onTap: isHeader ? null : onTap,
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

  Widget _buildRoomTypeSection(String title, List<Map<String, String>> dates) {
    final roomList = widget.rooms[title] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                  width: dates.length * 80, // Match header width
                  child: Row(
                    children: List.generate(dates.length, (index) {
                      return Container(
                        width: 80, // Match header width
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: const Text(''),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
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
          {'key': 'blocked', 'color': Colors.black, 'label': 'Blocked'},
          {'key': 'house_use', 'color': Colors.purple, 'label': 'House Use'},
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

  Widget _buildMonthSelector() {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return Container(
      color: const Color(0xFFF3F5F8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Removed previous/next month icons
          ...List.generate(12, (i) {
            final isSelected = (i + 1) == _selectedMonth;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _changeMonth(i + 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 10,
                    ),
                    decoration: isSelected
                        ? BoxDecoration(
                            color: const Color(0xFF5B3DF5),
                            borderRadius: BorderRadius.circular(16),
                          )
                        : null,
                    child: Text(
                      months[i],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 20),
            onPressed: () => _changeYear(-1),
            tooltip: 'Previous Year',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              _selectedYear.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 20),
            onPressed: () => _changeYear(1),
            tooltip: 'Next Year',
          ),
        ],
      ),
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
