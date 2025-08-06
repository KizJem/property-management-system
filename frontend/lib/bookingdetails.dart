import 'package:flutter/material.dart';
import 'roomdetails.dart';

class BookingDetails extends StatelessWidget {
  final RoomDetail? detail;
  final String roomNumber;
  final String roomTypeKey;

  const BookingDetails({
    Key? key,
    required this.detail,
    required this.roomNumber,
    required this.roomTypeKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayName = detail?.name ?? roomTypeKey;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: detail != null
                    ? Image.asset(
                        detail!.imageAsset,
                        width: 200,
                        height: 140,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 200,
                        height: 140,
                        color: Colors.grey.shade200,
                        child: const Center(child: Text('No Image')),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$roomNumber – $displayName',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (detail?.description.isNotEmpty == true) ...[
                      const SizedBox(height: 4),
                      Text(
                        detail!.description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                    const SizedBox(height: 8),
                    const Text(
                      'Room Features',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ← This now loops over Strings
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        if (detail != null)
                          for (final feat in detail!.features)
                            SizedBox(
                              width: 180,
                              child: Text(
                                feat,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
