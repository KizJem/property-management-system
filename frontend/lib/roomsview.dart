import 'package:flutter/material.dart';

class RoomsView extends StatefulWidget {
  const RoomsView({super.key});

  @override
  State<RoomsView> createState() => _RoomsViewState();
}

class _RoomsViewState extends State<RoomsView> {
  final List<String> roomTypes = [
    'Standard Single Room',
    'Superior Single Room',
    'Standard Double Room',
    'Deluxe Room',
    'Family Room',
    'Executive Room',
    'Suite Room',
  ];

  int selectedRoomTypeIndex = 0;
  final TextEditingController priceController = TextEditingController(
    text: 'Php 4000',
  );
  final TextEditingController descriptionController = TextEditingController(
    text:
        'Basic yet functional, the Standard Single Room is perfect for one person. It includes a single or twin bed, private bathroom, air-conditioning or fan, and basic amenities. This is the most affordable room type and does not allow extra beds.',
  );

  List<TextEditingController> featureControllers = [];

  @override
  void initState() {
    super.initState();
    featureControllers = [
      'Twin or single bed',
      'Good for 1 person',
      'Private bathroom',
      'No extra bed allowed',
      'Aircon or fan',
      'Basic amenities',
      'TV',
      'Ideal for short stays',
      'Affordable price',
      '',
    ].map((text) => TextEditingController(text: text)).toList();
  }

  @override
  void dispose() {
    priceController.dispose();
    descriptionController.dispose();
    for (var controller in featureControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Room type selector
            RoomTypeSelector(
              roomTypes: roomTypes,
              selectedIndex: selectedRoomTypeIndex,
              onSelect: (index) {
                setState(() => selectedRoomTypeIndex = index);
              },
            ),
            const SizedBox(width: 32),

            // Right: Room details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        roomTypes[selectedRoomTypeIndex],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: TextField(
                          controller: priceController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF686461),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF686461),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: descriptionController,
                      maxLines: null,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Enter description...',
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Text(
                    'Room Features',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF686461),
                    ),
                  ),
                  const SizedBox(height: 12),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final boxWidth = (constraints.maxWidth - 20) / 2;
                      final featureHints = [
                        'Twin or single bed',
                        'Good for 1 person',
                        'Private bathroom',
                        'No extra bed allowed',
                        'Aircon or fan',
                        'Basic amenities',
                        'TV',
                        'Ideal for short stays',
                        'Affordable price',
                        'Add Feature',
                      ];

                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(10, (index) {
                          return SizedBox(
                            width: boxWidth,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: featureHints[index],
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 11,
                                  horizontal: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                isDense: true,
                              ),
                              style: const TextStyle(fontSize: 13),
                            ),
                          );
                        }),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Cancel Button
                      OutlinedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(
                            const BorderSide(color: Colors.black),
                          ),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>((
                                states,
                              ) {
                                return states.contains(MaterialState.hovered)
                                    ? const Color(0xFFF0F0F0)
                                    : Colors.transparent;
                              }),
                          foregroundColor: MaterialStateProperty.all(
                            Colors.black,
                          ),
                          textStyle: MaterialStateProperty.all(
                            const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 14,
                            ),
                          ),
                          overlayColor: MaterialStateProperty.all(
                            Colors.transparent,
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),

                      // Save Button
                      ElevatedButton(
                        onPressed: () {
                          // Add save logic here
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>((
                                states,
                              ) {
                                return states.contains(MaterialState.hovered)
                                    ? const Color(0xFFE6C200)
                                    : const Color(0xFFFFD500);
                              }),
                          foregroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          textStyle: MaterialStateProperty.all(
                            const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 14,
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        child: const Text('Save'),
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

// You can put this in a separate file if needed
class RoomTypeSelector extends StatelessWidget {
  final List<String> roomTypes;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const RoomTypeSelector({
    super.key,
    required this.roomTypes,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'ROOM TYPE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF686461),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFF686461), thickness: 1, height: 0),
          ...roomTypes.asMap().entries.expand((entry) {
            final index = entry.key;
            final room = entry.value;
            final isSelected = index == selectedIndex;

            return [
              GestureDetector(
                onTap: () => onSelect(index),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFFD500)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      room,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: isSelected
                            ? Colors.black
                            : const Color(0xFF686461),
                      ),
                    ),
                  ),
                ),
              ),
              if (index != roomTypes.length - 1)
                const Divider(color: Colors.grey, thickness: 1, height: 0),
            ];
          }),
        ],
      ),
    );
  }
}
