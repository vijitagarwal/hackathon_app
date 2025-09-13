/*
  # Initial Database Schema for Holistic University Platform

  1. New Tables
    - `users` - User profiles with role-based access
    - `resources` - Educational resources and files
    - `assignments` - Teacher assignments
    - `assignment_submissions` - Student assignment submissions
    - `leave_applications` - Student leave requests
    - `meal_menus` - Daily meal menus
    - `meal_bookings` - Student meal bookings
    - `events` - Campus events
    - `event_registrations` - Event registrations
    - `chat_messages` - AI assistant chat history
    - `attendance` - Student attendance records
    - `grievances` - Student grievances and complaints

  2. Security
    - Enable RLS on all tables
    - Add policies for role-based access control
    - Secure file uploads and access

  3. Indexes
    - Performance indexes on frequently queried columns
    - Full-text search indexes where applicable
*/

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Users table (extends Supabase auth.users)
CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email text UNIQUE NOT NULL,
  full_name text NOT NULL,
  role text NOT NULL CHECK (role IN ('student', 'teacher', 'warden', 'vendor', 'admin')),
  avatar_url text,
  student_id text,
  teacher_id text,
  department text,
  year integer,
  subjects text[],
  hostel_room text,
  phone text,
  address text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Resources table
CREATE TABLE IF NOT EXISTS resources (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  file_url text NOT NULL,
  file_type text NOT NULL,
  file_size bigint NOT NULL,
  uploaded_by uuid REFERENCES users(id) ON DELETE CASCADE,
  ai_summary text,
  tags text[] DEFAULT '{}',
  department text,
  subject text,
  is_public boolean DEFAULT false,
  download_count integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Assignments table
CREATE TABLE IF NOT EXISTS assignments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text NOT NULL,
  due_date timestamptz NOT NULL,
  created_by uuid REFERENCES users(id) ON DELETE CASCADE,
  max_marks integer DEFAULT 100,
  subject text NOT NULL,
  department text NOT NULL,
  attachments text[] DEFAULT '{}',
  instructions text,
  submission_type text DEFAULT 'file' CHECK (submission_type IN ('file', 'text', 'both')),
  is_published boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Assignment submissions table
CREATE TABLE IF NOT EXISTS assignment_submissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  assignment_id uuid REFERENCES assignments(id) ON DELETE CASCADE,
  student_id uuid REFERENCES users(id) ON DELETE CASCADE,
  file_url text,
  submission_text text,
  submitted_at timestamptz DEFAULT now(),
  marks integer,
  feedback text,
  graded_by uuid REFERENCES users(id),
  graded_at timestamptz,
  status text DEFAULT 'submitted' CHECK (status IN ('draft', 'submitted', 'graded', 'returned')),
  UNIQUE(assignment_id, student_id)
);

-- Leave applications table
CREATE TABLE IF NOT EXISTS leave_applications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid REFERENCES users(id) ON DELETE CASCADE,
  reason text NOT NULL,
  from_date date NOT NULL,
  to_date date NOT NULL,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  applied_at timestamptz DEFAULT now(),
  reviewed_by uuid REFERENCES users(id),
  reviewed_at timestamptz,
  comments text,
  emergency_contact text,
  parent_approval boolean DEFAULT false
);

-- Meal menus table
CREATE TABLE IF NOT EXISTS meal_menus (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  date date NOT NULL,
  meal_type text NOT NULL CHECK (meal_type IN ('breakfast', 'lunch', 'dinner')),
  items text[] NOT NULL,
  price decimal(10,2) NOT NULL DEFAULT 0.00,
  available boolean DEFAULT true,
  created_by uuid REFERENCES users(id) ON DELETE CASCADE,
  special_notes text,
  nutritional_info jsonb,
  created_at timestamptz DEFAULT now(),
  UNIQUE(date, meal_type)
);

-- Meal bookings table
CREATE TABLE IF NOT EXISTS meal_bookings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid REFERENCES users(id) ON DELETE CASCADE,
  menu_id uuid REFERENCES meal_menus(id) ON DELETE CASCADE,
  booking_date date NOT NULL,
  meal_type text NOT NULL CHECK (meal_type IN ('breakfast', 'lunch', 'dinner')),
  status text DEFAULT 'booked' CHECK (status IN ('booked', 'cancelled')),
  payment_status text DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'refunded')),
  created_at timestamptz DEFAULT now(),
  cancelled_at timestamptz,
  cancellation_reason text,
  UNIQUE(student_id, booking_date, meal_type)
);

-- Events table
CREATE TABLE IF NOT EXISTS events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text NOT NULL,
  event_date timestamptz NOT NULL,
  location text NOT NULL,
  max_participants integer,
  created_by uuid REFERENCES users(id) ON DELETE CASCADE,
  status text DEFAULT 'draft' CHECK (status IN ('draft', 'pending', 'approved', 'rejected', 'cancelled')),
  approved_by uuid REFERENCES users(id),
  approved_at timestamptz,
  category text DEFAULT 'general' CHECK (category IN ('academic', 'cultural', 'sports', 'technical', 'general')),
  registration_deadline timestamptz,
  requirements text,
  contact_info text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Event registrations table
CREATE TABLE IF NOT EXISTS event_registrations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  event_id uuid REFERENCES events(id) ON DELETE CASCADE,
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  registered_at timestamptz DEFAULT now(),
  status text DEFAULT 'registered' CHECK (status IN ('registered', 'cancelled', 'attended')),
  notes text,
  UNIQUE(event_id, user_id)
);

-- Chat messages table (AI assistant)
CREATE TABLE IF NOT EXISTS chat_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  message text NOT NULL,
  response text NOT NULL,
  sources text[] DEFAULT '{}',
  response_time_ms integer,
  feedback_rating integer CHECK (feedback_rating BETWEEN 1 AND 5),
  created_at timestamptz DEFAULT now()
);

-- Attendance table
CREATE TABLE IF NOT EXISTS attendance (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid REFERENCES users(id) ON DELETE CASCADE,
  subject text NOT NULL,
  date date NOT NULL,
  status text NOT NULL CHECK (status IN ('present', 'absent', 'late')),
  marked_by uuid REFERENCES users(id) ON DELETE CASCADE,
  notes text,
  created_at timestamptz DEFAULT now(),
  UNIQUE(student_id, subject, date)
);

-- Grievances table
CREATE TABLE IF NOT EXISTS grievances (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid REFERENCES users(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text NOT NULL,
  category text NOT NULL CHECK (category IN ('academic', 'hostel', 'mess', 'transport', 'other')),
  status text DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'resolved', 'closed')),
  priority text DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high')),
  assigned_to uuid REFERENCES users(id),
  resolved_at timestamptz,
  resolved_by uuid REFERENCES users(id),
  resolution text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE assignment_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE leave_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE meal_menus ENABLE ROW LEVEL SECURITY;
ALTER TABLE meal_bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_registrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE grievances ENABLE ROW LEVEL SECURITY;

-- RLS Policies

-- Users policies
CREATE POLICY "Users can read own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Admins can read all users" ON users
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Resources policies
CREATE POLICY "Users can read public resources" ON resources
  FOR SELECT USING (is_public = true);

CREATE POLICY "Users can read own resources" ON resources
  FOR SELECT USING (uploaded_by = auth.uid());

CREATE POLICY "Teachers can create resources" ON resources
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM users WHERE id = auth.uid() AND role IN ('teacher', 'admin')
    )
  );

CREATE POLICY "Users can update own resources" ON resources
  FOR UPDATE USING (uploaded_by = auth.uid());

-- Assignments policies
CREATE POLICY "Students can read published assignments" ON assignments
  FOR SELECT USING (is_published = true);

CREATE POLICY "Teachers can manage own assignments" ON assignments
  FOR ALL USING (created_by = auth.uid());

-- Assignment submissions policies
CREATE POLICY "Students can manage own submissions" ON assignment_submissions
  FOR ALL USING (student_id = auth.uid());

CREATE POLICY "Teachers can read submissions for their assignments" ON assignment_submissions
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM assignments 
      WHERE id = assignment_submissions.assignment_id 
      AND created_by = auth.uid()
    )
  );

-- Leave applications policies
CREATE POLICY "Students can manage own leave applications" ON leave_applications
  FOR ALL USING (student_id = auth.uid());

CREATE POLICY "Wardens can read all leave applications" ON leave_applications
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM users WHERE id = auth.uid() AND role IN ('warden', 'admin')
    )
  );

CREATE POLICY "Wardens can update leave applications" ON leave_applications
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM users WHERE id = auth.uid() AND role IN ('warden', 'admin')
    )
  );

-- Meal menus policies
CREATE POLICY "Everyone can read meal menus" ON meal_menus
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Vendors can manage meal menus" ON meal_menus
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM users WHERE id = auth.uid() AND role IN ('vendor', 'admin')
    )
  );

-- Meal bookings policies
CREATE POLICY "Students can manage own meal bookings" ON meal_bookings
  FOR ALL USING (student_id = auth.uid());

CREATE POLICY "Vendors can read meal bookings" ON meal_bookings
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM users WHERE id = auth.uid() AND role IN ('vendor', 'admin')
    )
  );

-- Events policies
CREATE POLICY "Everyone can read approved events" ON events
  FOR SELECT USING (status = 'approved');

CREATE POLICY "Users can create events" ON events
  FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Users can update own events" ON events
  FOR UPDATE USING (created_by = auth.uid());

CREATE POLICY "Admins can manage all events" ON events
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Event registrations policies
CREATE POLICY "Users can manage own event registrations" ON event_registrations
  FOR ALL USING (user_id = auth.uid());

-- Chat messages policies
CREATE POLICY "Users can manage own chat messages" ON chat_messages
  FOR ALL USING (user_id = auth.uid());

-- Attendance policies
CREATE POLICY "Students can read own attendance" ON attendance
  FOR SELECT USING (student_id = auth.uid());

CREATE POLICY "Teachers can manage attendance" ON attendance
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM users WHERE id = auth.uid() AND role IN ('teacher', 'admin')
    )
  );

-- Grievances policies
CREATE POLICY "Students can manage own grievances" ON grievances
  FOR ALL USING (student_id = auth.uid());

CREATE POLICY "Admins can read all grievances" ON grievances
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    )
  );

CREATE POLICY "Admins can update grievances" ON grievances
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_resources_uploaded_by ON resources(uploaded_by);
CREATE INDEX IF NOT EXISTS idx_resources_department ON resources(department);
CREATE INDEX IF NOT EXISTS idx_resources_subject ON resources(subject);
CREATE INDEX IF NOT EXISTS idx_assignments_created_by ON assignments(created_by);
CREATE INDEX IF NOT EXISTS idx_assignments_due_date ON assignments(due_date);
CREATE INDEX IF NOT EXISTS idx_assignment_submissions_student_id ON assignment_submissions(student_id);
CREATE INDEX IF NOT EXISTS idx_assignment_submissions_assignment_id ON assignment_submissions(assignment_id);
CREATE INDEX IF NOT EXISTS idx_leave_applications_student_id ON leave_applications(student_id);
CREATE INDEX IF NOT EXISTS idx_leave_applications_status ON leave_applications(status);
CREATE INDEX IF NOT EXISTS idx_meal_bookings_student_id ON meal_bookings(student_id);
CREATE INDEX IF NOT EXISTS idx_meal_bookings_booking_date ON meal_bookings(booking_date);
CREATE INDEX IF NOT EXISTS idx_events_event_date ON events(event_date);
CREATE INDEX IF NOT EXISTS idx_events_status ON events(status);
CREATE INDEX IF NOT EXISTS idx_chat_messages_user_id ON chat_messages(user_id);
CREATE INDEX IF NOT EXISTS idx_attendance_student_id ON attendance(student_id);
CREATE INDEX IF NOT EXISTS idx_attendance_date ON attendance(date);
CREATE INDEX IF NOT EXISTS idx_grievances_student_id ON grievances(student_id);
CREATE INDEX IF NOT EXISTS idx_grievances_status ON grievances(status);

-- Full-text search indexes
CREATE INDEX IF NOT EXISTS idx_resources_title_search ON resources USING gin(to_tsvector('english', title));
CREATE INDEX IF NOT EXISTS idx_resources_description_search ON resources USING gin(to_tsvector('english', description));
CREATE INDEX IF NOT EXISTS idx_assignments_title_search ON assignments USING gin(to_tsvector('english', title));
CREATE INDEX IF NOT EXISTS idx_events_title_search ON events USING gin(to_tsvector('english', title));

-- Functions and triggers for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_resources_updated_at BEFORE UPDATE ON resources
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_assignments_updated_at BEFORE UPDATE ON assignments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON events
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_grievances_updated_at BEFORE UPDATE ON grievances
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();