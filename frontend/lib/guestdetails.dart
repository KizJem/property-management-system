// lib/guestdetails.dart

import 'package:flutter/material.dart';

class GuestDetails extends StatefulWidget {
  const GuestDetails({Key? key}) : super(key: key);

  @override
  _GuestDetailsState createState() => _GuestDetailsState();
}

class _GuestDetailsState extends State<GuestDetails> {
  final _leadFirstNameCtrl = TextEditingController();
  final _leadLastNameCtrl = TextEditingController();
  final _leadPhoneCtrl = TextEditingController();
  final _leadEmailCtrl = TextEditingController();

  bool _bookingForSomeoneElse = false;

  final _otherFirstNameCtrl = TextEditingController();
  final _otherLastNameCtrl = TextEditingController();
  final _otherPhoneCtrl = TextEditingController();
  final _otherEmailCtrl = TextEditingController();

  @override
  void dispose() {
    _leadFirstNameCtrl.dispose();
    _leadLastNameCtrl.dispose();
    _leadPhoneCtrl.dispose();
    _leadEmailCtrl.dispose();
    _otherFirstNameCtrl.dispose();
    _otherLastNameCtrl.dispose();
    _otherPhoneCtrl.dispose();
    _otherEmailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lead Guest heading
            const Text(
              'Lead Guest',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Lead Guest name fields
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _leadFirstNameCtrl,
                    label: 'First name',
                    required: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _leadLastNameCtrl,
                    label: 'Last name',
                    required: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Lead Guest contact fields
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _leadPhoneCtrl,
                    label: 'Phone number',
                    required: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _leadEmailCtrl,
                    label: 'Email (optional)',
                    required: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Toggle: booking for someone else
            Row(
              children: [
                Switch(
                  value: _bookingForSomeoneElse,
                  activeColor: const Color(0xFFFFBD00),
                  onChanged: (v) => setState(() {
                    _bookingForSomeoneElse = v;
                  }),
                ),
                const SizedBox(width: 8),
                const Text(
                  'I am booking for someone else',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),

            // Other guest fields (conditionally shown)
            if (_bookingForSomeoneElse) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _otherFirstNameCtrl,
                      label: 'First name',
                      required: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _otherLastNameCtrl,
                      label: 'Last name',
                      required: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _otherPhoneCtrl,
                      label: 'Phone number',
                      required: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _otherEmailCtrl,
                      label: 'Email (optional)',
                      required: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey.shade300, height: 1),
            ],
          ],
        ),
      ),
    );
  }

  /// In lib/guestdetails.dart (inside your _GuestDetailsState class):

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool required,
  }) {
    // common values
    const borderRadius = BorderRadius.all(Radius.circular(4));
    final borderColor = Colors.grey.shade400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // → Separate label row
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            if (required) ...[
              const SizedBox(width: 2),
              const Text(
                '*',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),

        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            border: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
          ),
        ),
      ],
    );
  }
}
