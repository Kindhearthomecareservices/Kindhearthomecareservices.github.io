-- KindHeart Homecare - Full Schema V2
-- SpO2 range 89-100% as requested

CREATE TABLE IF NOT EXISTS patients (
 id TEXT PRIMARY KEY,
 full_name TEXT NOT NULL,
 phone TEXT,
 location TEXT,
 allergies TEXT,
 diagnosis TEXT,
 baseline_bp TEXT DEFAULT '120/80',
 baseline_temp REAL DEFAULT 36.5,
 baseline_spo2 INT DEFAULT 96,
 baseline_hr INT DEFAULT 80,
 care_started_date DATE DEFAULT CURRENT_DATE,
 status TEXT DEFAULT 'Active',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS staff (
 id TEXT PRIMARY KEY,
 full_name TEXT NOT NULL,
 role TEXT NOT NULL CHECK(role IN ('Nurse','Caregiver')),
 phone TEXT,
 status TEXT DEFAULT 'Active'
);

CREATE TABLE IF NOT EXISTS assignments (
 id TEXT PRIMARY KEY,
 patient_id TEXT REFERENCES patients(id),
 staff_id TEXT REFERENCES staff(id),
 assigned_date DATE DEFAULT CURRENT_DATE,
 status TEXT DEFAULT 'Active'
);

-- TREATMENT SHEET AUTOMATED
CREATE TABLE IF NOT EXISTS treatment_sheet (
 id TEXT PRIMARY KEY,
 patient_id TEXT REFERENCES patients(id),
 drug_name TEXT NOT NULL,
 dosage TEXT NOT NULL, -- e.g. TDS, BD, OD
 notes TEXT, -- Give with meals
 total_qty INT NOT NULL,
 remaining_qty INT NOT NULL,
 start_date DATE NOT NULL,
 duration_days INT NOT NULL,
 end_date DATE GENERATED ALWAYS AS (date(start_date, '+' || duration_days || ' days')) STORED,
 created_by TEXT,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- VITALS WITH ABNORMAL DETECTION
CREATE TABLE IF NOT EXISTS vitals (
 id TEXT PRIMARY KEY,
 patient_id TEXT REFERENCES patients(id),
 staff_id TEXT REFERENCES staff(id),
 bp TEXT, -- 120/80
 temp REAL,
 spo2 INT CHECK(spo2 BETWEEN 50 AND 100),
 hr INT,
 notes TEXT,
 status TEXT, -- Normal, Abnormal High, Abnormal Low
 is_abnormal BOOLEAN DEFAULT 0,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- NURSING NOTES / CARE NOTES - Variable per patient
CREATE TABLE IF NOT EXISTS care_notes (
 id TEXT PRIMARY KEY,
 patient_id TEXT REFERENCES patients(id),
 staff_id TEXT REFERENCES staff(id),
 staff_role TEXT,
 note_type TEXT CHECK(note_type IN ('Nursing Notes','Care Notes')),
 content TEXT NOT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CONSUMABLES WITH STOCK STATUS
CREATE TABLE IF NOT EXISTS inventory (
 id TEXT PRIMARY KEY,
 patient_id TEXT REFERENCES patients(id),
 item_name TEXT NOT NULL,
 total_stock INT DEFAULT 0,
 used_today INT DEFAULT 0,
 remaining INT DEFAULT 0,
 stock_status TEXT CHECK(stock_status IN ('In Stock','About to Deplete','Needs Restock','OUT OF STOCK')),
 added_by TEXT,
 notes TEXT,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- MEDICATIONS GIVEN LOG
CREATE TABLE IF NOT EXISTS meds_given (
 id TEXT PRIMARY KEY,
 treatment_id TEXT REFERENCES treatment_sheet(id),
 patient_id TEXT,
 staff_id TEXT,
 qty_given INT,
 remaining_after INT,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DOCTOR APPOINTMENTS
CREATE TABLE IF NOT EXISTS appointments (
 id TEXT PRIMARY KEY,
 patient_id TEXT REFERENCES patients(id),
 staff_id TEXT REFERENCES staff(id),
 appointment_date DATE NOT NULL,
 appointment_time TEXT,
 hospital TEXT,
 doctor_name TEXT,
 purpose TEXT,
 status TEXT DEFAULT 'Upcoming',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DAILY REPORTS
CREATE TABLE IF NOT EXISTS reports (
 id TEXT PRIMARY KEY,
 patient_id TEXT REFERENCES patients(id),
 staff_id TEXT REFERENCES staff(id),
 content TEXT NOT NULL,
 flag_alert BOOLEAN DEFAULT 0,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seed
INSERT OR IGNORE INTO patients(id, full_name, location, allergies, diagnosis) VALUES ('KHA5577','Mama Jane','Eldoret','Protein','Flu');
INSERT OR IGNORE INTO staff(id, full_name, role) VALUES ('STF001','Jackie','Nurse'),('STF002','Mercy','Caregiver');
