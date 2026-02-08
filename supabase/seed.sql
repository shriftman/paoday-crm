-- Insert default workspace roles with different permission levels
INSERT INTO public.workspace_roles (workspace_id, name, slug, permissions) VALUES 
(
    uuid_generate_v4(), -- This will be replaced in the actual seeding
    'Owner',
    'owner',
    '{"workspace:read": true, "workspace:update": true, "workspace:delete": true, "roles:read": true, "roles:update": true, "roles:create": true, "roles:delete": true, "users:invite": true, "users:kick": true, "users:roles": true, "artifacts:read": true, "artifacts:create": true, "artifacts:update": true, "artifacts:delete": true, "contacts:read": true, "contacts:create": true, "contacts:update": true, "contacts:delete": true, "leads:read": true, "leads:create": true, "leads:update": true, "leads:delete": true, "settings:read": true, "settings:update": true}'::jsonb
),
(
    uuid_generate_v4(), -- This will be replaced in the actual seeding
    'Admin',
    'admin',
    '{"workspace:read": true, "workspace:update": true, "workspace:delete": false, "roles:read": true, "roles:update": true, "roles:create": false, "roles:delete": false, "users:invite": true, "users:kick": true, "users:roles": true, "artifacts:read": true, "artifacts:create": true, "artifacts:update": true, "artifacts:delete": true, "contacts:read": true, "contacts:create": true, "contacts:update": true, "contacts:delete": true, "leads:read": true, "leads:create": true, "leads:update": true, "leads:delete": true, "settings:read": true, "settings:update": true}'::jsonb
),
(
    uuid_generate_v4(), -- This will be replaced in the actual seeding
    'Manager',
    'manager',
    '{"workspace:read": true, "workspace:update": false, "workspace:delete": false, "roles:read": true, "roles:update": false, "roles:create": false, "roles:delete": false, "users:invite": false, "users:kick": false, "users:roles": false, "artifacts:read": true, "artifacts:create": true, "artifacts:update": true, "artifacts:delete": true, "contacts:read": true, "contacts:create": true, "contacts:update": true, "contacts:delete": true, "leads:read": true, "leads:create": true, "leads:update": true, "leads:delete": true, "settings:read": true, "settings:update": false}'::jsonb
),
(
    uuid_generate_v4(), -- This will be replaced in the actual seeding
    'Member',
    'member',
    '{"workspace:read": true, "workspace:update": false, "workspace:delete": false, "roles:read": true, "roles:update": false, "roles:create": false, "roles:delete": false, "users:invite": false, "users:kick": false, "users:roles": false, "artifacts:read": true, "artifacts:create": true, "artifacts:update": false, "artifacts:delete": false, "contacts:read": true, "contacts:create": true, "contacts:update": true, "contacts:delete": false, "leads:read": true, "leads:create": true, "leads:update": true, "leads:delete": false, "settings:read": true, "settings:update": false}'::jsonb
),
(
    uuid_generate_v4(), -- This will be replaced in the actual seeding
    'Viewer',
    'viewer',
    '{"workspace:read": true, "workspace:update": false, "workspace:delete": false, "roles:read": true, "roles:update": false, "roles:create": false, "roles:delete": false, "users:invite": false, "users:kick": false, "users:roles": false, "artifacts:read": true, "artifacts:create": false, "artifacts:update": false, "artifacts:delete": false, "contacts:read": true, "contacts:create": false, "contacts:update": false, "contacts:delete": false, "leads:read": true, "leads:create": false, "leads:update": false, "leads:delete": false, "settings:read": true, "settings:update": false}'::jsonb
);

-- Insert sample default data for a workspace
-- These can be used for testing purposes
-- Note: actual implementation should create workspace-specific roles instead of global ones

-- Create a sample contact
INSERT INTO public.contacts (
    first_name,
    last_name,
    email,
    phone,
    company,
    job_title,
    status,
    tags,
    workspace_id,
    created_by
) VALUES 
(
    'John',
    'Doe',
    'john.doe@example.com',
    '+1-555-123-4567',
    'Tech Corp',
    'VP of Sales',
    'active',
    ARRAY['prospect', 'high-value'],
    uuid_generate_v4(), -- This will be replaced with actual workspace_id
    uuid_generate_v4()  -- This will be replaced with actual user_id
),
(
    'Jane',
    'Smith',
    'jane.smith@example.com',
    '+1-555-987-6543',
    'Marketing Inc',
    'CEO',
    'active',
    ARRAY['client', 'reference-account'],
    uuid_generate_v4(), -- This will be replaced with actual workspace_id
    uuid_generate_v4()  -- This will be replaced with actual user_id
);

-- Create sample artifacts
INSERT INTO public.artifacts (
    name,
    type,
    content,
    tags,
    metadata,
    workspace_id,
    created_by
) VALUES 
(
    'Q4 Sales Strategy',
    'note',
    'Focus on enterprise clients in the Northwest region...',
    ARRAY['strategy', 'sales', 'q4'],
    '{"importance": "high", "department": "sales"}'::jsonb,
    uuid_generate_v4(), -- This will be replaced with actual workspace_id
    uuid_generate_v4()  -- This will be replaced with actual user_id
),
(
    'Product Pitch Deck',
    'document',
    'Product overview presentation for enterprise sales...',
    ARRAY['presentation', 'sales', 'product-demo'],
    '{"file_type": "pdf", "version": "v2.1"}'::jsonb,
    uuid_generate_v4(), -- This will be replaced with actual workspace_id
    uuid_generate_v4()  -- This will be replaced with actual user_id
);

-- Create sample leads
INSERT INTO public.leads (
    title,
    contact_id,
    value,
    probability,
    stage,
    expected_close_date,
    description,
    tags,
    source,
    workspace_id,
    created_by
) VALUES 
(
    'Enterprise Contract - Tech Corp',
    uuid_generate_v4(), -- This will be replaced with actual contact_id
    75000.00,
    75,
    'negotiation',
    '2024-03-15',
    'Follow up on the proposal sent last week. They requested custom integration.',
    ARRAY['enterprise', 'high-value', 'tech-sector'],
    'webinar',
    uuid_generate_v4(), -- This will be replaced with actual workspace_id
    uuid_generate_v4()  -- This will be replaced with actual user_id
),
(
    'Marketing Services Renewal',
    uuid_generate_v4(), -- This will be replaced with actual contact_id
    25000.00,
    90,
    'proposal',
    '2024-02-28',
    'Annual contract renewal discussion scheduled for next week.',
    ARRAY['renewal', 'existing-client'],
    'sales-call',
    uuid_generate_v4(), -- This will be replaced with actual workspace_id
    uuid_generate_v4()  -- This will be replaced with actual user_id
);