-- Sample data for Paoday.com
-- Insert demo data for testing the application

-- Demo users
INSERT INTO users (id, email, username, full_name, avatar_url, is_email_verified) VALUES
('a1b2c3d4-e5f6-7890-abcd-1234567890ab', 'alice@paoday.com', 'alice', 'Alice Johnson', 'https://api.dicebear.com/7.x/avataaars/svg?seed=alice', true),
('b2c3d4e5-f6a7-8901-bcde-2345678901bc', 'bob@paoday.com', 'bob', 'Bob Williams', 'https://api.dicebear.com/7.x/avataaars/svg?seed=bob', true),
('c3d4e5f6-a7b8-9012-cdef-3456789012cd', 'charlie@paoday.com', 'charlie', 'Charlie Brown', 'https://api.dicebear.com/7.x/avataaars/svg?seed=charlie', true),
('d4e5f6a7-b8c9-0123-def0-4567890123de', 'diana@paoday.com', 'diana', 'Diana Prince', 'https://api.dicebear.com/7.x/avataaars/svg?seed=diana', true);

-- Demo workspaces
INSERT INTO workspaces (id, name, slug, description, logo_url, created_by) VALUES
('ws1-abcd-1234', 'Marketing Team', 'marketing-team', 'Central workspace for marketing campaigns and strategies', 'https://example.com/logos/marketing.png', 'a1b2c3d4-e5f6-7890-abcd-1234567890ab'),
('ws2-bcde-2345', 'Product Development', 'product-dev', 'Product roadmap and development sprints', 'https://example.com/logos/product.png', 'b2c3d4e5-f6a7-8901-bcde-2345678901bc'),
('ws3-cdef-3456', 'Sales Pipeline', 'sales-pipeline', 'CRM and sales opportunity management', NULL, 'c3d4e5f6-a7b8-9012-cdef-3456789012cd');

-- Workspace memberships
INSERT INTO workspace_members (workspace_id, user_id, role) VALUES
('ws1-abcd-1234', 'a1b2c3d4-e5f6-7890-abcd-1234567890ab', 'owner'),
('ws1-abcd-1234', 'b2c3d4e5-f6a7-8901-bcde-2345678901bc', 'admin'),
('ws1-abcd-1234', 'c3d4e5f6-a7b8-9012-cdef-3456789012cd', 'member'),
('ws2-bcde-2345', 'b2c3d4e5-f6a7-8901-bcde-2345678901bc', 'owner'),
('ws2-bcde-2345', 'd4e5f6a7-b8c9-0123-def0-4567890123de', 'member'),
('ws3-cdef-3456', 'c3d4e5f6-a7b8-9012-cdef-3456789012cd', 'owner'),
('ws3-cdef-3456', 'a1b2c3d4-e5f6-7890-abcd-1234567890ab', 'member');

-- Demo boards
INSERT INTO boards (id, workspace_id, name, description, type, created_by) VALUES
('board-1', 'ws1-abcd-1234', 'Q1 Marketing Campaign', 'Campaign launch planning and execution', 'kanban', 'a1b2c3d4-e5f6-7890-abcd-1234567890ab'),
('board-2', 'ws2-bcde-2345', 'Sprint 23', 'Current development sprint', 'scrum', 'b2c3d4e5-f6a7-8901-bcde-2345678901bc'),
('board-3', 'ws3-cdef-3456', 'Sales Pipeline Board', 'Active deals and opportunities', 'kanban', 'c3d4e5f6-a7b8-9012-cdef-3456789012cd');

-- Board columns
INSERT INTO board_columns (board_id, name, position, color) VALUES
('board-1', 'Research', 1, '#EF4444'),
('board-1', 'Planning', 2, '#F59E0B'),
('board-1', 'Execution', 3, '#3B82F6'),
('board-1', 'Review', 4, '#10B981'),
('board-2', 'Backlog', 1, '#6B7280'),
('board-2', 'In Progress', 2, '#3B82F6'),
('board-2', 'Code Review', 3, '#8B5CF6'),
('board-2', 'Testing', 4, '#F59E0B'),
('board-2', 'Done', 5, '#10B981'),
('board-3', 'Lead', 1, '#EF4444'),
('board-3', 'Qualified', 2, '#F59E0B'),
('board-3', 'Proposal Sent', 3, '#3B82F6'),
('board-3', 'Negotiation', 4, '#8B5CF6'),
('board-3', 'Closed Won', 5, '#10B981'),
('board-3', 'Closed Lost', 6, '#6B7280');

-- Demo CRM deals
INSERT INTO crm_deals (id, workspace_id, name, deal_value, probability, stage, expected_close_date, company, owner_id, created_by) VALUES
('deal-1', 'ws3-cdef-3456', 'Enterprise SaaS Contract', 45000.00, 75, 'Negotiation', '2026-02-28', 'TechCorp Inc', 'c3d4e5f6-a7b8-9012-cdef-3456789012cd', 'c3d4e5f6-a7b8-9012-cdef-3456789012cd'),
('deal-2', 'ws3-cdef-3456', 'Startup Package', 12000.00, 90, 'Proposal Sent', '2026-02-15', 'StartupXYZ', 'c3d4e5f6-a7b8-9012-cdef-3456789012cd', 'c3d4e5f6-a7b8-9012-cdef-3456789012cd'),
('deal-3', 'ws3-cdef-3456', 'Mid-market Expansion', 28000.00, 60, 'Qualified', '2026-03-15', 'GrowthCo', 'a1b2c3d4-e5f6-7890-abcd-1234567890ab', 'a1b2c3d4-e5f6-7890-abcd-1234567890ab');

-- Demo documents
INSERT INTO docs (id, workspace_id, title, content, plain_text, created_by, parent_id, emoji) VALUES
('doc-1', 'ws1-abcd-1234', 'Marketing Strategy 2026', '{"blocks":[{"type":"paragraph","data":{"text":"Comprehensive marketing strategy for 2026 launch"}}]}', 'Marketing Strategy 2026', 'a1b2c3d4-e5f6-7890-abcd-1234567890ab', NULL, '📈'),
('doc-2', 'ws1-abcd-1234', 'Brand Guidelines', '{"blocks":[{"type":"paragraph","data":{"text":"Official brand colors, fonts, and voice guidelines"}}]}', 'Brand Guidelines', 'b2c3d4e5-f6a7-8901-bcde-2345678901bc', NULL, '🎨'),
('doc-3', 'ws2-bcde-2345', 'Product Roadmap Q1', '{"blocks":[{"type":"paragraph","data":{"text":"Product roadmap for Q1 2026 including feature priorities"}}]}', 'Product Roadmap Q1', 'b2c3d4e5-f6a7-8901-bcde-2345678901bc', NULL, '🗺️');

-- Demo whiteboards
INSERT INTO whiteboards (id, workspace_id, name, description, created_by, is_template) VALUES
('whiteboard-1', 'ws1-abcd-1234', 'Campaign Mind Map', 'Visual brainstorming for Q1 campaign', 'a1b2c3d4-e5f6-7890-abcd-1234567890ab', false),
('whiteboard-2', 'ws2-bcde-2345', 'Feature Planning Board', 'Technical architecture for new features', 'd4e5f6a7-b8c9-0123-def0-4567890123de', false);

-- Demo artifacts (attachments)
INSERT INTO artifacts (id, workspace_id, name, filename, mime_type, file_size, file_url, entity_type, entity_id, created_by) VALUES
('artifact-1', 'ws1-abcd-1234', 'Campaign Mockup.jpg', 'campaign-mockup.jpg', 'image/jpeg', 2456000, 'https://files.paoday.com/workspaces/ws1-abcd-1234/campaign-mockup.jpg', 'doc', 'doc-1', 'a1b2c3d4-e5f6-7890-abcd-1234567890ab'),
('artifact-2', 'ws3-cdef-3456', 'Proposal Template.pdf', 'proposal-template.pdf', 'application/pdf', 89000, 'https://files.paoday.com/workspaces/ws3-cdef-3456/proposal-template.pdf', 'crm_deal', 'deal-1', 'c3d4e5f6-a7b8-9012-cdef-3456789012cd');

-- Demo activity events
INSERT INTO activity_events (workspace_id, actor_id, action, entity_type, entity_name, entity_id) VALUES
('ws1-abcd-1234', 'a1b2c3d4-e5f6-7890-abcd-1234567890ab', 'created', 'board', 'Q1 Marketing Campaign', 'board-1'),
('ws1-abcd-1234', 'a1b2c3d4-e5f6-7890-abcd-1234567890ab', 'created', 'doc', 'Marketing Strategy 2026', 'doc-1'),
('ws3-cdef-3456', 'c3d4e5f6-a7b8-9012-cdef-3456789012cd', 'created', 'crm_deal', 'Enterprise SaaS Contract', 'deal-1');

-- Demo comments
INSERT INTO comments (workspace_id, entity_type, entity_id, content, created_by) VALUES
('ws1-abcd-1234', 'doc', 'doc-1', 'Looking good! Let''s add some metrics to this strategy.', 'b2c3d4e5-f6a7-8901-bcde-2345678901bc'),
('ws3-cdef-3456', 'crm_deal', 'deal-1', 'Customer mentioned budget concerns - need to adjust proposal', 'a1b2c3d4-e5f6-7890-abcd-1234567890ab');