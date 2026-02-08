// This file contains type definitions for your data.
// It will be regenerated when you run 'supabase gen types typescript'.

export interface Database {
  public: {
    Tables: {
      users: {
        Row: {
          id: string
          email: string
          full_name: string | null
          avatar_url: string | null
          created_at: string
          updated_at: string
          last_sign_in_at: string | null
          email_confirmed_at: string | null
        }
        Insert: {
          id?: string
          email: string
          full_name?: string | null
          avatar_url?: string | null
          created_at?: string
          updated_at?: string
          last_sign_in_at?: string | null
          email_confirmed_at?: string | null
        }
        Update: {
          id?: string
          email?: string
          full_name?: string | null
          avatar_url?: string | null
          created_at?: string
          updated_at?: string
          last_sign_in_at?: string | null
          email_confirmed_at?: string | null
        }
      }
      workspaces: {
        Row: {
          id: string
          name: string
          slug: string
          description: string | null
          avatar_url: string | null
          owner_user_id: string
          created_at: string
          updated_at: string
          is_personal: boolean
          settings: Json | null
        }
        Insert: {
          id?: string
          name: string
          slug: string
          description?: string | null
          avatar_url?: string | null
          owner_user_id: string
          created_at?: string
          updated_at?: string
          is_personal?: boolean
          settings?: Json | null
        }
        Update: {
          id?: string
          name?: string
          slug?: string
          description?: string | null
          avatar_url?: string | null
          owner_user_id?: string
          created_at?: string
          updated_at?: string
          is_personal?: boolean
          settings?: Json | null
        }
      }
      workspace_users: {
        Row: {
          workspace_id: string
          user_id: string
          role_id: string
          joined_at: string
          invited_by: string | null
        }
        Insert: {
          workspace_id: string
          user_id: string
          role_id: string
          joined_at?: string
          invited_by?: string | null
        }
        Update: {
          workspace_id?: string
          user_id?: string
          role_id?: string
          joined_at?: string
          invited_by?: string | null
        }
      }
      workspace_roles: {
        Row: {
          id: string
          workspace_id: string
          name: string
          slug: string
          permissions: Json
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          workspace_id: string
          name: string
          slug: string
          permissions: Json
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          workspace_id?: string
          name?: string
          slug?: string
          permissions?: Json
          created_at?: string
          updated_at?: string
        }
      }
      artifacts: {
        Row: {
          id: string
          name: string
          type: string
          content: string | null
          file_url: string | null
          file_size: number | null
          mime_type: string | null
          tags: string[]
          metadata: Json | null
          workspace_id: string
          created_by: string
          created_at: string
          updated_at: string
          is_archived: boolean
        }
        Insert: {
          id?: string
          name: string
          type: string
          content?: string | null
          file_url?: string | null
          file_size?: number | null
          mime_type?: string | null
          tags?: string[]
          metadata?: Json | null
          workspace_id: string
          created_by: string
          created_at?: string
          updated_at?: string
          is_archived?: boolean
        }
        Update: {
          id?: string
          name?: string
          type?: string
          content?: string | null
          file_url?: string | null
          file_size?: number | null
          mime_type?: string | null
          tags?: string[]
          metadata?: Json | null
          workspace_id?: string
          created_by?: string
          created_at?: string
          updated_at?: string
          is_archived?: boolean
        }
      }
      contacts: {
        Row: {
          id: string
          first_name: string
          last_name: string
          email: string
          phone: string | null
          company: string | null
          job_title: string | null
          avatar_url: string | null
          notes: string | null
          tags: string[]
          status: string
          source: string | null
          custom_fields: Json | null
          workspace_id: string
          created_by: string
          created_at: string
          updated_at: string
          is_archived: boolean
        }
        Insert: {
          id?: string
          first_name: string
          last_name: string
          email: string
          phone?: string | null
          company?: string | null
          job_title?: string | null
          avatar_url?: string | null
          notes?: string | null
          tags?: string[]
          status?: string
          source?: string | null
          custom_fields?: Json | null
          workspace_id: string
          created_by: string
          created_at?: string
          updated_at?: string
          is_archived?: boolean
        }
        Update: {
          id?: string
          first_name?: string
          last_name?: string
          email?: string
          phone?: string | null
          company?: string | null
          job_title?: string | null
          avatar_url?: string | null
          notes?: string | null
          tags?: string[]
          status?: string
          source?: string | null
          custom_fields?: Json | null
          workspace_id?: string
          created_by?: string
          created_at?: string
          updated_at?: string
          is_archived?: boolean
        }
      }
      leads: {
        Row: {
          id: string
          title: string
          contact_id: string
          value: number | null
          probability: number | null
          stage: string
          expected_close_date: string | null
          description: string | null
          tags: string[]
          custom_fields: Json | null
          workspace_id: string
          created_by: string
          created_at: string
          updated_at: string
          is_archived: boolean
          last_activity_date: string | null
          source: string | null
        }
        Insert: {
          id?: string
          title: string
          contact_id: string
          value?: number | null
          probability?: number | null
          stage?: string
          expected_close_date?: string | null
          description?: string | null
          tags?: string[]
          custom_fields?: Json | null
          workspace_id: string
          created_by: string
          created_at?: string
          updated_at?: string
          is_archived?: boolean
          last_activity_date?: string | null
          source?: string | null
        }
        Update: {
          id?: string
          title?: string
          contact_id?: string
          value?: number | null
          probability?: number | null
          stage?: string
          expected_close_date?: string | null
          description?: string | null
          tags?: string[]
          custom_fields?: Json | null
          workspace_id?: string
          created_by?: string
          created_at?: string
          updated_at?: string
          is_archived?: boolean
          last_activity_date?: string | null
          source?: string | null
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      artifact_type: 'document' | 'image' | 'video' | 'audio' | 'file' | 'note'
      contact_status: 'active' | 'inactive' | 'blacklisted'
      lead_stage: 'new' | 'qualified' | 'proposal' | 'negotiation' | 'closed_won' | 'closed_lost'
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]