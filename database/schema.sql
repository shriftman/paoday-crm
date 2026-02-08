-- Paoday.com Database Schema
-- Comprehensive schema for the all-in-one workspace platform

-- Users table: Core user management
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    avatar_url TEXT,
    timezone VARCHAR(50) DEFAULT 'UTC',
    locale VARCHAR(10) DEFAULT 'en',
    is_email_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    last_login_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Workspaces table: Multi-workspace support
CREATE TABLE workspaces (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    logo_url TEXT,
    is_personal BOOLEAN DEFAULT FALSE,
    max_members INTEGER DEFAULT 50,
    plan_tier VARCHAR(20) DEFAULT 'free' CHECK (plan_tier IN ('free', 'pro', 'business')),
    is_active BOOLEAN DEFAULT TRUE,
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    archived_at TIMESTAMP WITH TIME ZONE
);

-- Workspace members table: Many-to-many relationship between users and workspaces
CREATE TABLE workspace_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(20) DEFAULT 'member' CHECK (role IN ('owner', 'admin', 'member', 'viewer')),
    permissions JSONB DEFAULT '{}',
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    invited_by UUID REFERENCES users(id),
    UNIQUE(workspace_id, user_id)
);

-- Boards table: Kanban/project boards
CREATE TABLE boards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(20) DEFAULT 'kanban' CHECK (type IN ('kanban', 'scrum', 'timeline')),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'archived', 'deleted')),
    is_private BOOLEAN DEFAULT FALSE,
    position INTEGER DEFAULT 0,
    color VARCHAR(7) DEFAULT '#3B82F6',
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    archived_at TIMESTAMP WITH TIME ZONE
);

-- Board columns/stages (lists in kanban)
CREATE TABLE board_columns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    board_id UUID NOT NULL REFERENCES boards(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    position INTEGER NOT NULL,
    color VARCHAR(7) DEFAULT '#64748B',
    is_completed_stage BOOLEAN DEFAULT FALSE,
    wip_limit INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Cards/Items within boards
CREATE TABLE board_cards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    board_id UUID NOT NULL REFERENCES boards(id) ON DELETE CASCADE,
    column_id UUID REFERENCES board_columns(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    priority VARCHAR(10) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
    points INTEGER,
    due_date TIMESTAMP WITH TIME ZONE,
    labels TEXT[], -- Array of label strings
    assignees UUID[] REFERENCES users(id),
    watchers UUID[] REFERENCES users(id),
    position INTEGER DEFAULT 0,
    is_archived BOOLEAN DEFAULT FALSE,
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    archived_at TIMESTAMP WITH TIME ZONE
);

-- CRM Deals table
CREATE TABLE crm_deals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    deal_value DECIMAL(15,2),
    probability INTEGER DEFAULT 0 CHECK (probability >= 0 AND probability <= 100),
    stage VARCHAR(50) NOT NULL,
    expected_close_date DATE,
    description TEXT,
    contact_name VARCHAR(255),
    contact_email VARCHAR(255),
    contact_phone VARCHAR(50),
    company VARCHAR(255),
    priority VARCHAR(10) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high')),
    lead_source VARCHAR(50),
    owner_id UUID REFERENCES users(id),
    tags TEXT[],
    custom_fields JSONB DEFAULT '{}',
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'won', 'lost', 'on_hold')),
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Documents table (docs)
CREATE TABLE docs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    content JSONB NOT NULL DEFAULT '{}', -- Rich text content in JSON format
    plain_text TEXT, -- Plain text version for search
    version INTEGER DEFAULT 1,
    parent_id UUID REFERENCES docs(id) ON DELETE CASCADE,
    is_folder BOOLEAN DEFAULT FALSE,
    is_published BOOLEAN DEFAULT TRUE,
    permissions JSONB DEFAULT '{"visibility": "workspace"}',
    tags TEXT[],
    emoji VARCHAR(10),
    position INTEGER DEFAULT 0,
    word_count INTEGER DEFAULT 0,
    size_bytes INTEGER DEFAULT 0,
    created_by UUID NOT NULL REFERENCES users(id),
    last_edited_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Whiteboards table
CREATE TABLE whiteboards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    canvas_data JSONB NOT NULL DEFAULT '{}', -- Canvas state (shapes, connections, etc.)
    thumbnail_url TEXT,
    width INTEGER DEFAULT 1920,
    height INTEGER DEFAULT 1080,
    is_private BOOLEAN DEFAULT FALSE,
    is_template BOOLEAN DEFAULT FALSE,
    tags TEXT[],
    version INTEGER DEFAULT 1,
    created_by UUID NOT NULL REFERENCES users(id),
    last_edited_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    archived_at TIMESTAMP WITH TIME ZONE
);

-- Artifacts table (generic container for any file/attachment)
CREATE TABLE artifacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    filename VARCHAR(255),
    mime_type VARCHAR(100),
    file_size BIGINT,
    file_url TEXT NOT NULL,
    thumbnail_url TEXT,
    description TEXT,
    tags TEXT[],
    -- Polymorphic association
    entity_type VARCHAR(50) NOT NULL, -- 'board_card', 'doc', 'whiteboard', 'crm_deal'
    entity_id UUID NOT NULL,
    version INTEGER DEFAULT 1,
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE,
    INDEX idx_artifacts_entity (entity_type, entity_id)
);

-- Activity Events table (comprehensive activity tracking)
CREATE TABLE activity_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
    actor_id UUID NOT NULL REFERENCES users(id),
    action VARCHAR(50) NOT NULL, -- 'created', 'updated', 'deleted', 'moved', 'commented'
    entity_type VARCHAR(50) NOT NULL, -- 'board', 'card', 'doc', 'whiteboard', 'crm_deal', 'artifact'
    entity_id UUID NOT NULL,
    entity_name VARCHAR(255),
    details JSONB DEFAULT '{}', -- Additional event details
    old_values JSONB, -- Previous state for tracking changes
    new_values JSONB, -- New state values
    target_user_id UUID REFERENCES users(id), -- For notifications to others
    metadata JSONB DEFAULT '{}', -- Additional metadata for filtering/search
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comments system (reusable for all entities)
CREATE TABLE comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
    entity_type VARCHAR(50) NOT NULL,
    entity_id UUID NOT NULL,
    content TEXT NOT NULL,
    parent_id UUID REFERENCES comments(id) ON DELETE CASCADE, -- For threading
    created_by UUID NOT NULL REFERENCES users(id),
    is_edited BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE,
    INDEX idx_comments_entity (entity_type, entity_id)
);

-- Relationships table (generic many-to-many for connecting entities)
CREATE TABLE entity_relationships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
    source_type VARCHAR(50) NOT NULL,
    source_id UUID NOT NULL,
    target_type VARCHAR(50) NOT NULL,
    target_id UUID NOT NULL,
    relationship_type VARCHAR(50) NOT NULL, -- 'blocks', 'relates_to', 'duplicates', etc.
    metadata JSONB DEFAULT '{}',
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(source_type, source_id, target_type, target_id, relationship_type)
);

-- Search indexing table
CREATE TABLE search_index (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
    entity_type VARCHAR(50) NOT NULL,
    entity_id UUID NOT NULL,
    title TEXT,
    content TSVECTOR,
    tags TEXT[],
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(entity_type, entity_id)
);

-- Indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_workspace_members_user ON workspace_members(user_id);
CREATE INDEX idx_workspace_members_workspace ON workspace_members(workspace_id);
CREATE INDEX idx_boards_workspace ON boards(workspace_id);
CREATE INDEX idx_board_columns_board ON board_columns(board_id);
CREATE INDEX idx_board_cards_board ON board_cards(board_id);
CREATE INDEX idx_board_cards_column ON board_cards(column_id);
CREATE INDEX idx_board_cards_assignees ON board_cards USING GIN(assignees);
CREATE INDEX idx_crm_deals_workspace ON crm_deals(workspace_id);
CREATE INDEX idx_crm_deals_owner ON crm_deals(owner_id);
CREATE INDEX idx_docs_workspace ON docs(workspace_id);
CREATE INDEX idx_docs_parent ON docs(parent_id);
CREATE INDEX idx_whiteboards_workspace ON whiteboards(workspace_id);
CREATE INDEX idx_artifacts_workspace ON artifacts(workspace_id);
CREATE INDEX idx_activity_events_workspace ON activity_events(workspace_id);
CREATE INDEX idx_activity_events_actor ON activity_events(actor_id);
CREATE INDEX idx_activity_events_entity ON activity_events(entity_type, entity_id);
CREATE INDEX idx_comments_workspace ON comments(workspace_id);
CREATE INDEX idx_search_index_workspace ON search_index(workspace_id);
CREATE INDEX idx_search_index_content ON search_index USING GIN(content);

-- RLS Policies (PostgreSQL)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE workspaces ENABLE ROW LEVEL SECURITY;
ALTER TABLE workspace_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE boards ENABLE ROW LEVEL SECURITY;
ALTER TABLE board_cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE crm_deals ENABLE ROW LEVEL SECURITY;
ALTER TABLE docs ENABLE ROW LEVEL SECURITY;
ALTER TABLE whiteboards ENABLE ROW LEVEL SECURITY;
ALTER TABLE artifacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE activity_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

-- Helper functions
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_workspaces_updated_at BEFORE UPDATE ON workspaces FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_boards_updated_at BEFORE UPDATE ON boards FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_board_cards_updated_at BEFORE UPDATE ON board_cards FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_crm_deals_updated_at BEFORE UPDATE ON crm_deals FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_docs_updated_at BEFORE UPDATE ON docs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_whiteboards_updated_at BEFORE UPDATE ON whiteboards FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Full-text search trigger
CREATE OR REPLACE FUNCTION update_search_index()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        DELETE FROM search_index WHERE entity_type = TG_TABLE_NAME AND entity_id = OLD.id;
        RETURN OLD;
    END IF;
    
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        INSERT INTO search_index (workspace_id, entity_type, entity_id, title, content, tags, updated_at)
        VALUES (
            NEW.workspace_id,
            TG_TABLE_NAME,
            NEW.id,
            COALESCE(NEW.name, NEW.title, ''),
            to_tsvector('english', COALESCE(NEW.title || ' ' || NEW.description, '')),
            COALESCE(NEW.tags, '{}'),
            NOW()
        ) ON CONFLICT (entity_type, entity_id) DO UPDATE SET
            title = EXCLUDED.title,
            content = EXCLUDED.content,
            tags = EXCLUDED.tags,
            updated_at = EXCLUDED.updated_at;
        RETURN NEW;
    END IF;
END;
$$ language 'plpgsql';

-- Search triggers for searchable tables
CREATE TRIGGER search_index_boards AFTER INSERT OR UPDATE OR DELETE ON boards FOR EACH ROW EXECUTE FUNCTION update_search_index();
CREATE TRIGGER search_index_cards AFTER INSERT OR UPDATE OR DELETE ON board_cards FOR EACH ROW EXECUTE FUNCTION update_search_index();
CREATE TRIGGER search_index_docs AFTER INSERT OR UPDATE OR DELETE ON docs FOR EACH ROW EXECUTE FUNCTION update_search_index();
CREATE TRIGGER search_index_whiteboards AFTER INSERT OR UPDATE OR DELETE ON whiteboards FOR EACH ROW EXECUTE FUNCTION update_search_index();

-- Sequelize timestamps helper
CREATE OR REPLACE FUNCTION set_timestamps()
RETURNS TRIGGER AS $$
BEGIN
    NEW.created_at = COALESCE(NEW.created_at, NOW());
    NEW.updated_at = COALESCE(NEW.updated_at, NOW());
    RETURN NEW;
END;
$$ language 'plpgsql';