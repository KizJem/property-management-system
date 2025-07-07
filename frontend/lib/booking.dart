import 'package:flutter/material.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // LEFT SIDE
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5), // Top spacing above the image
                    // Room Image Placeholder
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: const Center(child: Text('Room Image')),
                    ),

                    const SizedBox(height: 20),

                    //ROOM DETAILS start
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Standard Single Room',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600, // Medium Bold
                          ),
                        ),
                        Text(
                          '\$250',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold, // Full Bold
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
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('• Comfortable single bed'),
                              Text('• Private bathroom'),
                              Text('• Air-conditioning'),
                              Text('• Flat-screen TV'),
                              Text('• Work desk'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('• Complimentary Wi-Fi'),
                              Text('• Minimalist design'),
                              Text('• Ideal for solo travelers'),
                              Text('• Perfect for short stays'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // ROOM DETAILS end
                  ],
                ),
              ),
            ),

            // STOP HERE
            const SizedBox(width: 30),

            // RIGHT SIDE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date and Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Booking #0000',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          '${now.month}/${now.day}/${now.year} '
                          '${now.hour.toString().padLeft(2, '0')}:'
                          '${now.minute.toString().padLeft(2, '0')} '
                          '${now.hour >= 12 ? 'PM' : 'AM'}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
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
                      border: Border.all(color: Colors.grey.shade300),
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
                      border: Border.all(color: Colors.grey.shade300),
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
                                  DateTime? picked = await showDatePicker(
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
                                  DateTime? picked = await showDatePicker(
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
                                  border:
                                      OutlineInputBorder(), // <-- added this line
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
                                  border:
                                      OutlineInputBorder(), // <-- visible border on all sides
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
                            alignLabelWithHint:
                                true, // <-- This aligns the label to the top-left
                          ),
                          maxLines: 3,
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),

                  //CANCEL & CHECK-IN BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: const Text('Cancel Reservation'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              109,
                              7,
                              92,
                            ),
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: const Text('Check-In Guest'),
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
    );
  }
}
