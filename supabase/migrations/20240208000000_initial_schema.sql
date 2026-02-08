-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable Row Level Security
ALTER DATABASE postgres SET "app.settings.jwt_exp" TO '3600';

-- Enum types
CREATE TYPE artifact_type AS ENUM ('document', 'image', 'video', 'audio', 'file', 'note');
CREATE TYPE contact_status AS ENUM ('active', 'inactive', 'blacklisted');
CREATE TYPE lead_stage AS ENUM ('new', 'qualified', 'proposal', 'negotiation', 'closed_won', 'closed_lost');

-- Create users table (extends auth.users)
CREATE TABLE public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT,
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    last_sign_in_at TIMESTAMPTZ,
    email_confirmed_at TIMESTAMPTZ
);

-- Create workspaces table
CREATE TABLE public.workspaces (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    description TEXT,
    avatar_url TEXT,
    owner_user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    is_personal BOOLEAN DEFAULT FALSE,
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create workspace_roles table
CREATE TABLE public.workspace_roles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workspace_id UUID NOT NULL REFERENCES public.workspaces(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    permissions JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(workspace_id, slug)
);

-- Create workspace_users table (junction table)
CREATE TABLE public.workspace_users (
    workspace_id UUID NOT NULL REFERENCES public.workspaces(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES public.workspace_roles(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    invited_by UUID REFERENCES public.users(id) ON DELETE SET NULL,
    PRIMARY KEY (workspace_id, user_id)
);

-- Create artifacts table
CREATE TABLE public.artifacts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    type artifact_type NOT NULL,
    content TEXT,
    file_url TEXT,
    file_size BIGINT,
    mime_type TEXT,
    tags TEXT[] DEFAULT ARRAY[]::TEXT[],
    metadata JSONB DEFAULT '{}',
    workspace_id UUID NOT NULL REFERENCES public.workspaces(id) ON DELETE CASCADE,
    created_by UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    is_archived BOOLEAN DEFAULT FALSE
);

-- Create contacts table
CREATE TABLE public.contacts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    company TEXT,
    job_title TEXT,
    avatar_url TEXT,
    notes TEXT,
    tags TEXT[] DEFAULT ARRAY[]::TEXT[],
    status contact_status NOT NULL DEFAULT 'active',
    source TEXT,
    custom_fields JSONB DEFAULT '{}',
    workspace_id UUID NOT NULL REFERENCES public.workspaces(id) ON DELETE CASCADE,
    created_by UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    is_archived BOOLEAN DEFAULT FALSE
);

-- Create leads table
CREATE TABLE public.leads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    contact_id UUID NOT NULL REFERENCES public.contacts(id) ON DELETE CASCADE,
    value DECIMAL(15,2),
    probability INTEGER CHECK (probability >= 0 AND probability <= 100),
    stage lead_stage NOT NULL DEFAULT 'new',
    expected_close_date DATE,
    description TEXT,
    tags TEXT[] DEFAULT ARRAY[]::TEXT[],
    custom_fields JSONB DEFAULT '{}',
    workspace_id UUID NOT NULL REFERENCES public.workspaces(id) ON DELETE CASCADE,
    created_by UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    last_activity_date TIMESTAMPTZ,
    source TEXT,
    is_archived BOOLEAN DEFAULT FALSE
);

-- Create indexes for better performance
CREATE INDEX users_email_idx ON public.users(email);
CREATE INDEX workspaces_owner_idx ON public.workspaces(owner_user_id);
CREATE INDEX workspaces_slug_idx ON public.workspaces(slug);
CREATE INDEX workspace_users_workspace_idx ON public.workspace_users(workspace_id);
CREATE INDEX workspace_users_user_idx ON public.workspace_users(user_id);
CREATE INDEX workspaces_name_trgm_idx ON public.workspaces USING gin (name gin_trgm_ops);
CREATE INDEX workspaces_description_trgm_idx ON public.workspaces USING gin (description gin_trgm_ops);
CREATE INDEX artifacts_workspace_idx ON public.artifacts(workspace_id);
CREATE INDEX artifacts_created_by_idx ON public.artifacts(created_by);
CREATE INDEX artifacts_type_idx ON public.artifacts(type);
CREATE INDEX artifacts_tags_idx ON public.artifacts USING gin (tags);
CREATE INDEX contacts_workspace_idx ON public.contacts(workspace_id);
CREATE INDEX contacts_email_idx ON public.contacts(email);
CREATE INDEX contacts_status_idx ON public.contacts(status);
CREATE INDEX contacts_created_by_idx ON public.contacts(created_by);
CREATE INDEX contacts_name_trgm_idx ON public.contacts USING gin ((first_name || ' ' || last_name) gin_trgm_ops);
CREATE INDEX leads_workspace_idx ON public.leads(workspace_id);
CREATE INDEX leads_contact_idx ON public.leads(contact_id);
CREATE INDEX leads_stage_idx ON public.leads(stage);
CREATE INDEX leads_created_by_idx ON public.leads(created_by);
CREATE INDEX leads_value_idx ON public.leads(value);
CREATE INDEX leads_probability_idx ON public.leads(probability);

-- Create triggers for updated_at columns
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_workspaces_updated_at BEFORE UPDATE ON public.workspaces FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_workspace_roles_updated_at BEFORE UPDATE ON public.workspace_roles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_artifacts_updated_at BEFORE UPDATE ON public.artifacts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_contacts_updated_at BEFORE UPDATE ON public.contacts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_leads_updated_at BEFORE UPDATE ON public.leads FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Add foreign key constraint for workspace_users: ensure role belongs to workspace
ALTER TABLE public.workspace_users 
ADD CONSTRAINT fk_workspace_users_role 
FOREIGN KEY (role_id) 
REFERENCES public.workspace_roles(id) ON DELETE CASCADE;

-- Create function to get server URL including path and query string
CREATE OR REPLACE FUNCTION get_server_url()
RETURNS text
LANGUAGE sql IMMUTABLE SECURITY DEFINER AS
'
SELECT coalesce(current_setting('request.headers', true)::json->>'x-forwarded-url', current_setting('request.headers', true)::json->>'origin', 'http://localhost:54321') 
';