// db/init.js

const db = require('./connection');

const schema = `
CREATE TABLE IF NOT EXISTS pms_user (
  user_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_email TEXT,
  password TEXT,
  name TEXT UNIQUE
);

CREATE TABLE IF NOT EXISTS pms_guest (
  guest_id INTEGER PRIMARY KEY AUTOINCREMENT,
  first_name TEXT,
  last_name TEXT,
  guest_email TEXT
);

CREATE TABLE IF NOT EXISTS pms_room_type (
  room_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  room_category TEXT,
  description TEXT,
  price INTEGER,
  no_guest INTEGER,
  additional_guest_price INTEGER
);

CREATE TABLE IF NOT EXISTS pms_room (
  room_id INTEGER PRIMARY KEY AUTOINCREMENT,
  room_type_id INTEGER,
  room_number TEXT,
  FOREIGN KEY (room_type_id) REFERENCES pms_room_type(room_type_id)
);

CREATE TABLE IF NOT EXISTS pms_booking (
  booking_id INTEGER PRIMARY KEY AUTOINCREMENT,
  guest_id INTEGER,
  room_id INTEGER,
  user_id INTEGER,
  status TEXT,
  check_in DATE,
  check_out DATE,
  no_days INTEGER,
  guest_count INTEGER,
  additional_guest INTEGER,
  special_request TEXT,
  original_bill INTEGER,
  total_bill INTEGER,
  discount INTEGER,
  payment_method TEXT,
  FOREIGN KEY (guest_id) REFERENCES pms_guest(guest_id),
  FOREIGN KEY (room_id) REFERENCES pms_room(room_id),
  FOREIGN KEY (user_id) REFERENCES pms_user(user_id)
);

CREATE TABLE IF NOT EXISTS pms_room_status (
  status_id INTEGER PRIMARY KEY AUTOINCREMENT,
  room_id INTEGER,
  booking_id INTEGER,
  date DATE,
  status TEXT,
  housekeeping_status TEXT,
  FOREIGN KEY (room_id) REFERENCES pms_room(room_id),
  FOREIGN KEY (booking_id) REFERENCES pms_booking(booking_id)
);

CREATE TABLE IF NOT EXISTS pms_history (
  history_id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER,
  user_id INTEGER,
  action TEXT,
  time DATETIME,
  FOREIGN KEY (booking_id) REFERENCES pms_booking(booking_id),
  FOREIGN KEY (user_id) REFERENCES pms_user(user_id)
);
`;

const seed = `
INSERT INTO pms_user (user_email, password, name)
VALUES ('admin@example.com', 'admin', 'Front Desk Admin');

INSERT INTO pms_guest (first_name, last_name, guest_email)
VALUES ('John', 'Doe', 'john.doe@example.com');

INSERT INTO pms_room_type (room_category, description, price, no_guest, additional_guest_price)
VALUES
  ('Single', 'Single room with 1 bed', 1000.00, 1, 200.00),
  ('Double', 'Double room with 2 beds', 1500.00, 2, 300.00);

INSERT INTO pms_room (room_type_id, room_number)
VALUES
  (1, '101'),
  (2, '102'),
  (2, '103');
`;

db.serialize(() => {
  db.exec(schema, (err) => {
    if (err) {
      console.error('❌ Schema initialization failed:', err.message);
    } else {
      console.log('✅ Schema created');

      db.exec(seed, (err) => {
        if (err) {
          console.error('⚠️ Seeding failed (possibly due to duplicates):', err.message);
        } else {
          console.log('✅ Sample data inserted');
        }
      });
    }
  });
});
