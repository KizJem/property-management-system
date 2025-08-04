import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'roomdetails.dart';

class RoomsView extends StatefulWidget {
  const RoomsView({super.key});

  @override
  State<RoomsView> createState() => _RoomsViewState();
}

class _RoomsViewState extends State<RoomsView> {
  final List<String> roomKeys = roomDetails.keys.toList();
  int selectedRoomTypeIndex = 0;

  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late ScrollController _descriptionScrollController;
  late List<TextEditingController> featureControllers;

  final ScrollController _mainScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _descriptionScrollController = ScrollController();
    _loadRoomData(selectedRoomTypeIndex);
  }

  void _loadRoomData(int index) {
    final room = roomDetails[roomKeys[index]]!;
    priceController = TextEditingController(
      text: room.price.replaceAll('₱ ', '').replaceAll(',', ''),
    );
    descriptionController = TextEditingController(text: room.description);
    featureControllers = room.features
        .map((f) => TextEditingController(text: f.label))
        .toList();
  }

  @override
  void dispose() {
    priceController.dispose();
    descriptionController.dispose();
    _descriptionScrollController.dispose();
    for (var controller in featureControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final room = roomDetails[roomKeys[selectedRoomTypeIndex]]!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoomTypeSelector(
              roomTypes: roomKeys,
              selectedIndex: selectedRoomTypeIndex,
              onSelect: (index) {
                setState(() {
                  selectedRoomTypeIndex = index;
                  _loadRoomData(index);
                });
              },
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Scrollbar(
                controller: _mainScrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _mainScrollController,
                  padding: const EdgeInsets.only(right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row with title and price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            room.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Text(
                                  'Price',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Color(0xFF686461),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 140,
                                child: TextField(
                                  controller: priceController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [CurrencyInputFormatter()],
                                  decoration: InputDecoration(
                                    prefixText: '₱ ',
                                    prefixStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                      fontSize: 15,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    isDense: true,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
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
                        height: 90,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Scrollbar(
                          controller: _descriptionScrollController,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: _descriptionScrollController,
                            child: TextField(
                              controller: descriptionController,
                              maxLines: null,
                              decoration: const InputDecoration.collapsed(
                                hintText: 'Enter description...',
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
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
                          final spacing = 10.0;
                          final boxWidth = (constraints.maxWidth - spacing) / 2;

                          return Wrap(
                            spacing: spacing,
                            runSpacing: 10,
                            children: featureControllers.map((controller) {
                              return SizedBox(
                                width: boxWidth,
                                child: TextField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    hintText: 'Feature',
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
                            }).toList(),
                          );
                        },
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                                    return states.contains(
                                          MaterialState.hovered,
                                        )
                                        ? const Color(0xFFB00020)
                                        : Colors.transparent;
                                  }),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color>((
                                    states,
                                  ) {
                                    return states.contains(
                                          MaterialState.hovered,
                                        )
                                        ? Colors.white
                                        : Colors.black;
                                  }),
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
                          ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>((
                                    states,
                                  ) {
                                    return states.contains(
                                          MaterialState.hovered,
                                        )
                                        ? const Color(0xFFFFD500)
                                        : Colors.grey;
                                  }),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color>((
                                    states,
                                  ) {
                                    return states.contains(
                                          MaterialState.hovered,
                                        )
                                        ? Colors.white
                                        : Colors.black;
                                  }),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat formatter = NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final formatted = formatter.format(int.parse(digits));
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

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

  String toTitleCase(String input) {
    return input
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 410, // Adjust based on your layout needs
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  'ROOM TYPE',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF686461),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Divider(color: Color(0xFF686461), thickness: 1, height: 3),
              ...roomTypes.asMap().entries.expand((entry) {
                final index = entry.key;
                final room = entry.value;
                final isSelected = index == selectedIndex;

                return [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
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
                            toTitleCase(room),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: isSelected
                                  ? Colors.black
                                  : const Color(0xFF686461),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: Colors.grey, thickness: 1, height: 0),
                ];
              }),
            ],
          ),
        ),
      ),
    );
  }
}
