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

enum Mode { bookRooms, housekeeping }

const Map<String, Map<String, dynamic>> roomStatusMap = {
  // AVAILABLE
  'VD': {'color': Color(0xFF79511C), 'label': 'Vacant Dirty'},
  'VR': {'color': Color(0xFF307FCF), 'label': 'Vacant Ready'}, // #307FCF (blue)
  // OCCUPIED
  'OC': {'color': Color(0xFFCBECE6), 'label': 'Occupied Clean'},
  'OD': {'color': Color(0xFF074B0C), 'label': 'Occupied Dirty'},
  // UNAVAILABLE
  'OOO': {'color': Color(0xFF171300), 'label': 'Out of Order'},
  'BLO': {'color': Color(0xFFFFF1AB), 'label': 'Blocked'},
  'HU': {'color': Color(0xFFFDD41A), 'label': 'House Use'},
};

class _CalendarDashboardState extends State<CalendarDashboard> {
  static const double cellWidth = 100.0;
  static const double cellHeight = 50.0;
  static const double headerCellHeight = 40.0;
  static const double roomColumnWidth = 300;
  static const double roomColumnHeaderHeight = 50.0;

  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  Mode _mode = Mode.bookRooms;

  Map<String, List<Map<String, int>>> _housekeepingRanges = {};
  String? _activeHousekeepingRoom;
  int? _housekeepingStart;
  int? _housekeepingEnd;

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

  late DateTime _currentStartDate;

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.currentMonth;
    _selectedYear = widget.currentYear;

    _currentStartDate = DateTime(widget.currentYear, widget.currentMonth, 1);
    _selectedDate = _currentStartDate;
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

  Widget _buildDateHeaderRow(List<DateTime> dates) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Row(
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
            alignment: Alignment.center,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                ),
                children: [
                  TextSpan(text: '$wd $mo '),
                  TextSpan(
                    text: d,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _selectedMonth = now.month;
      _selectedYear = now.year;
    });
  }

  void _changeMonth(int month) {
    setState(() {
      _selectedMonth = month;
    });
  }

  void _changeYear(int delta) {
    setState(() {
      _selectedYear += delta;
    });
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

  Map<String, Map<int, Map<String, String>>> _housekeepingStatus = {};

  Map<String, int?> _hkSelectedStart = {};
  Map<String, int?> _hkSelectedEnd = {};
  String? _activeHKRoom;

  void _onCellTap(String roomType, String room, int dateIndex) {
    if (_mode == Mode.bookRooms) {
      setState(() {
        if (_activeBookingRoom != null &&
            _activeBookingRoom != room &&
            _selectedEnd[_activeBookingRoom!] == null) {
          return;
        }
        if (_selectedStart[room] == null ||
            (_selectedStart[room] != null && _selectedEnd[room] != null)) {
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

          setState(() {
            _selectedStart[room] = newStart;
            _selectedEnd[room] = newEnd;
            _activeBookingRoom = null;
          });

          final displayedDates = _generateDatesFromStartDate(
            _currentStartDate,
            30,
          );

          final startDt = displayedDates[newStart];
          final endDt = displayedDates[newEnd];

          final startDate = '${_monthAbbr(startDt.month)} ${startDt.day}';
          final endDate = '${_monthAbbr(endDt.month)} ${endDt.day}';

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                insetPadding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                titlePadding: EdgeInsets.only(top: 24),
                title: Center(
                  child: Text(
                    'Create New Booking?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Do you want to book Room $room from '
                      '${_monthAbbr(startDt.month)} ${startDt.day} '
                      'to ${_monthAbbr(endDt.month)} ${endDt.day}, ${endDt.year}?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This will take you to the Booking Page to '
                      'enter guest details and confirm.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                actionsPadding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                actions: [
                  Row(
                    children: [
                      // ── Cancel button ──
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _selectedStart[room] = null;
                              _selectedEnd[room] = null;
                            });
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size.fromHeight(48),
                            side: BorderSide(color: Colors.black, width: 1.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 32),
                          ),
                          child: Text('Cancel', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // ── Create Booking button with .then(...) ──
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AvailableCellPage(
                                  roomType: roomType,
                                  roomNumber: room,
                                  checkInDate: DateTime(
                                    startDt.year,
                                    startDt.month,
                                    startDt.day,
                                  ),
                                  checkOutDate: DateTime(
                                    endDt.year,
                                    endDt.month,
                                    endDt.day,
                                  ),
                                ),
                              ),
                            ).then((_) {
                              // Clear highlight on return
                              setState(() {
                                _selectedStart[room] = null;
                                _selectedEnd[room] = null;
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            minimumSize: Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 32),
                          ),
                          child: Text(
                            'Create Booking',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
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

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: _sidebarExpanded ? 180 : 60,
            color: const Color(0xFF291F16),
            child: Column(
              children: [
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
                          color: const Color(0xFF897249),
                        ),
                        onPressed: () => setState(
                          () => _sidebarExpanded = !_sidebarExpanded,
                        ),
                      ),
                    ],
                  ),
                ),

                // Menu Items
                Expanded(
                  child: Column(
                    children: [
                      _buildSidebarItem(
                        Icons.calendar_today,
                        'Calendar',
                        onTap: null,
                        isActive: true, // ✅ Highlights Calendar
                      ),
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
                      _buildSidebarItem(Icons.check_box, 'Available Cell'),
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

                // User Info
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
                            widget.studentName,
                            style: const TextStyle(
                              color: Color(0xFFFFFBF2),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.logout,
                            size: 18,
                            color: Color(0xFF897249),
                          ),
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

          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  width: double.infinity,
                  color: const Color(0xFFFFF1AB),
                  child: Row(
                    children: [
                      Text(
                        'PROPERTY MANAGEMENT SYSTEM',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade800,
                        ),
                      ),
                      const Spacer(),
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
                      Radio<Mode>(
                        value: Mode.bookRooms,
                        groupValue: _mode,
                        activeColor: const Color(0xFF664D21),
                        onChanged: (Mode? value) =>
                            setState(() => _mode = value!),
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
                        activeColor: const Color(0xFF9B2C13),
                        onChanged: (Mode? newValue) async {
                          if (newValue == Mode.housekeeping) {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                insetPadding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 24.0),
                                  child: Center(
                                    child: Text(
                                      'Switch to Housekeeping Mode?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "You're about to leave Booking Mode.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: const Color.fromARGB(
                                          255,
                                          46,
                                          45,
                                          45,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Unsaved selections or guest details will be cleared.\nDo you want to continue?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                actionsPadding: EdgeInsets.only(
                                  left: 24,
                                  right: 24,
                                  bottom: 24,
                                ),
                                actions: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color: Colors.black,
                                              width: 1.2,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 18,
                                              horizontal: 32,
                                            ),
                                            minimumSize: Size.fromHeight(48),
                                          ),
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 18,
                                              horizontal: 32,
                                            ),
                                            minimumSize: Size.fromHeight(48),
                                          ),
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text(
                                            'Switch to Housekeeping',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );

                            if (confirmed == true) {
                              setState(() => _mode = Mode.housekeeping);
                            }
                          } else {
                            setState(() => _mode = newValue!);
                          }
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
                          // Room Column
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: cellHeight,
                                width: roomColumnWidth,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.chevron_left),
                                      onPressed: () {
                                        setState(() {
                                          _currentStartDate = _currentStartDate
                                              .subtract(
                                                const Duration(days: 1),
                                              );
                                          if (_selectedDate.isBefore(
                                            _currentStartDate,
                                          )) {
                                            _selectedDate = _currentStartDate;
                                          }
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.chevron_right),
                                      onPressed: () {
                                        setState(() {
                                          _currentStartDate = _currentStartDate
                                              .add(const Duration(days: 1));
                                          final lastDate = _currentStartDate
                                              .add(const Duration(days: 29));
                                          if (_selectedDate.isAfter(lastDate)) {
                                            _selectedDate = lastDate;
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              _buildRoomColumn('STANDARD SINGLE ROOMS'),
                              _buildRoomColumn('SUPERIOR SINGLE ROOMS'),
                              _buildRoomColumn('STANDARD DOUBLE ROOMS'),
                              _buildRoomColumn('DELUXE ROOMS'),
                              _buildRoomColumn('FAMILY ROOMS'),
                              _buildRoomColumn('EXECUTIVE ROOMS'),
                              _buildRoomColumn('SUITE ROOMS'),
                            ],
                          ),

                          // Date Headers + Cells
                          Expanded(
                            child: Scrollbar(
                              controller: _horizontalScrollController,
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                controller: _horizontalScrollController,
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDateHeaderRow(dates),
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
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildSidebarItem(
    IconData icon,
    String title, {
    VoidCallback? onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
    );
  }

  Widget _buildRoomColumn(String title) {
    final roomList = widget.rooms[title] ?? [];

    final headerBg = _mode == Mode.housekeeping
        ? const Color(0xFF9B2C13)
        : const Color(0xFF5B3A00);

    // Handles both "100 Standard Single" and "Standard Single - Room No. 100"
    String extractRoomNumber(String raw) {
      if (raw.contains('Room No.')) {
        final match = RegExp(r'Room No\. (\d+)').firstMatch(raw);
        return match != null ? match.group(1)! : '???';
      } else {
        final parts = raw.split(' ');
        return parts.isNotEmpty ? parts[0] : '???';
      }
    }

    String extractRoomType(String raw) {
      if (raw.contains('Room No.')) {
        return raw.split(' - Room No.').first.trim();
      } else {
        final parts = raw.split(' ');
        return parts.length > 1 ? parts.sublist(1).join(' ') : 'Unknown Type';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row (e.g. "STANDARD SINGLE ROOMS")
        Container(
          height: 40,
          width: roomColumnWidth,
          color: headerBg,
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

        // Room Rows
        ...roomList.asMap().entries.map((entry) {
          final isLast = entry.key == roomList.length - 1;
          final rawRoom = entry.value;
          final roomNumber = extractRoomNumber(rawRoom);
          final roomType = extractRoomType(rawRoom);

          return Container(
            width: roomColumnWidth,
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

    final placeholderBg = _mode == Mode.housekeeping
        ? const Color(0xFF9B2C13)
        : const Color(0xFF5B3A00);

    return Column(
      children: [
        Row(
          children: List.generate(
            dates.length,
            (_) => Container(
              width: cellWidth,
              height: headerCellHeight,
              color: placeholderBg,
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
              Color? statusColor;
              if (statusCode != null) {
                final statusInfo = roomStatusMap[statusCode];
                statusColor = statusInfo?['color'] as Color?;
              }

              final isBookingSelected =
                  _mode == Mode.bookRooms &&
                  bookingStart != null &&
                  bookingEnd != null &&
                  i >= bookingStart &&
                  i <= bookingEnd;

              final selStart = _hkSelectedStart[room];
              final selEnd = _hkSelectedEnd[room];
              final isHKPreview =
                  _mode == Mode.housekeeping &&
                  selStart != null &&
                  selEnd != null &&
                  i >= selStart &&
                  i <= selEnd;

              BorderRadius? bookingRadius;
              if (isBookingSelected) {
                if (bookingStart == bookingEnd) {
                  bookingRadius = BorderRadius.circular(8);
                } else if (i == bookingStart) {
                  bookingRadius = const BorderRadius.horizontal(
                    left: cornerRadius,
                  );
                } else if (i == bookingEnd) {
                  bookingRadius = const BorderRadius.horizontal(
                    right: cornerRadius,
                  );
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

              final isInsideHKRange =
                  statusCode != null &&
                  hkRangeStart != null &&
                  hkRangeEnd != null &&
                  i >= hkRangeStart &&
                  i <= hkRangeEnd;

              final isHKRangeStart = isInsideHKRange && i == hkRangeStart;
              final isBookingRangeStart =
                  isBookingSelected && i == bookingStart;

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
                      // Booking highlight
                      if (isBookingRangeStart)
                        Positioned(
                          left: 0,
                          top: 0,
                          height: cellHeight,
                          width: cellWidth * (bookingEnd! - bookingStart! + 1),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.yellow[300],
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),

                      // Housekeeping preview (gray)
                      if (isHKPreview &&
                          selStart != null &&
                          selEnd != null &&
                          i == selStart &&
                          (statusCode == null || statusCode != 'VR'))
                        Positioned(
                          left: 0,
                          top: 0,
                          height: cellHeight,
                          width: cellWidth * (selEnd - selStart + 1),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: const BorderRadius.horizontal(
                                left: cornerRadius,
                                right: cornerRadius,
                              ),
                            ),
                          ),
                        ),

                      // Final housekeeping status block (non-VR)
                      if (isHKRangeStart &&
                          statusCode != null &&
                          statusCode != 'VR')
                        Positioned(
                          left: 0,
                          top: 0,
                          height: cellHeight,
                          width: cellWidth * (hkRangeEnd! - hkRangeStart! + 1),
                          child: Container(
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: const BorderRadius.horizontal(
                                left: cornerRadius,
                                right: cornerRadius,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              statusCode,
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

                      // The actual calendar cell
                      Container(
                        width: cellWidth,
                        height: cellHeight,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border:
                              (isInsideHKRange && statusCode != 'VR') ||
                                  isBookingSelected ||
                                  (isHKPreview && statusCode != 'VR')
                              ? null
                              : Border(
                                  right: i == dates.length - 1
                                      ? BorderSide.none
                                      : BorderSide(color: Colors.grey.shade300),
                                  bottom: isLastRoom
                                      ? BorderSide.none
                                      : BorderSide(color: Colors.grey.shade300),
                                ),
                          borderRadius: bookingRadius,
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
