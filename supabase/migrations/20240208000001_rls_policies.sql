-- Enable Row Level Security (RLS)
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workspaces ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workspace_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workspace_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.artifacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY;

-- Users RLS policies
CREATE POLICY "Users can view own profile" ON public.users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON public.users FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can view any profile" ON public.users FOR SELECT USING (true);

-- Workspaces RLS policies
CREATE POLICY "Workspaces are viewable by members" ON public.workspaces FOR SELECT USING (
    EXISTs (
        SELECT 1 FROM public.workspace_users
        WHERE workspace_users.workspace_id = workspaces.id
        AND workspace_users.user_id = auth.uid()
    ) OR owner_user_id = auth.uid()
);

CREATE POLICY "Users can create workspaces" ON public.workspaces FOR INSERT WITH CHECK (
    owner_user_id = auth.uid()
);

CREATE POLICY "Owners can update their workspaces" ON public.workspaces FOR UPDATE USING (
    owner_user_id = auth.uid()
);

CREATE POLICY "Owners can delete their workspaces" ON public.workspaces FOR DELETE USING (
    owner_user_id = auth.uid()
);

-- Workspace roles RLS policies
CREATE POLICY "Roles are viewable by workspace members" ON public.workspace_roles FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.workspace_users
        WHERE workspace_users.workspace_id = workspace_roles.workspace_id
        AND workspace_users.user_id = auth.uid()
    ) OR EXISTS (
        SELECT 1 FROM public.workspaces
        WHERE workspaces.id = workspace_roles.workspace_id
        AND workspaces.owner_user_id = auth.uid()
    )
);

CREATE POLICY "Owners can manage workspace roles" ON public.workspace_roles FOR ALL USING (
    EXISTS (
        SELECT 1 FROM public.workspaces
        WHERE workspaces.id = workspace_roles.workspace_id
        AND workspaces.owner_user_id = auth.uid()
    )
);

-- Workspace users RLS policies
CREATE POLICY "Users can view workspace memberships" ON public.workspace_users FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.workspace_users AS wu
        WHERE wu.workspace_id = workspace_users.workspace_id
        AND wu.user_id = auth.uid()
    )
);

CREATE POLICY "Owners can manage workspace members" ON public.workspace_users FOR ALL USING (
    EXISTS (
        SELECT 1 FROM public.workspaces
        WHERE workspaces.id = workspace_users.workspace_id
        AND workspaces.owner_user_id = auth.uid()
    )
);

CREATE POLICY "Users can join workspace with invitations" ON public.workspace_users FOR INSERT WITH CHECK (
    user_id = auth.uid()
);

-- Artifacts RLS policies
CREATE POLICY "Artifacts are viewable by workspace members" ON public.artifacts FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.workspace_users
        WHERE workspace_users.workspace_id = artifacts.workspace_id
        AND workspace_users.user_id = auth.uid()
    )
);

CREATE POLICY "Users can create artifacts in assigned workspaces" ON public.artifacts FOR INSERT WITH CHECK (
    created_by = auth.uid() AND
    EXISTS (
        SELECT 1 FROM public.workspace_users
        WHERE workspace_users.workspace_id = artifacts.workspace_id
        AND workspace_users.user_id = auth.uid()
    )
);

CREATE POLICY "Users can update own artifacts" ON public.artifacts FOR UPDATE USING (
    created_by = auth.uid()
);

CREATE POLICY "Workspace members can update artifacts" ON public.artifacts FOR UPDATE USING (
    EXISTS (
        SELECT 1 FROM public.workspace_users
        WHERE workspace_users.workspace_id = artifacts.workspace_id
        AND workspace_users.user_id = auth.uid()
    )
);

CREATE POLICY "Users can delete own artifacts" ON public.artifacts FOR DELETE USING (
    created_by = auth.uid()
);

-- Contacts RLS policies
CREATE POLICY "Contacts are viewable by workspace members" ON public.contacts FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.workspace_users
        WHERE workspace_users.workspace_id = contacts.workspace_id
        AND workspace_users.user_id = auth.uid()
    )
);

CREATE POLICY "Users can create contacts in assigned workspaces" ON public.contacts FOR INSERT WITH CHECK (
    created_by = auth.uid() AND
    EXISTS (
        SELECT 1 FROM public.workspace_users
        WHERE workspace_users.workspace_id = contacts.workspace_id
        AND workspace_users.user_id = auth.uid()
    )
);

CREATE POLICY "Users can update own contacts" ON public.contacts FOR UPDATE USING (
    created_by = auth.uid()
);

CREATE POLICY "Workspace members can update contacts" ON public.contacts FOR UPDATE USING (
    EXISTS (
        SELECT 1 FROM public.workspace_users
        WHERE workspace_users.workspace_id = contacts.workspace_id
        AND workspace_users.user_id = auth.uid()
    )
);

CREATE POLICY "Users can delete own contacts" ON public.contacts FOR DELETE USING (
    created_by = auth.uid()
);

-- Leads RLS policies
CREATE POLICY "Leads are viewable by workspace members" ON public.leads FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.workspace_users
        WHERE workspace_users.workspace_id = leads.workspace_id
        AND workspace_users.user_id = auth.uid()
    )
);

CREATE POLICY "Users can create leads in assigned workspaces" ON public.leads FOR INSERT WITH CHECK (
    created_by = auth.uid() AND
    EXISTS (
        SELECT 1 FROM public.workspace_users
        WHERE workspace_users.workspace_id = leads.workspace_id
        AND workspace_users.user_id = auth.uid()
    )
);

CREATE POLICY "Users can update own leads" ON public.leads FOR UPDATE USING (
    created_by = auth.uid()
);

CREATE POLICY "Workspace members can update leads" ON public.leads FOR UPDATE USING (
    EXISTS (
        SELECT 1 FROM public.workspace_users
        WHERE workspace_users.workspace_id = leads.workspace_id
        AND workspace_users.user_id = auth.uid()
    )
);

CREATE POLICY "Users can delete own leads" ON public.leads FOR DELETE USING (
    created_by = auth.uid()
);