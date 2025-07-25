// db/init.js

const db = require('./connection');

const schema = `
CREATE TABLE IF NOT EXISTS pms_admin (
  admin_id INTEGER PRIMARY KEY AUTOINCREMENT,
  admin_username TEXT UNIQUE,
  admin_password TEXT,
  name TEXT
);

CREATE TABLE IF NOT EXISTS pms_user (
  user_id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE,
  password TEXT,
  name TEXT
);

CREATE TABLE IF NOT EXISTS pms_guest (
  guest_id INTEGER PRIMARY KEY AUTOINCREMENT,
  gfname TEXT,
  glname TEXT,
  gpnum TEXT,
  gemail TEXT
);

CREATE TABLE IF NOT EXISTS pms_room (
  room_no TEXT PRIMARY KEY,
  room_type TEXT,
  price INTEGER
);

CREATE TABLE IF NOT EXISTS pms_booking (
  booking_id INTEGER PRIMARY KEY AUTOINCREMENT,
  guest_id INTEGER,
  transfer_id INTEGER,
  extend_id INTEGER,
  room_no TEXT,
  status TEXT,
  cidate DATE,
  citime TEXT,
  codate DATE,
  cotime TEXT,
  nodays INTEGER,
  noguest INTEGER,
  spcl_rqst TEXT,
  FOREIGN KEY (guest_id) REFERENCES pms_guest(guest_id),
  FOREIGN KEY (transfer_id) REFERENCES pms_transfer(transfer_id),
  FOREIGN KEY (extend_id) REFERENCES pms_extend(extend_id),
  FOREIGN KEY (room_no) REFERENCES pms_room(room_no)
);

CREATE TABLE IF NOT EXISTS pms_transfer (
  transfer_id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER,
  new_room TEXT,
  FOREIGN KEY (booking_id) REFERENCES pms_booking(booking_id)
);

CREATE TABLE IF NOT EXISTS pms_extend (
  extend_id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER,
  new_date DATE,
  new_cidate DATE,
  new_codate DATE,
  new_nodays INTEGER,
  FOREIGN KEY (booking_id) REFERENCES pms_booking(booking_id)
);

CREATE TABLE IF NOT EXISTS pms_hkstatus (
  hks_id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_no INTEGER,
  room_no TEXT,
  status TEXT,
  fdate DATE,
  ldate DATE,
  FOREIGN KEY (booking_no) REFERENCES pms_booking(booking_id),
  FOREIGN KEY (room_no) REFERENCES pms_room(room_no)
);

CREATE TABLE IF NOT EXISTS pms_grecords (
  grecord_id INTEGER PRIMARY KEY AUTOINCREMENT,
  guest_id INTEGER,
  total_bookings INTEGER,
  most_usedroom TEXT,
  booking_history TEXT,
  FOREIGN KEY (guest_id) REFERENCES pms_guest(guest_id)
);

CREATE TABLE IF NOT EXISTS pms_activitylogs (
  activitylog_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER,
  timein DATETIME,
  timeout DATETIME,
  FOREIGN KEY (user_id) REFERENCES pms_user(user_id)
);

CREATE TABLE IF NOT EXISTS pms_useractivity (
  activity_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER,
  date DATE,
  time TEXT,
  action_type TEXT,
  FOREIGN KEY (user_id) REFERENCES pms_user(user_id)
);

CREATE TABLE IF NOT EXISTS pms_billing (
  billing_id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER,
  date DATE,
  time TEXT,
  quantity INTEGER,
  unit_price INTEGER,
  total INTEGER,
  total_amount_due INTEGER,
  add_charge INTEGER,
  mode_payment TEXT,
  FOREIGN KEY (booking_id) REFERENCES pms_booking(booking_id)
);
`;

const seed = `
INSERT INTO pms_user (user_id, username, password, name)
VALUES (1, 'frontdesk', 'frontdeskpms', 'KC Bongato');

-- Standard Single Room: 100 - 104
INSERT INTO pms_room (room_no, room_type, price) VALUES
('100', 'Standard Single Room', 1500),
('101', 'Standard Single Room', 1500),
('102', 'Standard Single Room', 1500),
('103', 'Standard Single Room', 1500),
('104', 'Standard Single Room', 1500),
('105', 'Superior Single Room', 2800),
('106', 'Superior Single Room', 2800),
('107', 'Superior Single Room', 2800),
('108', 'Superior Single Room', 2800),
('109', 'Superior Single Room', 2800),
('200', 'Standard Double Room', 3000),
('201', 'Standard Double Room', 3000),
('202', 'Standard Double Room', 3000),
('203', 'Standard Double Room', 3000),
('204', 'Standard Double Room', 3000),
('205', 'Deluxe Room', 3800),
('206', 'Deluxe Room', 3800),
('207', 'Deluxe Room', 3800),
('208', 'Deluxe Room', 3800),
('209', 'Deluxe Room', 3800),
('300', 'Family Room', 4200),
('301', 'Family Room', 4200),
('302', 'Family Room', 4200),
('303', 'Family Room', 4200),
('304', 'Executive Room', 4800),
('305', 'Executive Room', 4800),
('306', 'Executive Room', 4800),
('307', 'Executive Room', 4800),
('308', 'Suite Room', 5500),
('309', 'Suite Room', 5500);

INSERT INTO pms_admin (admin_id, admin_username, admin_password, name)
VALUES (1, 'admin', 'adminpms', 'Arggie Roy Busalla');

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
