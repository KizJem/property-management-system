import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CalendarDashboard extends StatelessWidget {
  final List<String> dates;
  final Map<String, List<String>> rooms;

  const CalendarDashboard({
    super.key,
    required this.dates,
    required this.rooms,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Dashboard'),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          // Date Header Row
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Empty cell for room names column
                  Container(
                    width: 200,
                    alignment: Alignment.center,
                    child: const Text(
                      '', 
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // Date cells
                  ...dates.map((date) => Container(
                    width: 100,
                    alignment: Alignment.center,
                    child: Text(
                      date, 
                      style: const TextStyle(color: Colors.white),
                    ),
                  )),
                ],
              ),
            ),
          ),

          // Room Rows
          Expanded(
            child: ListView(
              children: [
                // STANDARD SINGLE ROOMS
                _buildRoomTypeSection(
                  context,
                  title: 'STANDARD SINGLE ROOMS',
                  rooms: rooms['STANDARD SINGLE ROOMS'] ?? [],
                ),
                
                // SUPERIOR SINGLE ROOMS
                _buildRoomTypeSection(
                  context,
                  title: 'SUPERIOR SINGLE ROOMS',
                  rooms: rooms['SUPERIOR SINGLE ROOMS'] ?? [],
                ),
                
                // STANDARD DOUBLE ROOMS
                _buildRoomTypeSection(
                  context,
                  title: 'STANDARD DOUBLE ROOMS',
                  rooms: rooms['STANDARD DOUBLE ROOMS'] ?? [],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomTypeSection(BuildContext context, {
    required String title,
    required List<String> rooms,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Room type header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Room rows
        ...rooms.map((room) => Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          height: 50,
          child: Row(
            children: [
              // Room name cell
              Container(
                width: 200,
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  room,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // Date cells for this room
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(dates.length, (index) {
                      return Container(
                        width: 100,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: const Text(''),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<String>('dates', dates));
    properties.add(DiagnosticsProperty<Map<String, List<String>>>('rooms', rooms));
  }
}