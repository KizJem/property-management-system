import 'package:flutter/material.dart';
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

class AvailableCellPage extends StatelessWidget {
  final String roomType;

  const AvailableCellPage({super.key, required this.roomType});

  @override
  Widget build(BuildContext context) {
    final details = roomDetails[roomType]!;
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
                            height: 250,
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

              // RIGHT SIDE - UNCHANGED BOOKING FORM
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
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                      margin: const EdgeInsets.symmetric(vertical: 10),
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
                                  decoration: const InputDecoration(
                                    labelText: 'First Name *',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
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
                                  decoration: const InputDecoration(
                                    labelText: 'Phone Number *',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Email (Optional)',
                                  ),
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

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
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
                            onPressed: () {},
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
