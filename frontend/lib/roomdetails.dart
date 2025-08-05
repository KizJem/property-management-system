import 'package:flutter/material.dart';

class RoomDetail {
  final String name;
  final String imageAsset;
  String price;
  String description;
  List<RoomFeature> features;

  RoomDetail({
    required this.name,
    required this.imageAsset,
    required this.price,
    required this.description,
    required this.features,
  });
}

class RoomFeature {
  final IconData icon;
  final String label;

  const RoomFeature({required this.icon, required this.label});
}

final Map<String, RoomDetail> roomDetails = {
  'STANDARD SINGLE ROOMS': RoomDetail(
    name: 'Standard Single Room',
    imageAsset: 'assets/images/standard-single-room.jpg',
    price: '₱ 4,000',
    description:
        'Basic yet functional, the Standard Single Room is perfect for one person.',
    features: const [
      RoomFeature(icon: Icons.bed, label: 'Twin or single bed'),
      RoomFeature(icon: Icons.bathtub, label: 'Private bathroom'),
      RoomFeature(icon: Icons.ac_unit, label: 'Aircon or fan'),
      RoomFeature(icon: Icons.tv, label: 'TV'),
      RoomFeature(icon: Icons.money, label: 'Affordable price'),
      RoomFeature(icon: Icons.person, label: 'Good for 1 person'),
      RoomFeature(icon: Icons.block, label: 'No extra bed allowed'),
      RoomFeature(icon: Icons.cleaning_services, label: 'Basic amenities'),
      RoomFeature(icon: Icons.night_shelter, label: 'Ideal for short stays'),
    ],
  ),

  'SUPERIOR SINGLE ROOMS': RoomDetail(
    name: 'Superior Single Room',
    imageAsset: 'assets/images/superior-single-room.jpg',
    price: '₱ 5,000',
    description:
        'A step above the standard, the Superior Single Room offers upgraded furnishings and better location.',
    features: const [
      RoomFeature(icon: Icons.bed, label: 'Double or queen-size bed'),
      RoomFeature(icon: Icons.bathtub, label: 'Private bathroom'),
      RoomFeature(icon: Icons.chair, label: 'Upgraded furnishings'),
      RoomFeature(icon: Icons.ac_unit, label: 'Air-conditioning'),
      RoomFeature(icon: Icons.tv, label: 'TV'),
      RoomFeature(icon: Icons.person, label: 'Good for 1 person'),
      RoomFeature(icon: Icons.block, label: 'No extra bed allowed'),
      RoomFeature(icon: Icons.upgrade, label: 'Better location'),
      RoomFeature(icon: Icons.night_shelter, label: 'Comfort-focused'),
    ],
  ),

  'STANDARD DOUBLE ROOMS': RoomDetail(
    name: 'Standard Double Room',
    imageAsset: 'assets/images/standard-double-room.jpg',
    price: '₱ 5,000',
    description:
        'Designed for two guests, the Standard Double Room offers essential amenities with either two double beds or one queen-size bed.',
    features: const [
      RoomFeature(icon: Icons.bed, label: '2 double or 1 queen-size bed'),
      RoomFeature(icon: Icons.bathtub, label: 'Private bathroom'),
      RoomFeature(icon: Icons.ac_unit, label: 'Aircon or fan'),
      RoomFeature(icon: Icons.tv, label: 'TV'),
      RoomFeature(icon: Icons.attach_money, label: 'Budget-friendly'),
      RoomFeature(icon: Icons.people, label: 'Good for 2 persons'),
      RoomFeature(icon: Icons.add, label: '1 extra bed allowed'),
      RoomFeature(icon: Icons.cleaning_services, label: 'Basic amenities'),
      RoomFeature(icon: Icons.night_shelter, label: 'Ideal for couples'),
    ],
  ),

  'DELUXE ROOMS': RoomDetail(
    name: 'Deluxe Room',
    imageAsset: 'assets/images/deluxe-room.jpg',
    price: '₱ 6,000',
    description: 'The Deluxe Room offers more space and upgraded interiors.',
    features: const [
      RoomFeature(icon: Icons.king_bed, label: '2 double or 1 queen-size bed'),
      RoomFeature(icon: Icons.bathtub, label: 'Private bathroom'),
      RoomFeature(icon: Icons.ac_unit, label: 'Air-conditioning'),
      RoomFeature(icon: Icons.tv, label: 'Flat-screen TV'),
      RoomFeature(icon: Icons.local_drink, label: 'Minibar'),
      RoomFeature(icon: Icons.people, label: 'Good for 2 persons'),
      RoomFeature(icon: Icons.add, label: '1 extra bed allowed'),
      RoomFeature(icon: Icons.spa, label: 'Luxury toiletries'),
      RoomFeature(icon: Icons.visibility, label: 'Good view'),
    ],
  ),

  'FAMILY ROOMS': RoomDetail(
    name: 'Family Room',
    imageAsset: 'assets/images/family-room.jpg',
    price: '₱ 7,000',
    description:
        'Perfect for families, this room includes multiple beds or bunk beds and a larger space.',
    features: const [
      RoomFeature(icon: Icons.family_restroom, label: 'Good for 5 persons'),
      RoomFeature(icon: Icons.bedroom_child, label: 'Multiple or bunk beds'),
      RoomFeature(icon: Icons.bathtub, label: 'Private bathroom'),
      RoomFeature(icon: Icons.tv, label: 'TV'),
      RoomFeature(icon: Icons.ac_unit, label: 'Air-conditioning'),
      RoomFeature(icon: Icons.child_care, label: 'Child-friendly features'),
      RoomFeature(icon: Icons.room_preferences, label: 'Spacious layout'),
      RoomFeature(icon: Icons.cleaning_services, label: 'Essential amenities'),
      RoomFeature(icon: Icons.night_shelter, label: 'Ideal for families'),
    ],
  ),

  'EXECUTIVE ROOMS': RoomDetail(
    name: 'Executive Room',
    imageAsset: 'assets/images/executive-room.jpg',
    price: '₱ 8,000',
    description:
        'Tailored for professionals, the Executive Room features business-friendly amenities and upgraded room comforts.',
    features: const [
      RoomFeature(icon: Icons.bed, label: 'Queen-size bed'),
      RoomFeature(icon: Icons.bathtub, label: 'Private bathroom'),
      RoomFeature(icon: Icons.ac_unit, label: 'Air-conditioning'),
      RoomFeature(icon: Icons.tv, label: 'Flat-screen TV'),
      RoomFeature(icon: Icons.desk, label: 'Business-friendly desk'),
      RoomFeature(icon: Icons.people, label: 'Good for 2 persons'),
      RoomFeature(icon: Icons.add, label: '1 extra bed allowed'),
      RoomFeature(icon: Icons.workspace_premium, label: 'Executive setup'),
      RoomFeature(icon: Icons.night_shelter, label: 'Upgraded amenities'),
    ],
  ),

  'SUITE ROOMS': RoomDetail(
    name: 'Suite Room',
    imageAsset: 'assets/images/suite-room.jpg',
    price: '₱ 10,000',
    description:
        'The Suite Room features luxury furnishings, a king-size bed, and separate areas for living and sleeping.',
    features: const [
      RoomFeature(icon: Icons.king_bed, label: 'King-size bed'),
      RoomFeature(icon: Icons.living, label: 'Living & sleeping areas'),
      RoomFeature(icon: Icons.kitchen, label: 'Kitchenette or dining area'),
      RoomFeature(icon: Icons.tv, label: 'Luxury furnishings & TV'),
      RoomFeature(icon: Icons.ac_unit, label: 'Air-conditioning'),
      RoomFeature(icon: Icons.people, label: 'Good for 2 persons'),
      RoomFeature(icon: Icons.add, label: '1 extra bed allowed'),
      RoomFeature(icon: Icons.room_service, label: 'Premium experience'),
      RoomFeature(icon: Icons.night_shelter, label: 'Spacious & exclusive'),
    ],
  ),
};
