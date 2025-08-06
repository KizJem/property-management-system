import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum PaymentMethod { ewallet, card, cash }

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({Key? key}) : super(key: key);

  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  bool _isProviderHovered = false;
  PaymentMethod? _selectedMethod;
  String? _selectedProvider;

  final TextEditingController _refController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  final TextEditingController _changeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // default today’s date
    _dateController.text = DateFormat('dd MMM yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    _refController.dispose();
    _amountController.dispose();
    _dateController.dispose();

    _cardNameController.dispose();
    _expiryController.dispose();
    _cardNumberController.dispose();
    _cvvController.dispose();

    _changeController.dispose();

    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _dateController.text = DateFormat('dd MMM yyyy').format(picked);
    }
  }

  Widget _requiredLabel(String text) {
    return Text.rich(
      TextSpan(
        text: '$text ',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        children: [
          const TextSpan(
            text: '*',
            style: TextStyle(color: Color(0xFFD10E0E)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double indent = 32.0 + 8.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── E-Wallet Section ───
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio<PaymentMethod>(
                value: PaymentMethod.ewallet,
                groupValue: _selectedMethod,
                activeColor: Colors.amber,
                onChanged: (val) {
                  setState(() {
                    _selectedMethod = val;
                    _selectedProvider = null;
                    _refController.clear();
                    _amountController.clear();
                    // auto-fill today’s date here too
                    _dateController.text = DateFormat(
                      'dd MMM yyyy',
                    ).format(DateTime.now());
                  });
                },
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Pay with E-Wallet',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: indent),
            child: Text(
              'Pay with GCash or Maya. Collect reference number for proof of payment.',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 12),
          if (_selectedMethod == PaymentMethod.ewallet) ...[
            // Labels row
            Padding(
              padding: EdgeInsets.only(left: indent),
              child: Row(
                children: [
                  Expanded(child: _requiredLabel('Select Provider')),
                  SizedBox(width: 16),
                  Expanded(child: _requiredLabel('Reference Number')),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // Fields row
            Padding(
              padding: const EdgeInsets.only(left: indent),
              child: Row(
                children: [
                  // ── Provider dropdown ──
                  Expanded(
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _isProviderHovered = true),
                      onExit: (_) => setState(() => _isProviderHovered = false),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          items: [
                            DropdownMenuItem(
                              value: 'GCash',
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/gcash.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'GCash',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'Maya',
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/maya.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Maya',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          value: _selectedProvider,
                          onChanged: (v) =>
                              setState(() => _selectedProvider = v),
                          buttonStyleData: ButtonStyleData(
                            height: 40,
                            padding: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _isProviderHovered
                                    ? Colors.black
                                    : Colors.black45,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200.0,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // ── Reference number field ──
                  Expanded(
                    child: TextFormField(
                      controller: _refController,
                      decoration: const InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Amount/Date labels row
            Padding(
              padding: EdgeInsets.only(left: indent),
              child: Row(
                children: [
                  Expanded(child: _requiredLabel('Amount Paid')),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Date Paid',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // Amount/Date fields row
            Padding(
              padding: const EdgeInsets.only(left: indent),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true, // ← enable fill
                        fillColor: Colors.grey.shade200,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          const Divider(thickness: 1, height: 1),
          const SizedBox(height: 10),

          // ─── Card Section ───
          Row(
            children: [
              Radio<PaymentMethod>(
                value: PaymentMethod.card,
                groupValue: _selectedMethod,
                activeColor: Colors.amber,
                onChanged: (val) {
                  setState(() {
                    _selectedMethod = val;
                    // clear e-wallet inputs when leaving
                    _selectedProvider = null;
                    _refController.clear();
                    _amountController.clear();
                    _dateController.clear();
                  });
                },
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Pay with Debit or Credit Card',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: indent),
            child: Text(
              'Process payment using card. Enter card details.',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 16),

          if (_selectedMethod == PaymentMethod.card) ...[
            Padding(
              padding: EdgeInsets.only(left: indent),
              child: Row(
                children: [
                  Expanded(child: _requiredLabel('Full Name on Card')),
                  SizedBox(width: 16),
                  Expanded(child: _requiredLabel('Expiry')),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // Row 1 fields
            Padding(
              padding: const EdgeInsets.only(left: indent),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cardNameController,
                      decoration: const InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: 'MM/YY',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Row 2 labels
            Padding(
              padding: EdgeInsets.only(left: indent),
              child: Row(
                children: [
                  Expanded(child: _requiredLabel('Card Number')),
                  SizedBox(width: 16),
                  Expanded(child: _requiredLabel('CVC/CVV')),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // Row 2 fields
            Padding(
              padding: const EdgeInsets.only(left: indent),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          const Divider(thickness: 1, height: 1),
          const SizedBox(height: 10),
          // ─── Cash Section ───
          Row(
            children: [
              Radio<PaymentMethod>(
                value: PaymentMethod.cash,
                groupValue: _selectedMethod,
                activeColor: Colors.amber,
                onChanged: (val) {
                  setState(() {
                    _selectedMethod = val;
                    _selectedProvider = null;
                    _refController.clear();
                    _amountController.clear();
                    _changeController.clear();
                    // auto-fill today’s date:
                    _dateController.text = DateFormat(
                      'dd MMM yyyy',
                    ).format(DateTime.now());
                  });
                },
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Pay with Cash',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: indent),
            child: Text(
              'Collect cash payment. Enter amount received and give change if needed.',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedMethod == PaymentMethod.cash) ...[
            // ── Labels ──
            Padding(
              padding: EdgeInsets.only(left: indent),
              child: Row(
                children: [
                  Expanded(child: _requiredLabel('Amount Received')),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Change Given',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // ── Fields ──
            Padding(
              padding: const EdgeInsets.only(left: indent),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _changeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // ── Date Paid ──
            const Padding(
              padding: EdgeInsets.only(left: indent),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date Paid',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(),
                  ), // placeholder to match second column
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: indent),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true, // ← enable fill
                        fillColor: Colors.grey.shade200,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          const Divider(thickness: 1, height: 1),
        ],
      ),
    );
  }
}
