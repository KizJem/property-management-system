// lib/roomdetails.dart

import 'package:flutter/material.dart';
import 'availablecell.dart';

class RoomDetail {
  final String name;
  final String imageAsset;
  final String price;
  final String description;
  final List<RoomFeature> featuresLeft;
  final List<RoomFeature> featuresRight;

  RoomDetail({
    required this.name,
    required this.imageAsset,
    required this.price,
    required this.description,
    required this.featuresLeft,
    required this.featuresRight,
  });
}

final Map<String, RoomDetail> roomDetails = {
  'STANDARD SINGLE ROOMS': RoomDetail(
    name: 'Standard Single Room',
    imageAsset: 'assets/images/single-standard-room.jpg',
    price: '₱ 4,000',
    description:
        'The room offers a comfortable single bed, perfect for solo travelers seeking a restful stay. It comes with a private bathroom, air-conditioning, a flat-screen TV, a work desk, and complimentary Wi-Fi.',
    featuresLeft: const [
      RoomFeature(icon: Icons.bed, label: 'Comfortable single bed'),
      RoomFeature(icon: Icons.bathtub, label: 'Private bathroom'),
      RoomFeature(icon: Icons.ac_unit, label: 'Air-conditioning'),
      RoomFeature(icon: Icons.tv, label: 'Flat-screen TV'),
      RoomFeature(icon: Icons.desk, label: 'Work desk'),
    ],
    featuresRight: const [
      RoomFeature(icon: Icons.wifi, label: 'Complimentary Wi-Fi'),
      RoomFeature(icon: Icons.style, label: 'Minimalist design'),
      RoomFeature(icon: Icons.person, label: 'Ideal for solo travelers'),
      RoomFeature(icon: Icons.night_shelter, label: 'Perfect for short stays'),
    ],
  ),

  'SUPERIOR SINGLE ROOMS': RoomDetail(
    name: 'Superior Single Room',
    imageAsset: 'assets/images/superior-single-room.jpg',
    price: '₱ 5,000',
    description:
        'The room offers a semi-double bed with premium linens, perfect for solo travelers who want added comfort. It includes a private bathroom, air-conditioning, a flat-screen TV, a spacious work desk with a lamp, and complimentary high-speed Wi-Fi.',
    featuresLeft: const [
      RoomFeature(icon: Icons.bed, label: 'Semi-double bed'),
      RoomFeature(icon: Icons.bathtub, label: 'Private bathroom'),
      RoomFeature(icon: Icons.ac_unit, label: 'Air conditioning'),
      RoomFeature(icon: Icons.tv, label: 'Flat-screen TV'),
      RoomFeature(icon: Icons.desk, label: 'Work desk with lamp'),
    ],
    featuresRight: const [
      RoomFeature(icon: Icons.wifi, label: 'High-speed Wi-Fi'),
      RoomFeature(icon: Icons.kitchen, label: 'Basic appliances'),
      RoomFeature(icon: Icons.light_mode, label: 'Warm ambient lighting'),
      RoomFeature(icon: Icons.night_shelter, label: 'Extended stay friendly'),
    ],
  ),

  'STANDARD DOUBLE ROOMS': RoomDetail(
    name: 'Standard Double Room',
    imageAsset: 'assets/images/standard-double-room.jpg',
    price: '₱ 5,000',
    description:
        'The room offers a semi-double bed with premium linens, perfect for solo travelers who want added comfort. It includes a private bathroom, air-conditioning, a flat-screen TV, a spacious work desk with a lamp, and complimentary high-speed Wi-Fi.',
    featuresLeft: const [
      RoomFeature(icon: Icons.bed, label: 'Semi-double bed'),
      RoomFeature(icon: Icons.bathtub, label: 'Private bathroom'),
      RoomFeature(icon: Icons.ac_unit, label: 'Air conditioning'),
      RoomFeature(icon: Icons.tv, label: 'Flat-screen TV'),
      RoomFeature(icon: Icons.desk, label: 'Work desk with lamp'),
    ],
    featuresRight: const [
      RoomFeature(icon: Icons.wifi, label: 'High-speed Wi-Fi'),
      RoomFeature(icon: Icons.kitchen, label: 'Basic appliances'),
      RoomFeature(icon: Icons.light_mode, label: 'Warm ambient lighting'),
      RoomFeature(icon: Icons.night_shelter, label: 'Extended stay friendly'),
    ],
  ),
};
