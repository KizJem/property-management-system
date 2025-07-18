import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'roomdetails.dart';

int _getMaxGuests(String roomType) {
  switch (roomType.toUpperCase()) {
    case 'STANDARD SINGLE ROOMS':
    case 'SUPERIOR SINGLE ROOMS':
      return 1;
    case 'STANDARD DOUBLE ROOMS':
    case 'DELUXE ROOMS':
    case 'EXECUTIVE ROOMS':
    case 'SUITE ROOMS':
      return 2;
    case 'FAMILY ROOMS':
      return 5;
    default:
      return 1;
  }
}

class RoomFeature extends StatelessWidget {
  final IconData icon;
  final String label;

  const RoomFeature({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.001),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}

class AvailableCellPage extends StatefulWidget {
  final String roomType;
  final String roomNumber;
  final DateTime checkInDate;
  final DateTime checkOutDate;

  const AvailableCellPage({
    super.key,
    required this.roomType,
    required this.roomNumber,
    required this.checkInDate,
    required this.checkOutDate,
  });

  @override
  State<AvailableCellPage> createState() => AvailableCellPageState();
}

class AvailableCellPageState extends State<AvailableCellPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  String? _firstNameError;
  String? _lastNameError;
  String? _phoneError;

  void _handleContinue() {
    setState(() {
      _firstNameError = _firstNameController.text.trim().isEmpty
          ? 'Please enter first name'
          : null;
      _lastNameError = _lastNameController.text.trim().isEmpty
          ? 'Please enter last name'
          : null;
      _phoneError = _phoneController.text.trim().isEmpty
          ? 'Please enter phone number'
          : null;
    });

    if (_firstNameError == null &&
        _lastNameError == null &&
        _phoneError == null) {
      final fullName =
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
      final guests = '1';
      final specialRequest = 'None';
      final price = roomDetails[widget.roomType]?.price ?? '₱0';
      final checkInFormatted = DateFormat.yMMMMd().format(widget.checkInDate);
      final checkOutFormatted = DateFormat.yMMMMd().format(widget.checkOutDate);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          content: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24.0,
              horizontal: 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Confirm this reservation?',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                _buildRow(Icons.person, 'Guest Name', fullName),
                _buildRow(
                  Icons.date_range,
                  'Arrival & Departure Dates',
                  '$checkInFormatted - $checkOutFormatted',
                ),
                _buildRow(Icons.people, 'No. of Guests', guests),
                _buildRow(
                  Icons.meeting_room,
                  'Room',
                  'NO. ${widget.roomNumber.toUpperCase()}',
                ),
                _buildRow(Icons.price_change, 'Price', price.toUpperCase()),
                _buildRow(Icons.notes, 'Special Requests', specialRequest),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          side: const BorderSide(color: Colors.black),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 220,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Confirm Booking',
                          style: TextStyle(color: Colors.white),
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
    }
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.black87),
          const SizedBox(width: 12),
          // Label + colon aligned
          SizedBox(
            width: 220, // Adjust width based on your longest label
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
                const Text(
                  " :",
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Value
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final details = roomDetails[widget.roomType]!;
    final now = DateTime.now();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;

          bool isDesktop = screenWidth >= 1440;
          bool isLaptop = screenWidth >= 1024 && screenWidth < 1440;
          bool isSmallLaptop = screenWidth < 1024;

          double leftPadding = isDesktop
              ? 80
              : isLaptop
              ? 40
              : 20;
          double rightPadding = isDesktop
              ? 80
              : isLaptop
              ? 40
              : 20;

          return Container(
            color: const Color(0xFFFFFBF2),
            padding: EdgeInsets.fromLTRB(leftPadding, 20, rightPadding, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT SIDE
                Expanded(
                  flex: isDesktop ? 6 : 5,
                  child: buildLeftColumn(details),
                ),
                const SizedBox(width: 20),
                // RIGHT SIDE
                Expanded(flex: isDesktop ? 5 : 5, child: buildRightColumn(now)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildLeftColumn(RoomDetail details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFF444444), width: 0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.asset(
                  details.imageAsset,
                  fit: BoxFit.cover,
                  height: 280,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.meeting_room, size: 22),
                            const SizedBox(width: 6),
                            Text(
                              '${widget.roomNumber.replaceAll(RegExp(r'[^0-9]'), '')} - ${details.name}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          details.price,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      details.description,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 0.3, color: Colors.black),
                    const SizedBox(height: 10),
                    const Text(
                      'Room Features',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Column(children: details.featuresLeft)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(children: details.featuresRight),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildRightColumn(DateTime now) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking # and Timestamp
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Booking #0000',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Booking TimeStamp:',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      Text(
                        '${now.month}/${now.day}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Contact Details
              Container(
                padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF444444),
                    width: 0.3,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),

                    // First Row: First name & Last name
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text.rich(
                                TextSpan(
                                  text: 'First name ',
                                  style: TextStyle(fontSize: 13),
                                  children: [
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                height: 40,
                                child: TextField(
                                  controller: _firstNameController,
                                  decoration: InputDecoration(
                                    hintText: "Enter guest’s first name",
                                    hintStyle: const TextStyle(
                                      color: Colors.black45,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 14,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Colors.black26,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: _firstNameError != null
                                            ? Colors.red
                                            : Colors.black26,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: _firstNameError != null
                                            ? Colors.red
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                height: 16,
                                child: Text(
                                  _firstNameError ?? ' ',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text.rich(
                                TextSpan(
                                  text: 'Last name ',
                                  style: TextStyle(fontSize: 13),
                                  children: [
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                height: 40,
                                child: TextField(
                                  controller: _lastNameController,
                                  decoration: InputDecoration(
                                    hintText: "Enter guest’s last name",
                                    hintStyle: const TextStyle(
                                      color: Colors.black45,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 14,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Colors.black26,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: _lastNameError != null
                                            ? Colors.red
                                            : Colors.black26,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: _lastNameError != null
                                            ? Colors.red
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                height: 16,
                                child: Text(
                                  _lastNameError ?? ' ',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Second Row: Phone number & Email
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text.rich(
                                TextSpan(
                                  text: 'Phone number ',
                                  style: TextStyle(fontSize: 13),
                                  children: [
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                height: 40,
                                child: TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: "Enter guest’s phone number",
                                    hintStyle: const TextStyle(
                                      color: Colors.black45,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 14,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Colors.black26,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: _phoneError != null
                                            ? Colors.red
                                            : Colors.black26,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: _phoneError != null
                                            ? Colors.red
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                height: 16,
                                child: Text(
                                  _phoneError ?? ' ',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text.rich(
                                TextSpan(
                                  text: 'Email ',
                                  style: TextStyle(fontSize: 13),
                                  children: [
                                    TextSpan(
                                      text: '(optional)',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                height: 40,
                                child: TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: "Enter guest’s email address",
                                    hintStyle: const TextStyle(
                                      color: Colors.black45,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 14,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Colors.black26,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Colors.black26,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              // Booking Details
              Container(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFF444444), width: 0.3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Booking Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Radio(value: true, groupValue: true, onChanged: (_) {}),
                        const Text(
                          'Reservation',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 10),
                        Radio(
                          value: false,
                          groupValue: true,
                          onChanged: (_) {},
                        ),
                        const Text('Check-In', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Arrival and Departure Date',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_month, size: 20),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        '${DateFormat('MMMM d, yyyy').format(widget.checkInDate).toUpperCase()}  –  ${DateFormat('MMMM d, yyyy').format(widget.checkOutDate).toUpperCase()}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Number of Guests',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SizedBox(
                                  height: 40,
                                  child: DropdownButtonFormField<int>(
                                    value: 1,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                        top: 0,
                                        bottom: 8,
                                      ),
                                    ),
                                    items: List.generate(
                                      _getMaxGuests(widget.roomType),
                                      (index) {
                                        final value = index + 1;
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Row(
                                            children: [
                                              const Icon(Icons.person_outline),
                                              const SizedBox(width: 8),
                                              Text('$value'),
                                            ],
                                          ),
                                        );
                                      },
                                    ),

                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Room Number',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          height: 40,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.meeting_room_outlined),
                              const SizedBox(width: 10),
                              Text(
                                '${widget.roomType.toUpperCase()} - ${widget.roomNumber.toUpperCase()}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Special Requests',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Note special requests here.',
                        hintStyle: const TextStyle(color: Colors.black38),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black26),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black26),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 1.0,
                          ),
                        ),
                      ),
                      maxLines: 3,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              // Continue Action Button
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFFFFF),
                        foregroundColor: const Color(0xFF000003),
                        side: const BorderSide(
                          color: Color(0xFF000003),
                          width: 0.3,
                        ),
                        minimumSize: const Size.fromHeight(45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _handleContinue,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF000003),
                        foregroundColor: const Color(0xFFFFFFFF),
                        side: const BorderSide(
                          color: Color(0xFF000003),
                          width: 0.3,
                        ),
                        minimumSize: const Size.fromHeight(45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
