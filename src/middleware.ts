import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  // Example: attach supabase instance via a header or use for logging
  const response = NextResponse.next();
  // e.g., response.headers.set('x-sb-session', JSON.stringify(...))
  return response;
}

export const config = {
  matcher: '/((?!_next/static|_next/image|favicon.ico).*)',
}; 