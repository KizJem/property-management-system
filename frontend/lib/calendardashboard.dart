import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'availablecell.dart';
import 'occupiedcell.dart';
import 'reservecell.dart';

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

  bool _sidebarExpanded = false;
  final double _sidebarWidth = 150;
  final double _sidebarCollapsedWidth = 48;
  int _selectedMonth = DateTime.now().month; // 1-based for DateTime
  int _selectedYear = DateTime.now().year;
  void _showMonthYearPicker(BuildContext context) async {
    int tempMonth = _selectedMonth;
    int tempYear = _selectedYear;
    await showDialog(
      context: context,
      builder: (ctx) {
        int tempMonth = _selectedMonth;
        int tempYear = _selectedYear;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Select Month and Year'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<int>(
                    value: tempMonth,
                    items: List.generate(12, (i) {
                      return DropdownMenuItem(
                        value: i + 1,
                        child: Text(_monthAbbr(i + 1)),
                      );
                    }),
                    onChanged: (val) {
                      if (val != null) {
                        setStateDialog(() {
                          tempMonth = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<int>(
                    value: tempYear,
                    items: List.generate(10, (i) {
                      final year = DateTime.now().year - 5 + i;
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }),
                    onChanged: (val) {
                      if (val != null) {
                        setStateDialog(() {
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
      },
    );
  }

  // Add these scroll controllers
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
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

  final int _currentStartDay = 1;
  // Remove days to show limit: show all days in the month

  // Add state for booking selection
  Map<String, int?> _selectedStart = {};
  Map<String, int?> _selectedEnd = {};
  String? _activeBookingRoom;

  void _onCellTap(String room, int dateIndex) {
    setState(() {
      if (_activeBookingRoom != null &&
          _activeBookingRoom != room &&
          _selectedEnd[_activeBookingRoom!] == null) {
        // Prevent booking another room while previous booking is not done
        return;
      }
      if (_selectedStart[room] == null ||
          (_selectedStart[room] != null && _selectedEnd[room] != null)) {
        // Start new selection
        _selectedStart[room] = dateIndex;
        _selectedEnd[room] = null;
        _activeBookingRoom = room;
      } else if (_selectedStart[room] != null && _selectedEnd[room] == null) {
        // Complete selection
        if (dateIndex < _selectedStart[room]!) {
          _selectedEnd[room] = _selectedStart[room];
          _selectedStart[room] = dateIndex;
        } else {
          _selectedEnd[room] = dateIndex;
        }
        _activeBookingRoom = null;
        // Show dialog with date range and continue button
        final startIdx = _selectedStart[room]!;
        final endIdx = _selectedEnd[room]!;
        final dates = _generateDatesForMonth(
          _selectedYear,
          _selectedMonth,
          daysToShow: DateTime(_selectedYear, _selectedMonth + 1, 0).day,
        );
        final startDate = dates[startIdx]['date'] ?? '';
        final endDate = dates[endIdx]['date'] ?? '';
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirm Booking'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Room: $room'),
                  const SizedBox(height: 8),
                  Text('Date Range: $startDate - $endDate'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AvailableCellPage(),
                      ),
                    );
                  },
                  child: const Text('Continue'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
    final dates = _generateDatesForMonth(
      _selectedYear,
      _selectedMonth,
      daysToShow: daysInMonth,
    );

    final mainContent = LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox.expand(
          child: Column(
            children: [
              // Date headers and date cells scroll together horizontally
              Expanded(
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date headers (sticky row)
                      Row(
                        children: [
                          Container(
                            width: 300,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.black26,
                                  width: 2,
                                ),
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
                                "${_monthAbbr(_selectedMonth)} $_selectedYear",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () => _showMonthYearPicker(context),
                            ),
                          ),
                          ...dates.map((dateMap) {
                            return Container(
                              width: 80,
                              height: 56,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
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
                      // Room column and date cells scroll together vertically
                      Expanded(
                        child: Scrollbar(
                          controller: _verticalScrollController,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: _verticalScrollController,
                            scrollDirection: Axis.vertical,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Fixed room column
                                Container(
                                  width: 300,
                                  child: Column(
                                    children: [
                                      _buildRoomColumn('STANDARD SINGLE ROOMS'),
                                      _buildRoomColumn('SUPERIOR SINGLE ROOMS'),
                                      _buildRoomColumn('STANDARD DOUBLE ROOMS'),
                                    ],
                                  ),
                                ),
                                // Date cells columns
                                Column(
                                  children: [
                                    _buildDateRows(
                                      'STANDARD SINGLE ROOMS',
                                      dates,
                                    ),
                                    _buildDateRows(
                                      'SUPERIOR SINGLE ROOMS',
                                      dates,
                                    ),
                                    _buildDateRows(
                                      'STANDARD DOUBLE ROOMS',
                                      dates,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
        title: const Text('System Name'),
        backgroundColor: Colors.black,
      ),

      // inside Scaffold → body: _sidebarExpanded ? Row(children: [...]) : mainContent,
      body: _sidebarExpanded
          ? Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1),
                  width: _sidebarWidth,
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildSidebarItem(
                        Icons.calendar_today,
                        'Calendar',
                        isHeader: true,
                      ),
                      _buildSidebarItem(
                        Icons.login,
                        'Guest Records',
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/guestrecords',
                          );
                        },
                      ),
                      _buildSidebarItem(
                        Icons.list_alt,
                        'Activity Logs',
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/activitylogs',
                          );
                        },
                      ),
                      _buildSidebarItem(
                        Icons.check_box,
                        'Available Cell',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AvailableCellPage(),
                            ),
                          );
                        },
                      ),
                      _buildSidebarItem(
                        Icons.book_online,
                        'Reserve Cell',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReservecellPage(),
                            ),
                          );
                        },
                      ),
                      _buildSidebarItem(
                        Icons.hotel,
                        'Occupied Cell',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OccupiedCellPage(),
                            ),
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

  Widget _buildRoomColumn(String title) {
    final roomList = widget.rooms[title] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Room type title with background color separator
        Container(
          height: 50, // Match room cell height
          width: 300,
          alignment: Alignment.centerLeft,
          color: Colors.grey.shade300, // Background color for separator
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ...roomList.asMap().entries.map((entry) {
          final isLast = entry.key == roomList.length - 1;
          return Container(
            width: 300, // Match the fixed room column width
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                bottom: isLast
                    ? BorderSide.none
                    : BorderSide(color: Colors.grey.shade300),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(entry.value),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDateRows(String title, List<Map<String, String>> dates) {
    final roomList = widget.rooms[title] ?? [];
    return Column(
      children: [
        // Room type title background color separator
        Row(
          children: List.generate(
            dates.length,
            (index) => Container(
              width: 80,
              height: 50,
              color: Colors.grey.shade300, // Background color for separator
            ),
          ),
        ),
        ...roomList.asMap().entries.map((entry) {
          final isLast = entry.key == roomList.length - 1;
          final room = entry.value;
          final start = _selectedStart[room];
          final end = _selectedEnd[room];
          final isBookingActive =
              _activeBookingRoom == null ||
              _activeBookingRoom == room ||
              (_selectedEnd[_activeBookingRoom ?? ''] != null);

          return Row(
            children: dates.asMap().entries.map((dateEntry) {
              final i = dateEntry.key;
              final isLastDate = i == dates.length - 1;
              final isSelected =
                  start != null &&
                  ((end != null && i >= start && i <= end) ||
                      (end == null && i == start));
              final isStart = start != null && i == start;
              final isEnd = end != null && i == end;
              final isMiddle = isSelected && !isStart && !isEnd;

              return MouseRegion(
                cursor: isBookingActive
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic,
                child: GestureDetector(
                  onTap: isBookingActive ? () => _onCellTap(room, i) : null,
                  child: Container(
                    width: 80,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green : null,
                      border: isSelected
                          ? null // Remove borders for selected cells
                          : Border(
                              right: isLastDate
                                  ? BorderSide.none
                                  : BorderSide(color: Colors.grey.shade300),
                              bottom: isLast
                                  ? BorderSide.none
                                  : BorderSide(color: Colors.grey.shade300),
                            ),
                      borderRadius: isSelected
                          ? BorderRadius.horizontal(
                              left: isStart ? Radius.circular(8) : Radius.zero,
                              right: isEnd ? Radius.circular(8) : Radius.zero,
                            )
                          : null,
                    ),
                    child: Stack(
                      children: [
                        // Left border for the first selected cell
                        if (isStart)
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 1,
                              color: Colors.green[700],
                            ),
                          ),
                        // Right border for the last selected cell
                        if (isEnd)
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 1,
                              color: Colors.green[700],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
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
                        // Removed room status dropdown
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
      color: const Color.fromARGB(255, 0, 0, 0),
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
  }
}
