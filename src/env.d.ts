/// <reference types="next" />

declare namespace NodeJS {
  interface ProcessEnv {
    // Client-side
    readonly NEXT_PUBLIC_SUPABASE_URL: string;
    readonly NEXT_PUBLIC_SUPABASE_ANON_KEY: string;
    // Server-side
    readonly SUPABASE_URL: string;
    readonly SUPABASE_SERVICE_ROLE_KEY: string;
  }
} 