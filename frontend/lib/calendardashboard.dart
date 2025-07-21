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
  'VD': {
    'color': Color(0xFF79511C),
    'label': 'Vacant Dirty',
  }, // #79511C (brown)
  'VR': {'color': Color(0xFF307FCF), 'label': 'Vacant Ready'}, // #307FCF (blue)
  // OCCUPIED
  'OC': {
    'color': Color(0xFFCBECE6),
    'label': 'Occupied Clean',
  }, // #CBECE6 (light aqua)
  'OD': {
    'color': Color(0xFF074B0C),
    'label': 'Occupied Dirty',
  }, // #074B0C (dark green)
  // UNAVAILABLE
  'OOO': {
    'color': Color(0xFF171300),
    'label': 'Out of Order',
  }, // #171300 (dark brown)
  'BLO': {
    'color': Color(0xFFFFF1AB),
    'label': 'Blocked',
  }, // #FFF1AB (light yellow)
  'HU': {'color': Color(0xFFFDD41A), 'label': 'House Use'}, // #FDD41A (yellow)
};

class _CalendarDashboardState extends State<CalendarDashboard> {
  // ▶️ Define once at the top:
  static const double cellWidth = 100.0;
  static const double cellHeight = 50.0;
  static const double headerCellHeight = 40.0;

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

  int get _currentStartDay => _currentStartDate.day;
  bool _sidebarExpanded = false;
  final double _sidebarWidth = 150;
  final double _sidebarCollapsedWidth = 48;
  // Track selected start date (for calendar display)
  late DateTime _currentStartDate;

  int _selectedMonth = DateTime.now().month; // 1-based for DateTime
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.currentMonth;
    _selectedYear = widget.currentYear;

    _currentStartDate = DateTime(widget.currentYear, widget.currentMonth, 1);
    _selectedDate = _currentStartDate; // Initialize selectedDate
  }

  DateTime _selectedDate = DateTime.now();

  List<DateTime> _generateDatesFromStartDate(
    DateTime startDate,
    int daysToShow,
  ) {
    return List.generate(daysToShow, (i) => startDate.add(Duration(days: i)));
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

  // Add this constant (or reuse whatever you already have for your room column)
  static const double roomColumnWidth = 300;

  Widget _buildDateHeaders(List<DateTime> dates) {
    // Local weekday lookup
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      color: Colors.grey.shade100,
      child: Row(
        children: [
          // ── ROOM COLUMN SPACE ──
          SizedBox(
            width: roomColumnWidth, // matches your room-column width
            height: cellHeight, // same height as each date header
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ←← block-jump back
                IconButton(
                  icon: const Icon(Icons.keyboard_double_arrow_left),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    setState(() {
                      _currentStartDate = _currentStartDate.subtract(
                        const Duration(days: 1),
                      );
                      if (_selectedDate.isBefore(_currentStartDate)) {
                        _selectedDate = _currentStartDate;
                      }
                    });
                  },
                ),

                // →→ block-jump forward
                IconButton(
                  icon: const Icon(Icons.keyboard_double_arrow_right),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    setState(() {
                      _currentStartDate = _currentStartDate.add(
                        const Duration(days: 1),
                      );
                      _selectedDate = _currentStartDate;
                    });
                  },
                ),
              ],
            ),
          ),

          // ── DATE CELLS ──
          Expanded(
            child: SingleChildScrollView(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: dates.map((date) {
                  final isSel =
                      date.year == _selectedDate.year &&
                      date.month == _selectedDate.month &&
                      date.day == _selectedDate.day;
                  final wd = weekdays[date.weekday - 1];
                  final mo = _monthAbbr(date.month);
                  final d = date.day.toString();

                  return GestureDetector(
                    onTap: () => setState(() => _selectedDate = date),
                    child: Container(
                      width: cellWidth,
                      height: cellHeight,
                      // ❌ Remove the margin to align perfectly with grid cells
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSel
                            ? Colors.grey.shade300
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$wd $mo $d',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: isSel
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
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
        } else if (_hkSelectedStart[room] != null &&
            _hkSelectedEnd[room] == null) {
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
                              TextSpan(
                                text: 'Room Number(s): ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: roomNumber),
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Dates: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '$startDate - $endDate'),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Select Status',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Additional Notes (Optional)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        TextField(
                          controller: notesController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _hkSelectedStart[room] = null;
                            _hkSelectedEnd[room] = null;
                            _activeHKRoom = null;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: selectedStatus == null
                            ? null
                            : () {
                                // Save housekeeping status for all selected dates
                                setState(() {
                                  _housekeepingStatus.putIfAbsent(
                                    room,
                                    () => {},
                                  );
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
    // Generate 30 days from selected start date
    final dates = _generateDatesFromStartDate(_currentStartDate, 30);

    final mainContent = LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Fixed Mode Toggle Header (Always Top Right)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  width: double.infinity,
                  color: const Color(0xFFFFF1AB),
                  child: Row(
                    children: [
                      Text(
                        'PROPERTY MANAGEMENT SYSTEM', // ← your system name
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade800, // match your theme
                        ),
                      ),

                      const SizedBox(width: 24),
                      const Spacer(),

                      // DATE PICKER BUTTON replacing month-year filter
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
                            Icons.calendar_today,
                            color: Colors.black54,
                          ),
                          label: Text(
                            "Start Day: ${_currentStartDate.day} ${_monthAbbr(_currentStartDate.month)} ${_currentStartDate.year}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: _currentStartDate,
                              firstDate: DateTime(_selectedYear - 5),
                              lastDate: DateTime(_selectedYear + 5),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                _currentStartDate = selectedDate;
                                _selectedYear = selectedDate.year;
                                _selectedMonth = selectedDate.month;
                              });
                            }
                          },
                        ),
                      ),

                      // Mode toggles
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
                        'Book Rooms',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 24),
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
                ),
              ),

              _buildDateHeaders(dates),
              // --- Horizontal Scroll for Date Headers and Calendar
              Expanded(
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          //
                        ],
                      ),

                      // --- Scrollable Room Rows
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
                                // Room Types Column
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

                                // Date Cells
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
        // Group header (e.g., STANDARD SINGLE ROOMS)
        Container(
          height: 40,
          width: 300,
          color: const Color(0xFF5B3A00), // dark brown
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              const Icon(Icons.hotel, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        // Room rows like: "101  Standard Single"
        ...roomList.asMap().entries.map((entry) {
          final isLast = entry.key == roomList.length - 1;
          final roomFull = entry.value;

          // Parse string like: 'Standard Single - Room No. 101'
          final match = RegExp(
            r'(.+?)\s*-\s*Room No\. (\d+)$',
          ).firstMatch(roomFull);
          final roomType = match?.group(1)?.trim() ?? title;
          final roomNumber = match?.group(2)?.trim() ?? '';

          return Container(
            width: 300,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: isLast
                    ? BorderSide.none
                    : BorderSide(color: Colors.grey.shade300),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  roomNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    roomType,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDateRows(String title, List<DateTime> dates) {
    const Radius cornerRadius = Radius.circular(10);
    final roomList = widget.rooms[title] ?? [];

    return Column(
      children: [
        // Placeholder row aligned with room header (empty)
        // Group header row color to match left-side group header
        Row(
          children: List.generate(
            dates.length,
            (_) => Container(
              width: cellWidth,
              height: headerCellHeight,
              color: const Color(0xFF5B3A00), // same as left group header
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
              final statusInfo = statusCode != null
                  ? roomStatusMap[statusCode]
                  : null;
              final hkColor = statusInfo != null
                  ? statusInfo['color'] as Color
                  : null;

              // Booking range highlight
              final isBookingSelected =
                  _mode == Mode.bookRooms &&
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
                  final prevStatus =
                      _housekeepingStatus[room]?[hkRangeStart - 1]?['status'];
                  if (prevStatus == statusCode) {
                    hkRangeStart = hkRangeStart - 1;
                  } else {
                    break;
                  }
                }

                hkRangeEnd = i;
                while (hkRangeEnd! < dates.length - 1) {
                  final nextStatus =
                      _housekeepingStatus[room]?[hkRangeEnd + 1]?['status'];
                  if (nextStatus == statusCode) {
                    hkRangeEnd = hkRangeEnd + 1;
                  } else {
                    break;
                  }
                }
              }

              bool isInsideMergedHKRange =
                  statusCode != null &&
                  hkRangeStart != null &&
                  hkRangeEnd != null &&
                  i >= hkRangeStart &&
                  i <= hkRangeEnd;
              bool isMergedHKRangeStart =
                  isInsideMergedHKRange && i == hkRangeStart;

              bool isMergedBookingRangeStart =
                  isBookingSelected && i == bookingStart;

              bool noBorder =
                  (isInsideMergedHKRange && statusCode != 'VR') ||
                  isBookingSelected ||
                  (isHKPreview && statusCode != 'VR');

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
                cursor:
                    ((_mode == Mode.bookRooms &&
                            (statusCode == null || statusCode == 'VR')) ||
                        _mode == Mode.housekeeping)
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic,
                child: GestureDetector(
                  onTap:
                      ((_mode == Mode.bookRooms &&
                              (statusCode == null || statusCode == 'VR')) ||
                          _mode == Mode.housekeeping)
                      ? () => _onCellTap(title, room, i)
                      : null,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      if (isMergedBookingRangeStart)
                        Positioned(
                          left: 0,
                          top: 0,
                          height: 50,
                          width: 80.0 * (bookingEnd! - bookingStart! + 1),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.yellow[300],
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),

                      if (isHKPreview &&
                          hkPreviewStart != null &&
                          hkPreviewEnd != null &&
                          i == hkPreviewStart &&
                          (statusCode == null || statusCode != 'VR'))
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

                      if (isMergedHKRangeStart &&
                          statusCode != null &&
                          statusCode != 'VR')
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

                      Container(
                        width: cellWidth,
                        height: cellHeight,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
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
