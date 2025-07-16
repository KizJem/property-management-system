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
  final String studentName;

  const CalendarDashboard({
    Key? key,
    required this.dates,
    required this.rooms,
    required this.currentMonth,
    required this.currentYear,
    required this.studentName,
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

/// Mode enum to toggle between booking rooms and housekeeping mode
enum Mode { bookRooms, housekeeping }

const Map<String, Map<String, dynamic>> roomStatusMap = {
  // AVAILABLE
  'VC': {'color': Color(0xFF13C06D), 'label': 'Vacant Clean'},
  'VD': {'color': Color(0xFF79511C), 'label': 'Vacant Dirty'},
  'VR': {'color': Color(0xFF29C8E6), 'label': 'Vacant Ready'},
  // OCCUPIED
  'OC': {'color': Color(0xFFC495FF), 'label': 'Occupied Clean'},
  'OD': {'color': Color(0xFF020249), 'label': 'Occupied Dirty'},
  // UNAVAILABLE
  'OOO': {'color': Color(0xFFE0373C), 'label': 'Out of Order'},
  'CO': {'color': Color(0xFF33B678), 'label': 'Check Out'},
  'BLO': {'color': Color(0xFF222222), 'label': 'Blocked'},
  'HU': {'color': Color(0xFFFFD231), 'label': 'House Use'},
};

class _CalendarDashboardState extends State<CalendarDashboard> {
  // Default mode is booking rooms
  Mode _mode = Mode.bookRooms;

  Map<String, List<Map<String, int>>> _housekeepingRanges = {};
  String? _activeHousekeepingRoom;
  int? _housekeepingStart;
  int? _housekeepingEnd;

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

  // Housekeeping status state: Map<room, Map<dateIndex, {status, notes}>>
  Map<String, Map<int, Map<String, String>>> _housekeepingStatus = {};
  // Housekeeping selection state
  Map<String, int?> _hkSelectedStart = {};
  Map<String, int?> _hkSelectedEnd = {};
  String? _activeHKRoom;

  void _onCellTap(String roomType, String room, int dateIndex) {
    if (_mode == Mode.bookRooms) {
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
        int newStart, newEnd;
        if (dateIndex < _selectedStart[room]!) {
          newStart = dateIndex;
          newEnd = _selectedStart[room]!;
        } else {
          newStart = _selectedStart[room]!;
          newEnd = dateIndex;
        }

        // 1. Update the selection state FIRST (triggers highlight)
        setState(() {
          _selectedStart[room] = newStart;
          _selectedEnd[room] = newEnd;
          _activeBookingRoom = null;
        });

        // 2. Show dialog AFTER UI update
        final dates = _generateDatesForMonth(
          _selectedYear,
          _selectedMonth,
          daysToShow: DateTime(_selectedYear, _selectedMonth + 1, 0).day,
        );
        final startDate = dates[newStart]['date'] ?? '';
        final endDate = dates[newEnd]['date'] ?? '';

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
                  onPressed: () {
                    // Optionally reset selection if cancelled
                    setState(() {
                      _selectedStart[room] = null;
                      _selectedEnd[room] = null;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AvailableCellPage(
                          roomType: roomType,
                          roomNumber: room,
                          checkInDate: DateTime(
                            _selectedYear,
                            _selectedMonth,
                            newStart + 1,
                          ),
                          checkOutDate: DateTime(
                            _selectedYear,
                            _selectedMonth,
                            newEnd + 1,
                          ),
                        ),
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
    } else if (_mode == Mode.housekeeping) {
      setState(() {
        if (_activeHKRoom != null &&
            _activeHKRoom != room &&
            _hkSelectedEnd[_activeHKRoom!] == null) {
          // Prevent another selection while previous is not done
          return;
        }
        if (_hkSelectedStart[room] == null ||
            (_hkSelectedStart[room] != null && _hkSelectedEnd[room] != null)) {
          // Start new selection
          _hkSelectedStart[room] = dateIndex;
          _hkSelectedEnd[room] = null;
          _activeHKRoom = room;
        } else if (_hkSelectedStart[room] != null && _hkSelectedEnd[room] == null) {
          // Complete selection
          if (dateIndex < _hkSelectedStart[room]!) {
            _hkSelectedEnd[room] = _hkSelectedStart[room];
            _hkSelectedStart[room] = dateIndex;
          } else {
            _hkSelectedEnd[room] = dateIndex;
          }
          _activeHKRoom = null;
          // Show housekeeping dialog
          final startIdx = _hkSelectedStart[room]!;
          final endIdx = _hkSelectedEnd[room]!;
          final dates = _generateDatesForMonth(
            _selectedYear,
            _selectedMonth,
            daysToShow: DateTime(_selectedYear, _selectedMonth + 1, 0).day,
          );
          final startDate = dates[startIdx]['date'] ?? '';
          final endDate = dates[endIdx]['date'] ?? '';
          final roomNumber = room;
          String? selectedStatus;
          TextEditingController notesController = TextEditingController();
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setStateDialog) {
                  return AlertDialog(
                    title: Row(
                      children: [
                        Icon(Icons.arrow_back),
                        SizedBox(width: 8),
                        Text('Set Housekeeping Status'),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(text: 'Room Number(s): ', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: roomNumber),
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(text: 'Dates: ', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: '$startDate - $endDate'),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text('Select Status', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        DropdownButtonFormField<String>(
  value: selectedStatus,
  items: roomStatusMap.entries.map((entry) {
    final code = entry.key;
    final color = entry.value['color'] as Color;
    final label = entry.value['label'] as String;
    return DropdownMenuItem(
      value: code,
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          SizedBox(width: 8),
          Text('$code – $label'),
        ],
      ),
    );
  }).toList(),
  onChanged: (val) {
    setStateDialog(() {
      selectedStatus = val;
    });
  },
  decoration: InputDecoration(border: OutlineInputBorder()),
),
                        SizedBox(height: 16),
                        Text('Additional Notes (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        TextField(
                          controller: notesController,
                          maxLines: 3,
                          decoration: InputDecoration(border: OutlineInputBorder()),
                        ),
                      ],
                    ),
                    actions: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: selectedStatus == null
                            ? null
                            : () {
                                // Save housekeeping status for all selected dates
                                setState(() {
                                  _housekeepingStatus.putIfAbsent(room, () => {});
                                  for (int i = startIdx; i <= endIdx; i++) {
                                    _housekeepingStatus[room]![i] = {
                                      'status': selectedStatus!,
                                      'notes': notesController.text,
                                    };
                                  }
                                });
                                Navigator.of(context).pop();
                              },
                        child: Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        }
      });
    }
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
                      // --- SYSTEM NAME & MODE TOGGLE HEADER (NEW) ---
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left: System name label
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size: 28,
                                  color: Color(0xFF291F16),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Property Management System                                                                                                                                                               ",

                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF291F16),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            // Right: Toggle/Radio for mode
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Radio<Mode>(
                                  value: Mode.bookRooms,
                                  groupValue: _mode,
                                  onChanged: (Mode? value) {
                                    setState(() {
                                      _mode = value!;
                                    });
                                  },
                                ),
                                const Text(
                                  'Book Rooms (Calendar Page)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 24),
                                Radio<Mode>(
                                  value: Mode.housekeeping,
                                  groupValue: _mode,
                                  onChanged: (Mode? value) {
                                    setState(() {
                                      _mode = value!;
                                    });
                                  },
                                ),
                                const Text(
                                  'Set Housekeeping Status',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
                                      _buildRoomColumn('DELUXE ROOMS'),
                                      _buildRoomColumn('FAMILY ROOMS'),
                                      _buildRoomColumn('EXECUTIVE ROOMS'),
                                      _buildRoomColumn('SUITE ROOMS'),
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
                                    _buildDateRows('DELUXE ROOMS', dates),
                                    _buildDateRows('FAMILY ROOMS', dates),
                                    _buildDateRows('EXECUTIVE ROOMS', dates),
                                    _buildDateRows('SUITE ROOMS', dates),
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
      body: Row(
        children: [
          Container(
            width: _sidebarExpanded ? 180 : 60,
            color: const Color(0xFF291F16),
            child: Column(
              children: [
                // Top: Logo & Toggle
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_sidebarExpanded)
                        Image.asset(
                          'assets/images/PMS-logo-2.png',
                          width: 30,
                          height: 30,
                        ),
                      IconButton(
                        icon: Icon(
                          _sidebarExpanded
                              ? Icons.chevron_left
                              : Icons.chevron_right,
                          size: 20,
                          color: Color(0xFF897249),
                        ),
                        onPressed: () => setState(
                          () => _sidebarExpanded = !_sidebarExpanded,
                        ),
                      ),
                    ],
                  ),
                ),

                // Middle: Menu Items (takes all remaining space)
                Expanded(
                  child: Column(
                    children: [
                      _buildSidebarItem(Icons.calendar_today, 'Calendar'),
                      _buildSidebarItem(
                        Icons.bed,
                        'Guest Records',
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/guestrecords',
                            arguments: {'studentName': widget.studentName},
                          );
                        },
                      ),
                      _buildSidebarItem(
                        Icons.access_time,
                        'Activity Logs',
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/activitylogs',
                            arguments: {'studentName': widget.studentName},
                          );
                        },
                      ),
                      
                      _buildSidebarItem(
                        Icons.check_box,
                        'Available Cell',
                        onTap: () {},
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

                // Bottom: User Info
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: _sidebarExpanded
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.account_circle,
                        color: Color(0xFFFFFBF2),
                        size: 20,
                      ),
                      if (_sidebarExpanded) ...[
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.studentName, // ✅ DYNAMIC
                            style: const TextStyle(
                              color: Color(0xFFFFFBF2),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.logout,
                            size: 18,
                            color: Color(0xFF897249),
                          ),
                          tooltip: 'Logout',
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(child: mainContent),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF897249), // <- Correct icon color
            ),
            if (_sidebarExpanded) ...[
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFFFFBF2), // <- Correct text color
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
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
  const Radius cornerRadius = Radius.circular(8);
  final roomList = widget.rooms[title] ?? [];

  return Column(
    children: [
      // Header row (date titles)
      Row(
        children: List.generate(
          dates.length,
          (_) => Container(
            width: 80,
            height: 50,
            color: Colors.grey.shade300,
          ),
        ),
      ),
      ...roomList.asMap().entries.map((entry) {
        final isLastRoom = entry.key == roomList.length - 1;
        final room = entry.value;

        final bookingStart = _selectedStart[room];
        final bookingEnd = _selectedEnd[room] ?? bookingStart;

        return Row(
          children: dates.asMap().entries.map((dateEntry) {
            final i = dateEntry.key;

            final hk = _housekeepingStatus[room]?[i];
            final statusCode = hk?['status'];
            final statusInfo = statusCode != null ? roomStatusMap[statusCode] : null;
            final hkColor = statusInfo != null ? statusInfo['color'] as Color : null;

            // Booking range highlight
            final isBookingSelected = _mode == Mode.bookRooms &&
                bookingStart != null &&
                bookingEnd != null &&
                i >= bookingStart &&
                i <= bookingEnd;

            // Housekeeping preview range
            final selStart = _hkSelectedStart[room];
            final selEnd = _hkSelectedEnd[room];
            bool isHKPreview = false;
            int? hkPreviewStart;
            int? hkPreviewEnd;

            if (_mode == Mode.housekeeping) {
              if (selStart != null && selEnd == null && i == selStart) {
                isHKPreview = true;
                hkPreviewStart = selStart;
                hkPreviewEnd = selStart;
              } else if (selStart != null && selEnd != null) {
                if (i >= selStart && i <= selEnd) isHKPreview = true;
                hkPreviewStart = selStart;
                hkPreviewEnd = selEnd;
              }
            }

            int? hkRangeStart;
            int? hkRangeEnd;

            if (statusCode != null) {
              hkRangeStart = i;
              while (hkRangeStart! > 0) {
                final prevStatus = _housekeepingStatus[room]?[hkRangeStart - 1]?['status'];
                if (prevStatus == statusCode) {
                  hkRangeStart = hkRangeStart - 1;
                } else {
                  break;
                }
              }

              hkRangeEnd = i;
              while (hkRangeEnd! < dates.length - 1) {
                final nextStatus = _housekeepingStatus[room]?[hkRangeEnd + 1]?['status'];
                if (nextStatus == statusCode) {
                  hkRangeEnd = hkRangeEnd + 1;
                } else {
                  break;
                }
              }
            }


            bool isInsideMergedHKRange = statusCode != null &&
                hkRangeStart != null &&
                hkRangeEnd != null &&
                i >= hkRangeStart &&
                i <= hkRangeEnd;
            bool isMergedHKRangeStart = isInsideMergedHKRange && i == hkRangeStart;

            // Determine if cell is start of booking merged block
            bool isMergedBookingRangeStart = isBookingSelected && i == bookingStart;

            bool noBorder = isInsideMergedHKRange || isBookingSelected || isHKPreview;

            BorderRadius? bookingCellRadius;
            if (isBookingSelected) {
              if (bookingStart == bookingEnd) {
                bookingCellRadius = BorderRadius.circular(8);
              } else if (bookingStart == i) {
                bookingCellRadius = BorderRadius.only(
                  topLeft: cornerRadius,
                  bottomLeft: cornerRadius,
                );
              } else if (bookingEnd == i) {
                bookingCellRadius = BorderRadius.only(
                  topRight: cornerRadius,
                  bottomRight: cornerRadius,
                );
              } else {
                bookingCellRadius = BorderRadius.zero;
              }
            }

            return MouseRegion(
              cursor: ( (_mode == Mode.bookRooms && statusCode == null) ||
                      _mode == Mode.housekeeping )
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              child: GestureDetector(
                onTap: ( (_mode == Mode.bookRooms && statusCode == null) ||
                        _mode == Mode.housekeeping )
                    ? () => _onCellTap(title, room, i)
                    : null,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Booking range highlight block (only on first cell)
                    if (isMergedBookingRangeStart)
                      Positioned(
                        left: 0,
                        top: 0,
                        height: 50,
                        width: 80.0 * (bookingEnd! - bookingStart! + 1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow[300],
                            borderRadius: BorderRadius.horizontal(
                              left: bookingStart == i ? cornerRadius : Radius.zero,
                              right: bookingEnd == i ? cornerRadius : Radius.zero,
                            ),
                          ),
                        ),
                      ),

                    // Housekeeping preview highlight block (only on first cell of preview)
                    if (isHKPreview && hkPreviewStart != null && hkPreviewEnd != null && i == hkPreviewStart)
                      Positioned(
                        left: 0,
                        top: 0,
                        height: 50,
                        width: 80.0 * (hkPreviewEnd - hkPreviewStart + 1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.horizontal(
                              left: cornerRadius,
                              right: cornerRadius,
                            ),
                          ),
                        ),
                      ),

                    // Housekeeping merged block (only on first cell)
                    if (isMergedHKRangeStart)
                      Positioned(
                        left: 0,
                        top: 0,
                        height: 50,
                        width: 80.0 * (hkRangeEnd! - hkRangeStart! + 1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: hkColor,
                            borderRadius: BorderRadius.horizontal(
                              left: cornerRadius,
                              right: cornerRadius,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            statusCode!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 2,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),

                    // The normal cell container for borders and default background
                    Container(
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        color: (isBookingSelected && !isMergedBookingRangeStart)
                            ? Colors.transparent
                            : null,
                        border: noBorder
                            ? null
                            : Border(
                                right: i == dates.length - 1
                                    ? BorderSide.none
                                    : BorderSide(color: Colors.grey.shade300),
                                bottom: isLastRoom
                                    ? BorderSide.none
                                    : BorderSide(color: Colors.grey.shade300),
                              ),
                        borderRadius: bookingCellRadius,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
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
