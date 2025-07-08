const db = require('./connection');

const schema = `
CREATE DATABASE IF NOT EXISTS pms;
USE pms;

CREATE TABLE IF NOT EXISTS pms_user (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  user_email VARCHAR(100),
  password VARCHAR(100),
  name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS pms_guest (
  guest_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  guest_email VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS pms_room_type (
  room_type_id INT PRIMARY KEY AUTO_INCREMENT,
  room_category VARCHAR(50),
  description TEXT,
  price DECIMAL(10,2),
  no_guest INT,
  additional_guest_price DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS pms_room (
  room_id INT PRIMARY KEY AUTO_INCREMENT,
  room_type_id INT,
  room_number VARCHAR(10),
  FOREIGN KEY (room_type_id) REFERENCES pms_room_type(room_type_id)
);

CREATE TABLE IF NOT EXISTS pms_booking (
  booking_id INT PRIMARY KEY AUTO_INCREMENT,
  guest_id INT,
  room_id INT,
  user_id INT,
  status ENUM('Reserved', 'Occupied', 'Checked-out', 'Cancelled'),
  check_in DATE,
  check_out DATE,
  no_days INT,
  additional_guest INT,
  special_request VARCHAR(250),
  original_bill DECIMAL(10,2),
  total_bill DECIMAL(10,2),
  discount DECIMAL(5,2),
  payment_method ENUM('Cash', 'Card'),
  FOREIGN KEY (guest_id) REFERENCES pms_guest(guest_id),
  FOREIGN KEY (room_id) REFERENCES pms_room(room_id),
  FOREIGN KEY (user_id) REFERENCES pms_user(user_id)
);

CREATE TABLE IF NOT EXISTS pms_room_status (
  status_id INT PRIMARY KEY AUTO_INCREMENT,
  room_id INT,
  booking_id INT NULL,
  date DATE,
  status ENUM('Available', 'Reserved', 'Occupied'),
  housekeeping_status ENUM(
    'Vacant, Clean, Inspected',
    'Vacant, Dirty',
    'Occupied, Clean',
    'Occupied, Dirty',
    'Out of Order',
    'Blocked',
    'House Use'
  ),
  FOREIGN KEY (room_id) REFERENCES pms_room(room_id),
  FOREIGN KEY (booking_id) REFERENCES pms_booking(booking_id)
);

CREATE TABLE IF NOT EXISTS pms_history (
  history_id INT PRIMARY KEY AUTO_INCREMENT,
  booking_id INT NULL,
  user_id INT,
  action ENUM('Check-in', 'Check-out', 'Reservation', 'Cancel', 'Transfer'),
  time DATETIME,
  FOREIGN KEY (booking_id) REFERENCES pms_booking(booking_id),
  FOREIGN KEY (user_id) REFERENCES pms_user(user_id)
);
`;

db.query(schema, (err) => {
  if (err) {
    console.error('Schema initialization failed:', err.message);
    return;
  }
  console.log('PMS schema initialized');

  const seed = `
    USE pms;

    INSERT INTO pms_user (user_id, user_email, password, name)
    VALUES (1, 'admin', 'admin', 'Front Desk Admin')
    ON DUPLICATE KEY UPDATE name = name;

    INSERT INTO pms_guest (guest_id, first_name, last_name, guest_email)
    VALUES (1, 'John', 'Doe', 'john.doe@example.com')
    ON DUPLICATE KEY UPDATE guest_email = guest_email;

    INSERT INTO pms_room_type (room_type_id, room_category, description, price, no_guest, additional_guest_price)
    VALUES
      (1, 'Single', 'Single room with 1 bed', 1000.00, 1, 200.00),
      (2, 'Double', 'Double room with 2 beds', 1500.00, 2, 300.00)
    ON DUPLICATE KEY UPDATE room_category = room_category;

    INSERT INTO pms_room (room_id, room_type_id, room_number)
    VALUES
      (1, 1, '101'),
      (2, 2, '102'),
      (3, 2, '103')
    ON DUPLICATE KEY UPDATE room_number = room_number;
  `;

  db.query(seed, (err) => {
    if (err) {
      console.error('Sample data insert failed:', err.message);
    } else {
      console.log('Sample data inserted');
    }
  });
});