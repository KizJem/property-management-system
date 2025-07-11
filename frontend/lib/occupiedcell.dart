import 'package:flutter/material.dart';
// import 'calendardashboard.dart';
import 'billingform.dart';

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

class OccupiedCellPage extends StatelessWidget {
  const OccupiedCellPage({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Scaffold(
      body: Container(
        color: const Color(0xFFFFF1AB),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // LEFT SIDE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
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

                    // Room details inside border
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xFFFEA525)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Container(
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              child: Image.asset(
                                'assets/images/single-standard-room-1.jpg',
                                width: double.infinity,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Standard Single Room',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '\₱ 4,000',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'The room offers a comfortable single bed, perfect for solo travelers seeking a restful stay. It comes with a private bathroom, air-conditioning, a flat-screen TV, a work desk, and complimentary Wi-Fi.',
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Room Features',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RoomFeature(
                                      icon: Icons.bed,
                                      label: 'Comfortable single bed',
                                    ),
                                    RoomFeature(
                                      icon: Icons.bathtub,
                                      label: 'Private bathroom',
                                    ),
                                    RoomFeature(
                                      icon: Icons.ac_unit,
                                      label: 'Air-conditioning',
                                    ),
                                    RoomFeature(
                                      icon: Icons.tv,
                                      label: 'Flat-screen TV',
                                    ),
                                    RoomFeature(
                                      icon: Icons.desk,
                                      label: 'Work desk',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              const SizedBox(height: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RoomFeature(
                                      icon: Icons.wifi,
                                      label: 'Complimentary Wi-Fi',
                                    ),
                                    RoomFeature(
                                      icon: Icons.style,
                                      label: 'Minimalist design',
                                    ),
                                    RoomFeature(
                                      icon: Icons.person,
                                      label: 'Ideal for solo travelers',
                                    ),
                                    RoomFeature(
                                      icon: Icons.night_shelter,
                                      label: 'Perfect for short stays',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // RIGHT SIDE
              const SizedBox(width: 20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date and Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Booking #0000',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Booking TimeStamp:',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                '${now.month}/${now.day}/${now.year} '
                                '${now.hour.toString().padLeft(2, '0')}:'
                                '${now.minute.toString().padLeft(2, '0')} '
                                '${now.hour >= 12 ? 'PM' : 'AM'}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // CONTACT DETAILS
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
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
                                'Contact Details',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.edit, size: 16),
                                    SizedBox(width: 5),
                                    Text('Edit Information'),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'First Name *',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Last Name *',
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number *',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Email (Optional)',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    // BOOKING DETAILS
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      margin: const EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xFFFEA525)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Check-in Date',
                                    hintText: 'MM/DD/YYYY',
                                  ),
                                  keyboardType: TextInputType.datetime,
                                  onTap: () async {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(FocusNode());
                                    await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2030),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(width: 5),

                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Check-out Date',
                                    hintText: 'MM/DD/YYYY',
                                  ),
                                  keyboardType: TextInputType.datetime,
                                  onTap: () async {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(FocusNode());
                                    await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now().add(
                                        const Duration(days: 1),
                                      ),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2030),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText: 'Room Number',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Room 101',
                                      child: Text('Room 101'),
                                    ),
                                  ],
                                  onChanged: (value) {},
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  decoration: const InputDecoration(
                                    labelText: 'No. of Guest',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: List.generate(
                                    5,
                                    (index) => DropdownMenuItem(
                                      value: index + 1,
                                      child: Text('${index + 1}'),
                                    ),
                                  ),
                                  onChanged: (value) {},
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

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

                    // EXTEND STAY & GENERATE BILL BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _showExtendStayDialog(context);
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                255,
                                255,
                                255,
                              ),
                              foregroundColor: const Color.fromARGB(
                                255,
                                15,
                                15,
                                15,
                              ),
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Extend Stay'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BillingForm(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFFDD41A),
                              foregroundColor: const Color.fromARGB(
                                255,
                                15,
                                15,
                                15,
                              ),
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Generate Bill'),
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

  // EXTEND STAY DIALOG
  void _showExtendStayDialog(BuildContext context) async {
    DateTime selectedDate = DateTime(2025, 6, 9);
    final TextEditingController dateController = TextEditingController(
      text: "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}",
    );

    String currentStay = '6/5/2025 - 6/6/2025';
    String roomNumber = 'Room 101';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFF6EDF9),

              // 🔽 Remove default paddings so we can fully control layout
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              insetPadding: const EdgeInsets.all(
                40,
              ), // Controls the dialog's outer size

              content: SizedBox(
                width: 600,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    50,
                    50,
                    50,
                    50,
                  ), // Uniform inner padding
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔽 Booking title (moved here to align with content)
                      // Booking title (aligned top)
                      const Text(
                        'Booking #0000',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 25,
                        ),
                      ),

                      // No spacing in between
                      const Text(
                        'Extend Stay',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.w600, // ✅ Valid bold-ish weight
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Current stay and room number
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Current Stay',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(currentStay),
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
                                  'Room Number',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(roomNumber),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // New departure date
                      const Text(
                        'New Departure Date',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2025, 6, 6),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                              dateController.text =
                                  "${picked.month}/${picked.day}/${picked.year}";
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: dateController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Conflict warning
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF4FE),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.info_outline, color: Colors.blue),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Conflict detected: Room 101 is already booked starting June 9, 2025. '
                                'Please manually reassign the upcoming reservation to accommodate the guest\'s extended stay.',
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 🔽 Aligned buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {
                                // TODO: Handle extend logic here
                                Navigator.of(context).pop();
                              },
                              child: const Text('Confirm Extend'),
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
      },
    );
  }
}
