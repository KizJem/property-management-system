import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'bookingdetails.dart';
import 'roomdetails.dart';
import 'guestdetails.dart';
import 'bookingextras.dart';
import 'dart:async';
import 'paymentdetails.dart';

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
  Timer? _timer;
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
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {});

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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formattedDate(DateTime dt) => DateFormat('dd MMM yyyy').format(dt);

  @override
  Widget build(BuildContext context) {
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
                                StreamBuilder<DateTime>(
                                  stream: Stream.periodic(
                                    const Duration(seconds: 1),
                                    (_) => DateTime.now(),
                                  ),
                                  builder: (context, snapshot) {
                                    final now = snapshot.data ?? DateTime.now();
                                    final ts = DateFormat(
                                      'M/d/yy hh:mm:ss a',
                                    ).format(now);
                                    return Text(
                                      ts,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ─── Stepper ───
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              child: _currentStep == 0
                                  ? BookingDetails(
                                      detail: detail,
                                      roomNumber: widget.roomNumber,
                                      roomTypeKey: widget.roomTypeKey,
                                    )
                                  : _currentStep == 1
                                  ? const GuestDetails()
                                  : _currentStep == 2
                                  ? BookingExtras(
                                      rooms: [
                                        RoomExtraData(
                                          roomTitle:
                                              '${widget.roomNumber} – ${detail?.name ?? widget.roomTypeKey}',
                                          guestLabel: 'Guest 1',
                                        ),
                                      ],
                                    )
                                  : const PaymentDetails(),
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
                                                    0xFFFFD700,
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

                                        // — **Updated** summary box
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
                                                // Room title + remove
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

                                                // Check-in / Check-out / Nights
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
                                                  left: 'Nights',
                                                  right: '$nights',
                                                ),

                                                const SizedBox(height: 8),
                                                const Row(
                                                  children: [
                                                    Text(
                                                      'Charges',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Expanded(
                                                      child: Divider(
                                                        color: Colors.black,
                                                        thickness: 1,
                                                        height: 1.5,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                _buildDashedLine(),
                                                const SizedBox(height: 4),
                                                // Table header
                                                Row(
                                                  children: const [
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        'Description',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        'Qty',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        'Price',
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        'Amount',
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                _buildDashedLine(),
                                                const SizedBox(height: 4),
                                                // Data row
                                                Row(
                                                  children: [
                                                    const Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        'Room Charge',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                    const Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        '1',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        currencyFormatter
                                                            .format(roomRate),
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        currencyFormatter
                                                            .format(roomCharge),
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Divider(
                                                  color: Colors.grey.shade400,
                                                  thickness: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // — total & buttons (unchanged)
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            16,
                                            12,
                                            16,
                                            16,
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
                                                        const EdgeInsets.only(
                                                          top: 16,
                                                          bottom: 16,
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
                                                    if (_currentStep < 3) {
                                                      setState(() {
                                                        _currentStep++;
                                                      });
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFFFFD700),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            30,
                                                          ),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 16,
                                                          bottom: 16,
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

  Widget _buildDashedLine({double dashWidth = 4, double dashSpacing = 4}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = (constraints.maxWidth / (dashWidth + dashSpacing))
            .floor();
        return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) =>
                Container(width: dashWidth, height: 1, color: Colors.black54),
          ),
        );
      },
    );
  }
}
