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

  @override
  void dispose() {
    _refController.dispose();
    _amountController.dispose();
    _dateController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final hoverColor = Colors.black;
    const double indent = 32.0 + 8.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── E-Wallet Section ───
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Radio<PaymentMethod>(
                value: PaymentMethod.ewallet,
                groupValue: _selectedMethod,
                activeColor: Colors.amber,
                onChanged: (val) {
                  setState(() {
                    _selectedMethod = val;
                    // clear any previous e-wallet inputs when selecting E-Wallet
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
            const Padding(
              padding: EdgeInsets.only(left: indent),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select Provider *',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Reference Number *',
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
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Amount/Date labels row
            const Padding(
              padding: EdgeInsets.only(left: indent),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Amount Paid *',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
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
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: _pickDate,
                      decoration: InputDecoration(
                        isDense: true,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: _pickDate,
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
          const SizedBox(height: 12),
          const Divider(thickness: 1, height: 1),

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
          const SizedBox(height: 12),
          const Divider(thickness: 1, height: 1),
        ],
      ),
    );
  }
}
