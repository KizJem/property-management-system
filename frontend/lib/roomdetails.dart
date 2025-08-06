class RoomDetail {
  final String name;
  final String imageAsset;
  final String price;
  final String description;
  final List<String> features;

  const RoomDetail({
    required this.name,
    required this.imageAsset,
    required this.price,
    required this.description,
    required this.features,
  });
}

const Map<String, RoomDetail> roomDetails = {
  'STANDARD SINGLE ROOMS': RoomDetail(
    name: 'Standard Single Room',
    imageAsset: 'assets/images/standard-single-room.jpg',
    price: '₱ 4,000',
    description:
        'Basic yet functional, the Standard Single Room is perfect for one person.',
    features: [
      '• Twin or single bed',
      '• Private bathroom',
      '• Aircon or fan',
      '• TV',
      '• Affordable price',
      '• Good for 1 person',
      '• No extra bed allowed',
      '• Basic amenities',
      '• Ideal for short stays',
    ],
  ),
  'SUPERIOR SINGLE ROOMS': RoomDetail(
    name: 'Superior Single Room',
    imageAsset: 'assets/images/superior-single-room.jpg',
    price: '₱ 5,000',
    description:
        'A step above the standard, the Superior Single Room offers upgraded furnishings and better location.',
    features: [
      '• Double or queen-size bed',
      '• Private bathroom',
      '• Upgraded furnishings',
      '• Air-conditioning',
      '• TV',
      '• Good for 1 person',
      '• No extra bed allowed',
      '• Better location',
      '• Comfort-focused',
    ],
  ),
  'STANDARD DOUBLE ROOMS': RoomDetail(
    name: 'Standard Double Room',
    imageAsset: 'assets/images/standard-double-room.jpg',
    price: '₱ 5,000',
    description:
        'Designed for two guests, the Standard Double Room offers essential amenities with either two double beds or one queen-size bed.',
    features: [
      '• 2 double or 1 queen-size bed',
      '• Private bathroom',
      '• Aircon or fan',
      '• TV',
      '• Budget-friendly',
      '• Good for 2 persons',
      '• 1 extra bed allowed',
      '• Basic amenities',
      '• Ideal for couples',
    ],
  ),
  'DELUXE ROOMS': RoomDetail(
    name: 'Deluxe Room',
    imageAsset: 'assets/images/deluxe-room.jpg',
    price: '₱ 6,000',
    description: 'The Deluxe Room offers more space and upgraded interiors.',
    features: [
      '• 2 double or 1 queen-size bed',
      '• Private bathroom',
      '• Air-conditioning',
      '• Flat-screen TV',
      '• Minibar',
      '• Good for 2 persons',
      '• 1 extra bed allowed',
      '• Luxury toiletries',
      '• Good view',
    ],
  ),
  'FAMILY ROOMS': RoomDetail(
    name: 'Family Room',
    imageAsset: 'assets/images/family-room.jpg',
    price: '₱ 7,000',
    description:
        'Perfect for families, this room includes multiple beds or bunk beds and a larger space.',
    features: [
      '• Good for 5 persons',
      '• Multiple or bunk beds',
      '• Private bathroom',
      '• TV',
      '• Air-conditioning',
      '• Child-friendly features',
      '• Spacious layout',
      '• Essential amenities',
      '• Ideal for families',
    ],
  ),
  'EXECUTIVE ROOMS': RoomDetail(
    name: 'Executive Room',
    imageAsset: 'assets/images/executive-room.jpg',
    price: '₱ 8,000',
    description:
        'Tailored for professionals, the Executive Room features business-friendly amenities and upgraded room comforts.',
    features: [
      '• Queen-size bed',
      '• Private bathroom',
      '• Air-conditioning',
      '• Flat-screen TV',
      '• Business-friendly desk',
      '• Good for 2 persons',
      '• 1 extra bed allowed',
      '• Executive setup',
      '• Upgraded amenities',
    ],
  ),
  'SUITE ROOMS': RoomDetail(
    name: 'Suite Room',
    imageAsset: 'assets/images/suite-room.jpg',
    price: '₱ 10,000',
    description:
        'The Suite Room features luxury furnishings, a king-size bed, and separate areas for living and sleeping.',
    features: [
      '• King-size bed',
      '• Living & sleeping areas',
      '• Kitchenette or dining area',
      '• Luxury furnishings & TV',
      '• Air-conditioning',
      '• Good for 2 persons',
      '• 1 extra bed allowed',
      '• Premium experience',
      '• Spacious & exclusive',
    ],
  ),
};
