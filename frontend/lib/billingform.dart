import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillingForm extends StatefulWidget {
  const BillingForm({super.key});

  @override
  State<BillingForm> createState() => _BillingFormState();
}

double _tipAmount = 0.0;

class _BillingFormState extends State<BillingForm> {
  final List<Map<String, dynamic>> _charges = [
    {'description': 'Room Rate (per night)', 'quantity': 2, 'unitPrice': 3000},
    {'description': 'Taxes and Fees (10%)', 'quantity': 1, 'unitPrice': 600},
  ];

  final currencyFormatter = NumberFormat('#,##0', 'en_US');

  void _showAddChargeDialog() {
    final TextEditingController descController = TextEditingController();
    final TextEditingController qtyController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    int totalCharge = 0;

    String? descError;
    String? qtyError;
    String? priceError;

    void computeTotal() {
      final int qty = int.tryParse(qtyController.text) ?? 0;
      final int price = int.tryParse(priceController.text) ?? 0;
      totalCharge = qty * price;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Add Charge',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: descController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter description',
                      border: const OutlineInputBorder(),
                      errorText: descError,
                    ),
                    onChanged: (_) {
                      setModalState(() => descError = null);
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: qtyController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            hintText: 'Enter quantity',
                            border: const OutlineInputBorder(),
                            errorText: qtyError,
                          ),
                          onChanged: (_) {
                            setModalState(() {
                              computeTotal();
                              qtyError = null;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Unit Price',
                            hintText: 'Enter unit price',
                            border: const OutlineInputBorder(),
                            errorText: priceError,
                          ),
                          onChanged: (_) {
                            setModalState(() {
                              computeTotal();
                              priceError = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Total Additional Charge (₱): ${NumberFormat('#,##0').format(totalCharge)}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: const BorderSide(color: Colors.black),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final desc = descController.text.trim();
                            final int? qty = int.tryParse(
                              qtyController.text.trim(),
                            );
                            final int? price = int.tryParse(
                              priceController.text.trim(),
                            );

                            setModalState(() {
                              descError = desc.isEmpty ? 'Required' : null;
                              qtyError = (qty == null || qty <= 0)
                                  ? 'Invalid Quantity'
                                  : null;
                              priceError = (price == null || price <= 0)
                                  ? 'Invalid Unit Price'
                                  : null;
                            });

                            final isValid =
                                descError == null &&
                                qtyError == null &&
                                priceError == null;
                            if (!isValid) return;

                            setState(() {
                              _charges.add({
                                'description': desc,
                                'quantity': qty!,
                                'unitPrice': price!,
                              });
                            });

                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Add to Bill',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddTipDialog() {
    final TextEditingController tipController = TextEditingController(
      text: _tipAmount > 0 ? _tipAmount.toStringAsFixed(0) : '',
    );
    double localTip = _tipAmount;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Add Tip for Staff',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 4), // reduce space here
                  Text(
                    "100% of the tips go to the staff. We don’t deduct anything from it.",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input Tip Amount Label
                  const Text(
                    'Input Tip Amount',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: tipController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '₱0.00',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0;
                      setModalState(() {
                        localTip = parsed;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // Tip Preview
                  Text(
                    'Total Tip: ₱ ${NumberFormat('#,##0.00').format(localTip)}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
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
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final entered = tipController.text.trim();
                          final double? tipValue = double.tryParse(entered);
                          if (tipValue != null) {
                            setState(() {
                              _tipAmount = tipValue;

                              // Remove existing tip if any
                              _charges.removeWhere(
                                (charge) =>
                                    charge['description'] == 'Staff Tip',
                              );

                              // If new tip is greater than 0, add it back
                              if (tipValue > 0) {
                                _charges.add({
                                  'description': 'Staff Tip',
                                  'quantity': 1,
                                  'unitPrice': tipValue,
                                });
                              }
                            });
                          }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFBD00),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCheckoutConfirmationDialog() {
    double total = _charges.fold(
      0.0,
      (sum, item) =>
          sum +
          ((item['quantity'] as num) * (item['unitPrice'] as num)).toDouble(),
    );

    final currencyFormatter = NumberFormat('#,##0', 'en_US');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Confirm this check-out?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),

                // Guest Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRow(Icons.person, 'Guest Name:', 'Juan dela Cruz'),
                      _buildRow(
                        Icons.calendar_today,
                        'Arrival and Departure Dates:',
                        'June 5–6, 2025',
                        boldValue: true,
                      ),
                      _buildRow(Icons.people, 'No. of Guests:', '1'),
                      _buildRow(
                        Icons.attach_money,
                        'Total Amount Paid:',
                        currencyFormatter.format(total),
                        boldValue: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Proceed with PDF/export or navigate to Calendar
                          Navigator.pushReplacementNamed(
                            context,
                            '/calendar',
                            arguments: {'updateRoom': '101', 'newStatus': 'VD'},
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
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
      ),
    );
  }

  Widget _buildRow(
    IconData icon,
    String label,
    String value, {
    bool boldValue = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '$label ',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontWeight: boldValue ? FontWeight.bold : FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Quantity',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Unit Price (₱)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Total (₱)',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = _charges.fold(
      0,
      (sum, item) => sum + (item['quantity'] * item['unitPrice']),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFCF8EE),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Billing #0000',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 50,
                  right: 50,
                  bottom: 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Billing Details',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              'Billing Timestamp:',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              'MMM DD, YYYY - 00:00 AM',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text.rich(
                      TextSpan(
                        text: 'Date of Issue: ',
                        style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                        children: [
                          TextSpan(
                            text: 'June 9, 2025',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Client Information',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 12),
                              Text.rich(
                                TextSpan(
                                  text: 'First Name: ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Juan',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Last Name: ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Dela Cruz',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Phone Number: ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '09774567453',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Booking Details',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text.rich(
                                TextSpan(
                                  text: 'Arrival & Departure Date: ',
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: 'June 5, 2025 - June 8, 2025',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Text.rich(
                                TextSpan(
                                  text: 'Room: ',
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: 'Standard Room Single - No. 101',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Text.rich(
                                TextSpan(
                                  text: 'No. of Guests: ',
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: '1',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 140,
                                        child: ElevatedButton.icon(
                                          onPressed: _showAddChargeDialog,
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                            color: Color(0xFF9B000A),
                                          ),
                                          label: const Text(
                                            'Add Charge',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFFFFBD00,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      SizedBox(
                                        width: 140,
                                        child: ElevatedButton.icon(
                                          onPressed: _showAddTipDialog,
                                          icon: const Icon(
                                            Icons.volunteer_activism_outlined,
                                            color: Color(0xFF9B000A),
                                          ),
                                          label: const Text(
                                            'Add Tip',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFFFFBD00,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // const Divider(thickness: 1),
                    _buildTableHeader(),
                    const Divider(thickness: 1, height: 0),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: _charges.map((charge) {
                            final qty = charge['quantity'];
                            final price = charge['unitPrice'];
                            final totalRow = qty * price;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(charge['description']),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '$qty',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${currencyFormatter.format(price)}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      ' ${currencyFormatter.format(totalRow)}',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        const Divider(thickness: 1, height: 0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Amount Due',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                '₱ ${currencyFormatter.format(total)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
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
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(250, 40),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _showCheckoutConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(250, 40),
                      backgroundColor: const Color(0xFFFFBD00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                    ),
                    child: const Text(
                      'Check-out',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
