import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'roomdetails.dart';

class RoomFeature extends StatelessWidget {
  final IconData icon;
  final String label;

  const RoomFeature({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
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
      final email = _emailController.text.trim();
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final phone = _phoneController.text.trim();

      Navigator.pop(context);
    }
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
      body: Container(
        color: const Color(0xFFFFF1AB),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // LEFT SIDE - DYNAMIC ROOM DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Room Preview Section
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xFFFEA525)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 270,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                details.imageAsset,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                details.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
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
                          Text(details.description),
                          const SizedBox(height: 10),
                          const Text(
                            'Room Features',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(children: details.featuresLeft),
                              ),
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

              const SizedBox(width: 20),

              // RIGHT SIDE - BOOKING FORM
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
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Booking TimeStamp:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
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
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xFFFEA525)),
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
                          const SizedBox(height: 10),

                          // First Row: First Name & Last Name
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      controller: _firstNameController,
                                      decoration: InputDecoration(
                                        labelText: 'First Name *',
                                        labelStyle: TextStyle(
                                          color: _firstNameError != null
                                              ? Colors.red
                                              : null,
                                        ),
                                        border: OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: _firstNameError != null
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: _firstNameError != null
                                                ? Colors.red
                                                : Colors.blue,
                                          ),
                                        ),
                                        helperText: ' ',
                                      ),
                                    ),
                                    if (_firstNameError != null)
                                      Transform.translate(
                                        offset: const Offset(0, -20),
                                        child: Text(
                                          _firstNameError!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
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
                                    TextField(
                                      controller: _lastNameController,
                                      decoration: InputDecoration(
                                        labelText: 'Last Name *',
                                        labelStyle: TextStyle(
                                          color: _lastNameError != null
                                              ? Colors.red
                                              : null,
                                        ),
                                        border: OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: _lastNameError != null
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: _lastNameError != null
                                                ? Colors.red
                                                : Colors.blue,
                                          ),
                                        ),
                                        helperText: ' ',
                                      ),
                                    ),
                                    if (_lastNameError != null)
                                      Transform.translate(
                                        offset: const Offset(0, -20),
                                        child: Text(
                                          _lastNameError!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Second Row: Phone Number & Email
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        labelText: 'Phone Number *',
                                        labelStyle: TextStyle(
                                          color: _phoneError != null
                                              ? Colors.red
                                              : null,
                                        ),
                                        border: const OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: _phoneError != null
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: _phoneError != null
                                                ? Colors.red
                                                : Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      height: 16,
                                      child: Text(
                                        _phoneError ??
                                            ' ', // Show error or blank space
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
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
                                    TextField(
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                        labelText: 'Email (Optional)',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const SizedBox(
                                      height: 16,
                                      child: Text(
                                        ' ', // Invisible placeholder for alignment
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Booking Details
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xFFFEA525)),
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
                              Radio(
                                value: true,
                                groupValue: true,
                                onChanged: (_) {},
                              ),
                              const Text('Reservation'),
                              const SizedBox(width: 10),
                              Radio(
                                value: false,
                                groupValue: true,
                                onChanged: (_) {},
                              ),
                              const Text('Check-In'),
                            ],
                          ),
                          const Text(
                            'Arrival and Departure Date',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month),
                              const SizedBox(width: 10),

                              // Check-in Date
                              Container(
                                width: 150,
                                height: 36,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                alignment: Alignment.center,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    DateFormat(
                                      'MMMM d, yyyy',
                                    ).format(widget.checkInDate).toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              const Text(
                                '-',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Check-out Date
                              Container(
                                width: 150,
                                height: 36,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                alignment: Alignment.center,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    DateFormat(
                                      'MMMM d, yyyy',
                                    ).format(widget.checkOutDate).toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Room Number',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black26,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                      child: Text(
                                        widget.roomNumber,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
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
                                    const Text(
                                      'No. of Guest',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black26,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Enter number',
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Special Requests (Optional)',
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                            maxLines: 3,
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
                              backgroundColor: const Color(0xFFFFFBF1),
                              foregroundColor: const Color(0xFF0F0F0F),
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _handleContinue,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFFDD41A),
                              foregroundColor: const Color(0xFF0F0F0F),
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Continue'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
