import { Database } from '@/types/supabase'

export type Tables<T extends keyof Database['public']['Tables']> = Database['public']['Tables'][T]['Row']
export type InsertTables<T extends keyof Database['public']['Tables']> = Database['public']['Tables'][T]['Insert']
export type UpdateTables<T extends keyof Database['public']['Tables']> = Database['public']['Tables'][T]['Update']
export type Enums<T extends keyof Database['public']['Enums']> = Database['public']['Enums'][T]

// Export specific types for our application
export type User = Tables<'users'>
export type Workspace = Tables<'workspaces'>
export type Artifact = Tables<'artifacts'>
export type WorkspaceUser = Tables<'workspace_users'>
export type WorkspaceRole = Tables<'workspace_roles'>

// Database types will be generated automatically with supabase gen types