import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'bookingdetails.dart';
import 'roomdetails.dart';
import 'guestdetails.dart';

class BookingPage extends StatefulWidget {
  final String bookingId;
  final String roomTypeKey;
  final String roomNumber;
  final DateTime checkIn;
  final DateTime checkOut;
  final VoidCallback? onRemove;

  const BookingPage({
    Key? key,
    required this.bookingId,
    required this.roomTypeKey,
    required this.roomNumber,
    required this.checkIn,
    required this.checkOut,
    this.onRemove,
  }) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late RoomDetail? detail;
  late int nights;
  late double roomRate;
  late double roomCharge;
  late double taxPerNight;
  late double totalTax;
  late double subTotal;
  late double total;
  int _currentStep = 0;

  final currencyFormatter = NumberFormat.currency(
    locale: 'en_PH',
    symbol: '₱ ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();

    detail = roomDetails[widget.roomTypeKey];
    nights = widget.checkOut.difference(widget.checkIn).inDays;
    if (nights <= 0) nights = 1;

    final rawDigits = detail?.price.replaceAll(RegExp(r'[^0-9]'), '') ?? '0';
    roomRate = double.tryParse(rawDigits) ?? 0;

    roomCharge = roomRate * nights;
    taxPerNight = 100; // sample fixed tax
    totalTax = taxPerNight * nights;
    subTotal = roomCharge + totalTax;
    total = subTotal;
  }

  String formattedDate(DateTime dt) => DateFormat('dd MMM yyyy').format(dt);

  @override
  Widget build(BuildContext context) {
    final timestamp = DateFormat('M/d/yy hh:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1300),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ─── Red header ───
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Container(
                        color: const Color(0xFFB71C1C),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.white),
                                  children: [
                                    TextSpan(
                                      text: 'Booking #${widget.bookingId}',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(text: ' — '),
                                    const TextSpan(
                                      text: 'Check In',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Booking TimeStamp:',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  timestamp,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ─── Stepper ───
                    // ─── Stepper ───
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _currentStep = 0),
                            child: _buildStepIcon(
                              index: 0,
                              label: 'Booking Details',
                              icon: Icons.assignment,
                            ),
                          ),
                          _buildStepDivider(),
                          GestureDetector(
                            onTap: () => setState(() => _currentStep = 1),
                            child: _buildStepIcon(
                              index: 1,
                              label: 'Guest Details',
                              icon: Icons.person,
                            ),
                          ),
                          _buildStepDivider(),
                          GestureDetector(
                            onTap: () => setState(() => _currentStep = 2),
                            child: _buildStepIcon(
                              index: 2,
                              label: 'Booking Extras',
                              icon: Icons.list_alt,
                            ),
                          ),
                          _buildStepDivider(),
                          GestureDetector(
                            onTap: () => setState(() => _currentStep = 3),
                            child: _buildStepIcon(
                              index: 3,
                              label: 'Payment Details',
                              icon: Icons.credit_card,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ─── Body ───
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ← left pane
                            Expanded(
                              flex: 3,
                              child: _currentStep == 1
                                  ? const GuestDetails()
                                  : BookingDetails(
                                      detail: detail,
                                      roomNumber: widget.roomNumber,
                                      roomTypeKey: widget.roomTypeKey,
                                    ),
                            ),
                            const SizedBox(width: 24),

                            // → right summary
                            SizedBox(
                              width: 350,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        // — “Your Booking” header + button
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          child: Row(
                                            children: [
                                              const Expanded(
                                                child: Text(
                                                  'Your Booking',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(
                                                    0xFFFFBD00,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                  elevation: 0,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8,
                                                      ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const [
                                                    Text(
                                                      'Book More',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(width: 6),
                                                    Icon(
                                                      Icons.add,
                                                      size: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // — details box
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                              20,
                                              10,
                                              20,
                                              20,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.grey.shade400,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // ─── Header: Room title + remove button ───
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        '${widget.roomNumber} - ${detail?.name ?? widget.roomTypeKey}',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons
                                                            .remove_circle_outline,
                                                        size: 20,
                                                        color: Colors
                                                            .grey
                                                            .shade600,
                                                      ),
                                                      onPressed: () => widget
                                                          .onRemove
                                                          ?.call(),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    const Text(
                                                      'Room',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    const Expanded(
                                                      child: Divider(
                                                        color: Colors.black,
                                                        thickness: 1,
                                                        height: 1.5,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 6),

                                                // ─── Details rows ───
                                                _buildTwoColumn(
                                                  left: 'Check In',
                                                  right: formattedDate(
                                                    widget.checkIn,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                _buildTwoColumn(
                                                  left: 'Check Out',
                                                  right: formattedDate(
                                                    widget.checkOut,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                _buildTwoColumn(
                                                  left: 'Room Charge',
                                                  right: currencyFormatter
                                                      .format(roomCharge),
                                                ),
                                                const SizedBox(height: 4),
                                                _buildTwoColumn(
                                                  left: 'Tax',
                                                  right: currencyFormatter
                                                      .format(totalTax),
                                                ),

                                                const SizedBox(height: 4),

                                                // ─── Sub Total bold ───
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Sub Total',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      currencyFormatter.format(
                                                        subTotal,
                                                      ),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // — total & buttons
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            16,
                                            12,
                                            16,
                                            0,
                                          ),
                                          child: Row(
                                            children: [
                                              const Expanded(
                                                child: Text(
                                                  'Total',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                currencyFormatter.format(total),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            16,
                                            0,
                                            16,
                                            16,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    side: const BorderSide(
                                                      color: Color(0xFF686461),
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            30,
                                                          ),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 16,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (_currentStep < 3)
                                                        _currentStep++;
                                                    });
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFFFFBD00),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            30,
                                                          ),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 16,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    'Continue',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIcon({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final highlighted = index <= _currentStep;
    final active = index == _currentStep;

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: highlighted ? const Color(0xFFFFBD00) : Colors.grey.shade100,
            shape: BoxShape.circle,
            border: Border.all(
              color: highlighted ? Colors.transparent : Colors.grey.shade400,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: highlighted ? Colors.white : Colors.grey.shade700,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: highlighted ? Colors.black : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider() {
    return Container(
      width: 40,
      height: 1,
      color: Colors.grey.shade400,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildTwoColumn({required String left, required String right}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(left, style: const TextStyle(fontSize: 12)),
        ),
        Expanded(
          flex: 3,
          child: Text(
            right,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
