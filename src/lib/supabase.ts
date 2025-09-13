import { createClient } from '@supabase/supabase-js';
import { createClientComponentClient, createServerComponentClient } from '@supabase/auth-helpers-nextjs';
import { cookies } from 'next/headers';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY!;

// Client-side Supabase client
export const supabase = createClient(supabaseUrl, supabaseAnonKey);

// Server-side Supabase client with service role (for admin operations)
export const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
});

// Client component helper
export const createSupabaseClient = () => createClientComponentClient();

// Server component helper
export const createSupabaseServerClient = () => createServerComponentClient({ cookies });

// Database helper functions
export const getUserProfile = async (userId: string) => {
  const { data, error } = await supabase
    .from('users')
    .select('*')
    .eq('id', userId)
    .single();
  
  if (error) throw error;
  return data;
};

export const updateUserProfile = async (userId: string, updates: any) => {
  const { data, error } = await supabase
    .from('users')
    .update(updates)
    .eq('id', userId)
    .select()
    .single();
  
  if (error) throw error;
  return data;
};

export const getResourcesByUser = async (userId: string) => {
  const { data, error } = await supabase
    .from('resources')
    .select('*')
    .eq('uploaded_by', userId)
    .order('created_at', { ascending: false });
  
  if (error) throw error;
  return data;
};

export const getAssignmentsByTeacher = async (teacherId: string) => {
  const { data, error } = await supabase
    .from('assignments')
    .select('*')
    .eq('created_by', teacherId)
    .order('created_at', { ascending: false });
  
  if (error) throw error;
  return data;
};

export const getAssignmentsByStudent = async (studentId: string) => {
  const { data, error } = await supabase
    .from('assignments')
    .select(`
      *,
      submissions:assignment_submissions(*)
    `)
    .order('due_date', { ascending: true });
  
  if (error) throw error;
  return data;
};

export const getLeaveApplications = async (studentId?: string) => {
  let query = supabase
    .from('leave_applications')
    .select(`
      *,
      student:users!leave_applications_student_id_fkey(full_name, email)
    `);
  
  if (studentId) {
    query = query.eq('student_id', studentId);
  }
  
  const { data, error } = await query.order('created_at', { ascending: false });
  
  if (error) throw error;
  return data;
};

export const getMealBookings = async (studentId?: string, date?: string) => {
  let query = supabase
    .from('meal_bookings')
    .select(`
      *,
      menu:meal_menus(*)
    `);
  
  if (studentId) {
    query = query.eq('student_id', studentId);
  }
  
  if (date) {
    query = query.eq('booking_date', date);
  }
  
  const { data, error } = await query.order('created_at', { ascending: false });
  
  if (error) throw error;
  return data;
};

export const getEvents = async (status?: string) => {
  let query = supabase
    .from('events')
    .select(`
      *,
      creator:users!events_created_by_fkey(full_name),
      registrations:event_registrations(count)
    `);
  
  if (status) {
    query = query.eq('status', status);
  }
  
  const { data, error } = await query.order('event_date', { ascending: true });
  
  if (error) throw error;
  return data;
};

export const getChatHistory = async (userId: string) => {
  const { data, error } = await supabase
    .from('chat_messages')
    .select('*')
    .eq('user_id', userId)
    .order('created_at', { ascending: false })
    .limit(50);
  
  if (error) throw error;
  return data;
};

export const getAnalytics = async () => {
  const [
    usersResult,
    resourcesResult,
    assignmentsResult,
    leavesResult,
    bookingsResult,
    grievancesResult
  ] = await Promise.all([
    supabase.from('users').select('id', { count: 'exact' }),
    supabase.from('resources').select('id', { count: 'exact' }),
    supabase.from('assignments').select('id', { count: 'exact' }),
    supabase.from('leave_applications').select('id', { count: 'exact' }).eq('status', 'pending'),
    supabase.from('meal_bookings').select('id', { count: 'exact' }).eq('booking_date', new Date().toISOString().split('T')[0]),
    supabase.from('grievances').select('id', { count: 'exact' }).eq('status', 'open')
  ]);

  return {
    total_users: usersResult.count || 0,
    total_resources: resourcesResult.count || 0,
    total_assignments: assignmentsResult.count || 0,
    pending_leaves: leavesResult.count || 0,
    meal_bookings_today: bookingsResult.count || 0,
    unread_grievances: grievancesResult.count || 0
  };
};