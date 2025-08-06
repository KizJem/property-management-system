import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'booking.dart';
import 'occupiedcell.dart';
import 'reservecell.dart';
import 'roomdetails.dart';
import 'userlogin.dart';

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
  'VD': {'color': Color(0xFF7F5226), 'label': 'Vacant Dirty'},
  'VR': {'color': Color(0xFFFFC904), 'label': 'Vacant Ready'},
  // OCCUPIED
  'OC': {'color': Color(0xFF527E03), 'label': 'Occupied Clean'},
  'OD': {'color': Color(0xFFFD9B06), 'label': 'Occupied Dirty'},
  // UNAVAILABLE
  'OOO': {'color': Color(0xFF171300), 'label': 'Out of Order'},
  'BLO': {'color': Color(0xFF686461), 'label': 'Blocked'},
  'HU': {'color': Color(0xFFA80504), 'label': 'House Use'},
};

class _CalendarDashboardState extends State<CalendarDashboard> {
  Map<String, bool> _expandedRoomTypes = {};

  double get cellWidth {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth - roomColumnWidth) / _viewDays;
  }

  double get sidebarWidth {
    return _sidebarExpanded ? _sidebarWidth : _sidebarCollapsedWidth;
  }

  int _viewDays = 28; // Default
  static const double cellHeight = 50.0;
  static const double headerCellHeight = 50.0;
  static const double roomColumnWidth = 90.0;
  static const double roomColumnHeaderHeight = 50.0;

  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _headerScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    _headerScrollController.dispose();
    super.dispose();
  }

  Mode _mode = Mode.bookRooms;

  Map<String, List<Map<String, int>>> _housekeepingRanges = {};
  String? _activeHousekeepingRoom;
  int? _housekeepingStart;
  int? _housekeepingEnd;

  String _shortWeekday(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[(weekday - 1) % 7];
  }

  int get _currentStartMonth => _currentStartDate.month;

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
    _horizontalScrollController.addListener(() {
      if (_headerScrollController.hasClients) {
        _headerScrollController.jumpTo(_horizontalScrollController.offset);
      }
    });
    _headerScrollController.addListener(() {
      if (_horizontalScrollController.hasClients) {
        _horizontalScrollController.jumpTo(_headerScrollController.offset);
      }
    });

    _selectedMonth = widget.currentMonth;
    _selectedYear = widget.currentYear;
    _currentStartDate = DateTime(widget.currentYear, widget.currentMonth, 1);
    _selectedDate = _currentStartDate;

    // Expand all room types by default
    for (var key in widget.rooms.keys) {
      _expandedRoomTypes[key] = true;
    }

    _sidebarExpanded = false;
  }

  DateTime _selectedDate = DateTime.now();

  List<DateTime> _generateDatesFromStartDate(
    DateTime startDate,
    int daysToShow,
  ) {
    return List.generate(daysToShow, (i) => startDate.add(Duration(days: i)));
  }

  List<String> _splitTitle(String title) {
    final cleaned = title.replaceAll("ROOMS", "").trim();
    final parts = cleaned.split(" ");

    if (parts.length == 1) {
      return [parts.first, '']; // e.g., "Deluxe"
    } else {
      return [
        parts.first,
        parts.sublist(1).join(" "),
      ]; // e.g., "Standard Single"
    }
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

  void _showLogoutPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFFF8F3FA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Log Out?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Are you sure you want to log out?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(
                              0xFFFFBD00,
                            ), // Yellow background
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Log Out',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white, // White text
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateHeaderRow(List<DateTime> dates) {
    return Row(
      children: dates.map((date) {
        final weekday = _shortWeekday(date.weekday);
        final day = date.day.toString().padLeft(2, '0');
        final month = _monthAbbr(date.month);

        return GestureDetector(
          onTap: () => setState(() => _selectedDate = date),
          child: Container(
            width: cellWidth,
            height: cellHeight,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF7FF), // Light background
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFFFD700), // Red bottom border
                  width: 2.0,
                ),
                right: BorderSide(color: Colors.grey.shade300),
              ),
            ),

            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  weekday,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 31, 30, 30),
                  ),
                ),
                Text(
                  day,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  month,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 31, 30, 30),
                  ),
                ),
              ],
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
              String action = 'Check-In';
              final roomNumberOnly =
                  RegExp(r'(\d+)').firstMatch(room)?.group(1) ?? room;
              final formattedRoomType =
                  roomType
                      .replaceAll('ROOMS', '')
                      .trim()
                      .toLowerCase()
                      .split(RegExp(r'\s+'))
                      .where((w) => w.isNotEmpty)
                      .map((w) => w[0].toUpperCase() + w.substring(1))
                      .join(' ') +
                  ' Room';

              // get price dynamically from roomDetails
              final roomDetail = roomDetails[roomType];
              double nightlyRate;
              if (roomDetail != null) {
                final rawDigits = roomDetail.price.replaceAll(
                  RegExp(r'[^0-9]'),
                  '',
                );
                nightlyRate = double.tryParse(rawDigits) ?? 0;
              } else {
                nightlyRate = 0;
              }

              final priceText = NumberFormat.currency(
                locale: 'en_PH',
                symbol: '₱ ',
                decimalDigits: 0,
              ).format(nightlyRate);

              return Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: StatefulBuilder(
                  builder: (context, setStateDialog) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 500,
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 24,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Confirm Action',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Would you like to proceed with:',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // --- Removed radio buttons for action selection ---
                            const SizedBox(height: 20),
                            // room detail card
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$roomNumberOnly - $formattedRoomType',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: const Text(
                                                'Check In',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${_monthAbbr(startDt.month)} ${startDt.day} ${startDt.year}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: const Text(
                                                'Check Out',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${_monthAbbr(endDt.month)} ${endDt.day} ${endDt.year}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '$priceText / night',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFB71C1C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
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
                                      backgroundColor: Colors.white,
                                      minimumSize: const Size.fromHeight(48),
                                      side: const BorderSide(
                                        color: Colors.black,
                                        width: 1.2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                      ),
                                    ),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pop(); // close the confirm dialog first

                                      // generate a simple booking ID like "0001" (you can replace with real logic)
                                      final bookingId =
                                          (DateTime.now()
                                                      .millisecondsSinceEpoch %
                                                  10000)
                                              .toString()
                                              .padLeft(4, '0');

                                      // Navigate to BookingPage
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BookingPage(
                                            bookingId: bookingId,
                                            roomTypeKey: roomType,
                                            roomNumber: roomNumberOnly,
                                            checkIn: startDt,
                                            checkOut: endDt,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFFBD00),
                                      minimumSize: const Size.fromHeight(48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text(
                                      'Continue',
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
                      ),
                    );
                  },
                ),
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
          final displayedDates = _generateDatesFromStartDate(
            _currentStartDate,
            30,
          );
          final startDt = displayedDates[startIdx];
          final endDt = displayedDates[endIdx];

          final startDate = '${_monthAbbr(startDt.month)} ${startDt.day}';
          final endDate =
              '${_monthAbbr(endDt.month)} ${endDt.day}, ${endDt.year}';
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
    final dates = _generateDatesFromStartDate(_currentStartDate, _viewDays);
    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _sidebarExpanded ? 180 : 0,
            curve: Curves.easeInOut,
            color: const Color(0xFFFFBD00),
            child: _sidebarExpanded
                ? Column(
                    children: [
                      // Toggle + Logo
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/images/PMS-logo-2.png',
                              width: 30,
                              height: 30,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.chevron_left,
                                size: 24,
                                color: Color(0xFF710100),
                              ),
                              onPressed: () =>
                                  setState(() => _sidebarExpanded = false),
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
                              isActive: true,
                            ),
                            _buildSidebarItem(
                              Icons.bed,
                              'Guest Records',
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/guestrecords',
                                  arguments: {
                                    'studentName': widget.studentName,
                                  },
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
                                  arguments: {
                                    'studentName': widget.studentName,
                                  },
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
                                    builder: (context) =>
                                        const ReservecellPage(),
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
                                    builder: (context) =>
                                        const OccupiedCellPage(),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.account_circle,
                              color: Color(0xFFFFFBF2),
                              size: 20,
                            ),
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
                                color: Color(0xFF710100),
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
                        ),
                      ),
                    ],
                  )
                : null,
          ),

          Expanded(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔴 Red Header
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF9B000A), // Deep red
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFFFD400), // Yellow bottom border
                            width: 3,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // PMS Logo
                          Image.asset(
                            'assets/images/pms-logo-white.png',
                            height: 80,
                            width: 80,
                          ),
                          const SizedBox(width: 16),

                          // Text Block
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'PROPERTY MANAGEMENT SYSTEM',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Hello, Receptionist!',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // 🟡 Yellow Calendar Strip
                    Container(
                      color: const Color(0xFFFFD400), // Yellow background
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Calendar',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                          const Spacer(),

                          // Start Date Button (red with date + calendar icon on right)
                          ElevatedButton(
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
                                  _selectedMonth = selectedDate.month;
                                  _selectedYear = selectedDate.year;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB00000), // Red
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  DateFormat(
                                    'dd-MMM-yyyy',
                                  ).format(_currentStartDate),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.calendar_month,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // View Mode Selector (Red box with < 28 days >)
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFB00000), // Red
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.chevron_left,
                                    color: Colors.white,
                                  ),
                                  iconSize: 20,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    setState(() {
                                      _currentStartDate = _currentStartDate
                                          .subtract(Duration(days: 1));
                                    });
                                  },
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    // Still interactive for dropdown
                                    showMenu(
                                      context: context,
                                      position: const RelativeRect.fromLTRB(
                                        100,
                                        140,
                                        1,
                                        0,
                                      ),

                                      items: [
                                        PopupMenuItem(
                                          child: const Text("7 days"),
                                          onTap: () =>
                                              setState(() => _viewDays = 7),
                                        ),
                                        PopupMenuItem(
                                          child: const Text("14 days"),
                                          onTap: () =>
                                              setState(() => _viewDays = 14),
                                        ),
                                        PopupMenuItem(
                                          child: const Text("28 days"),
                                          onTap: () =>
                                              setState(() => _viewDays = 28),
                                        ),
                                      ],
                                    );
                                  },
                                  child: Text(
                                    '$_viewDays days',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                IconButton(
                                  icon: const Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  ),
                                  iconSize: 20,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    setState(() {
                                      _currentStartDate = _currentStartDate.add(
                                        Duration(days: 1),
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: Stack(
                    children: [
                      // ─── Main Scrollable Body ───
                      Positioned.fill(
                        child: Scrollbar(
                          controller: _verticalScrollController,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: _verticalScrollController,
                            scrollDirection: Axis.vertical,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ─── Left: Room column ───
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Spacer for date header
                                    SizedBox(
                                      width: roomColumnWidth,
                                      height: cellHeight,
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

                                // ─── Right: Scrollable Dates + Cells ───
                                Expanded(
                                  child: Scrollbar(
                                    controller: _horizontalScrollController,
                                    thumbVisibility: true,
                                    child: SingleChildScrollView(
                                      controller: _horizontalScrollController,
                                      scrollDirection: Axis.horizontal,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Spacer to align with sticky header
                                          SizedBox(height: cellHeight),
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
                                          _buildDateRows(
                                            'EXECUTIVE ROOMS',
                                            dates,
                                          ),
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

                      // ─── Sticky Header ───
                      Positioned(
                        top: 0,
                        left: roomColumnWidth,
                        right: 0,
                        height: cellHeight,
                        child: IgnorePointer(
                          child: Container(
                            color: const Color(0xFFFEF7FF),
                            child: AnimatedBuilder(
                              animation: _horizontalScrollController,
                              builder: (context, child) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: OverflowBox(
                                    alignment: Alignment.topLeft,
                                    minWidth: 0,
                                    maxWidth: double.infinity,
                                    child: Transform.translate(
                                      offset: Offset(
                                        -_horizontalScrollController.offset,
                                        0,
                                      ),
                                      child: _buildDateHeaderRow(dates),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // ─── Fixed Spacer Container (no arrows) ───
                      Positioned(
                        top: 0,
                        left: 0,
                        width: roomColumnWidth,
                        height: cellHeight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF7FF),
                            border: const Border(
                              bottom: BorderSide(
                                color: Color(0xFFFFD700), // Red bottom border
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
          color: isActive ? const Color(0xFFFFBD00) : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: _sidebarExpanded
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: const Color(0xFF710100)),
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
        ? const Color(0xFFD10E0E)
        : const Color(0xFFD10E0E);

    // Format title like "Standard Single"
    List<String> _splitTitle(String title) {
      final cleaned = title
          .replaceAll("ROOMS", "")
          .trim()
          .split(' ')
          .where((word) => word.isNotEmpty)
          .map(
            (word) => word[0].toUpperCase() + word.substring(1).toLowerCase(),
          )
          .toList();

      if (cleaned.length == 1) {
        return [cleaned.first, ''];
      } else {
        return [cleaned.first, cleaned.sublist(1).join(" ")];
      }
    }

    String extractRoomNumber(String raw) {
      final match = RegExp(r'(\d+)').firstMatch(raw);
      return match != null ? match.group(1)! : raw;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Room Type Header (e.g., "Standard \nSingle")
        Container(
          width: roomColumnWidth,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: headerBg,
            border: const Border(
              right: BorderSide(
                color: const Color(0xFFFEF7FF),
                width: 0.3,
              ), // ➜ vertical white line
              bottom: BorderSide(
                color: const Color(0xFFFEF7FF),
                width: 0.3,
              ), // optional: bottom line
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _splitTitle(title).first,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      _splitTitle(title).last,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  _expandedRoomTypes[title] == true
                      ? Icons
                            .arrow_drop_down // ▼ When expanded
                      : Icons.arrow_right, // ▶ When collapsed
                  color: Colors.white,
                  size: 20, // Adjust size to match your image
                ),
                onPressed: () {
                  setState(() {
                    _expandedRoomTypes[title] =
                        !(_expandedRoomTypes[title] ?? true);
                  });
                },
              ),
            ],
          ),
        ),

        // Room Numbers
        if (_expandedRoomTypes[title] == true)
          ...roomList.asMap().entries.map((entry) {
            final isLast = entry.key == roomList.length - 1;
            final rawRoom = entry.value;
            final roomNumber = extractRoomNumber(rawRoom);

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
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                roomNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
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
        ? const Color(0xFFD10E0E)
        : const Color(0xFFD10E0E);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Red spacer to align with red room header
        Container(
          width: cellWidth * dates.length,
          height: headerCellHeight,
          decoration: BoxDecoration(
            color: const Color(0xFFD10E0E),
            border: Border(
              right: BorderSide(
                color: const Color(0xFFFEF7FF),
                width: 0.3, // <-- super thin vertical lines
              ),
              bottom: const BorderSide(
                color: const Color(0xFFFEF7FF),
                width: 0.3, // optional
              ),
            ),
          ),
        ),

        // Conditionally render room rows
        if (_expandedRoomTypes[title] == true)
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
                        // Booking highlight (yellow block)
                        if (isBookingRangeStart)
                          Positioned(
                            left: 0,
                            top: 0,
                            height: cellHeight,
                            width:
                                cellWidth * (bookingEnd! - bookingStart! + 1),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.yellow[300],
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),

                        // Housekeeping preview (gray block)
                        if (_mode == Mode.housekeeping &&
                            selStart != null &&
                            i == selStart &&
                            (statusCode == null || statusCode != 'VR'))
                          Positioned(
                            left: 0,
                            top: 0,
                            height: cellHeight,
                            width:
                                cellWidth *
                                ((selEnd ?? selStart) - selStart + 1),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),

                        // Housekeeping status block (non-VR)
                        if (isHKRangeStart &&
                            statusCode != null &&
                            statusCode != 'VR')
                          Positioned(
                            left: 0,
                            top: 0,
                            height: cellHeight,
                            width:
                                cellWidth * (hkRangeEnd! - hkRangeStart! + 1),
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

                        // Regular calendar cell
                        // Regular calendar cell (render only if no red block)
                        if (!(isInsideHKRange && statusCode != 'VR'))
                          Container(
                            width: cellWidth,
                            height: cellHeight,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border:
                                  isBookingSelected ||
                                      (isHKPreview && statusCode != 'VR')
                                  ? Border.all(color: Colors.transparent)
                                  : Border(
                                      right: i == dates.length - 1
                                          ? BorderSide.none
                                          : BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                      bottom: isLastRoom
                                          ? BorderSide.none
                                          : BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
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
