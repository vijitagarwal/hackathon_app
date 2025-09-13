import { createServerComponentClient } from '@supabase/auth-helpers-nextjs';
import { cookies } from 'next/headers';
import { redirect } from 'next/navigation';
import { UserRole } from '@/types';

export const getUser = async () => {
  const supabase = createServerComponentClient({ cookies });
  
  const {
    data: { session },
  } = await supabase.auth.getSession();
  
  if (!session) {
    return null;
  }
  
  const { data: profile } = await supabase
    .from('users')
    .select('*')
    .eq('id', session.user.id)
    .single();
  
  return profile;
};

export const requireAuth = async (allowedRoles?: UserRole[]) => {
  const user = await getUser();
  
  if (!user) {
    redirect('/auth/login');
  }
  
  if (allowedRoles && !allowedRoles.includes(user.role)) {
    redirect('/dashboard');
  }
  
  return user;
};

export const requireRole = (allowedRoles: UserRole[]) => {
  return async () => {
    const user = await getUser();
    
    if (!user) {
      return { error: 'Unauthorized', status: 401 };
    }
    
    if (!allowedRoles.includes(user.role)) {
      return { error: 'Forbidden', status: 403 };
    }
    
    return { user };
  };
};

export const hashPassword = async (password: string): Promise<string> => {
  const bcrypt = require('bcryptjs');
  return bcrypt.hash(password, 12);
};

export const verifyPassword = async (password: string, hash: string): Promise<boolean> => {
  const bcrypt = require('bcryptjs');
  return bcrypt.compare(password, hash);
};

export const generateJWT = (payload: any): string => {
  const jwt = require('jsonwebtoken');
  return jwt.sign(payload, process.env.JWT_SECRET!, { expiresIn: '24h' });
};

export const verifyJWT = (token: string): any => {
  const jwt = require('jsonwebtoken');
  return jwt.verify(token, process.env.JWT_SECRET!);
};