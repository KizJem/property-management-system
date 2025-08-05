// paymentdetails.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum PaymentMethod { ewallet, card, cash }

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({Key? key}) : super(key: key);

  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
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
    const double indent = 32.0 + 8.0; // radio width + spacing

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
          Padding(
            padding: const EdgeInsets.only(left: indent),
            child: const Text(
              'Pay with GCash or Maya. Collect reference number for proof of payment.',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 12),
          if (_selectedMethod == PaymentMethod.ewallet) ...[
            // Labels row
            Padding(
              padding: const EdgeInsets.only(left: indent),
              child: Row(
                children: const [
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
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedProvider,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'GCash', child: Text('GCash')),
                        DropdownMenuItem(value: 'Maya', child: Text('Maya')),
                      ],
                      onChanged: (v) => setState(() => _selectedProvider = v),
                    ),
                  ),
                  const SizedBox(width: 16),
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
            Padding(
              padding: const EdgeInsets.only(left: indent),
              child: Row(
                children: const [
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
          Padding(
            padding: const EdgeInsets.only(left: indent),
            child: const Text(
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
          Padding(
            padding: const EdgeInsets.only(left: indent),
            child: const Text(
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
