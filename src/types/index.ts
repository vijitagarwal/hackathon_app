export interface User {
  id: string;
  email: string;
  role: UserRole;
  full_name: string;
  avatar_url?: string;
  created_at: string;
  updated_at: string;
}

export type UserRole = 'student' | 'teacher' | 'warden' | 'vendor' | 'admin';

export interface Student extends User {
  student_id: string;
  department: string;
  year: number;
  hostel_room?: string;
}

export interface Teacher extends User {
  teacher_id: string;
  department: string;
  subjects: string[];
}

export interface Resource {
  id: string;
  title: string;
  description?: string;
  file_url: string;
  file_type: string;
  file_size: number;
  uploaded_by: string;
  uploaded_at: string;
  ai_summary?: string;
  tags: string[];
  department?: string;
  subject?: string;
}

export interface Assignment {
  id: string;
  title: string;
  description: string;
  due_date: string;
  created_by: string;
  created_at: string;
  max_marks: number;
  subject: string;
  department: string;
  attachments?: string[];
}

export interface AssignmentSubmission {
  id: string;
  assignment_id: string;
  student_id: string;
  file_url?: string;
  submission_text?: string;
  submitted_at: string;
  marks?: number;
  feedback?: string;
  graded_by?: string;
  graded_at?: string;
}

export interface LeaveApplication {
  id: string;
  student_id: string;
  reason: string;
  from_date: string;
  to_date: string;
  status: 'pending' | 'approved' | 'rejected';
  applied_at: string;
  reviewed_by?: string;
  reviewed_at?: string;
  comments?: string;
}

export interface MealMenu {
  id: string;
  date: string;
  meal_type: 'breakfast' | 'lunch' | 'dinner';
  items: string[];
  price: number;
  available: boolean;
  created_by: string;
}

export interface MealBooking {
  id: string;
  student_id: string;
  menu_id: string;
  booking_date: string;
  meal_type: 'breakfast' | 'lunch' | 'dinner';
  status: 'booked' | 'cancelled';
  payment_status: 'pending' | 'paid' | 'refunded';
  created_at: string;
  cancelled_at?: string;
}

export interface Event {
  id: string;
  title: string;
  description: string;
  event_date: string;
  location: string;
  max_participants?: number;
  created_by: string;
  status: 'draft' | 'pending' | 'approved' | 'rejected';
  created_at: string;
  approved_by?: string;
  approved_at?: string;
}

export interface EventRegistration {
  id: string;
  event_id: string;
  user_id: string;
  registered_at: string;
  status: 'registered' | 'cancelled';
}

export interface ChatMessage {
  id: string;
  user_id: string;
  message: string;
  response: string;
  sources?: string[];
  created_at: string;
}

export interface Attendance {
  id: string;
  student_id: string;
  subject: string;
  date: string;
  status: 'present' | 'absent' | 'late';
  marked_by: string;
  created_at: string;
}

export interface Grievance {
  id: string;
  student_id: string;
  title: string;
  description: string;
  category: 'academic' | 'hostel' | 'mess' | 'transport' | 'other';
  status: 'open' | 'in_progress' | 'resolved' | 'closed';
  priority: 'low' | 'medium' | 'high';
  created_at: string;
  resolved_at?: string;
  resolved_by?: string;
  resolution?: string;
}

export interface Analytics {
  total_users: number;
  active_users: number;
  total_resources: number;
  total_assignments: number;
  pending_leaves: number;
  meal_bookings_today: number;
  meal_cancellations_today: number;
  unread_grievances: number;
  ai_queries_today: number;
  storage_used: number;
}

export interface DemoStep {
  id: string;
  title: string;
  description: string;
  action: string;
  selector?: string;
  value?: string;
  waitFor?: number;
  screenshot?: boolean;
}