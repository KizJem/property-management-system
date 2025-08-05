// lib/bookingextras.dart

import 'package:flutter/material.dart';

/// Simple data model for one booked room’s extras
class RoomExtraData {
  final String roomTitle;
  final String guestLabel;
  List<String> items;
  String selectedItem;
  int quantity;
  RoomExtraData({
    required this.roomTitle,
    required this.guestLabel,
    this.items = const ['Room Service Meal'],
    this.selectedItem = 'Room Service Meal',
    this.quantity = 1,
  });
}

class BookingExtras extends StatefulWidget {
  /// Now takes exactly the rooms the user booked
  final List<RoomExtraData> rooms;
  const BookingExtras({Key? key, required this.rooms}) : super(key: key);

  @override
  _BookingExtrasState createState() => _BookingExtrasState();
}

class _BookingExtrasState extends State<BookingExtras> {
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
          children: widget.rooms.map((room) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ─── Header ───
                Text(
                  room.roomTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(room.guestLabel, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 12),

                // ─── Table Header Row ───
                Row(
                  children: const [
                    SizedBox(
                      width: 80,
                      child: Text(
                        'Date & Time',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text(
                        'Item',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        'Qty',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Special Instructions',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 8),

                // ─── Input Row ───
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () {},
                    ),

                    DropdownButton<String>(
                      value: room.selectedItem,
                      items: room.items
                          .map(
                            (it) =>
                                DropdownMenuItem(value: it, child: Text(it)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() {
                        room.selectedItem = v!;
                      }),
                    ),

                    const SizedBox(width: 8),

                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => setState(() {
                        if (room.quantity > 1) room.quantity--;
                      }),
                    ),
                    Text('${room.quantity}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() {
                        room.quantity++;
                      }),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    IconButton(icon: const Icon(Icons.close), onPressed: () {}),
                  ],
                ),

                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Add another booking extra'),
                ),

                const Divider(height: 32),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
