# Paoday.com Database Schema

## Overview
This schema supports Paoday.com's all-in-one workspace platform with the following core entities:
- **Users**: Authentication and user management
- **Workspaces**: Multi-workspace support (teams/projects)
- **Boards**: Kanban/project management with cards and columns
- **CRM**: Deals and sales pipeline management
- **Docs**: Document management with rich text editing
- **Whiteboards**: Collaborative visual workspace
- **Artifacts**: File attachments and media management
- **Activity Events**: Comprehensive activity tracking and audit log

## Key Features
1. **Multi-tenancy**: Workspace-based isolation with role-based access
2. **Activity Tracking**: Full audit trail for compliance and user activity
3. **Search**: Full-text search across all content types
4. **Polymorphism**: Generic relationships and attachments
5. **Scalability**: Optimized indexes for performance

## Core Entities

### User Management
- **users**: Core user authentication and profile data
- **workspaces**: Container for all project data
- **workspace_members**: Many-to-many relationship with role-based permissions

### Productivity Tools
- **boards**: Kanban/Scrum boards for project management
- **board_columns**: Lists/stages within boards
- **board_cards**: Individual tasks/items

### CRM
- **crm_deals**: Deal pipeline with customizable stages and custom fields

### Content Creation
- **docs**: Rich text documents with versioning
- **whiteboards**: Collaborative canvas with shapes and connections

### File Management
- **artifacts**: Generic attachment system for all entities

### Social Features
- **comments**: Threaded discussions
- **activity_events**: Comprehensive activity feed and audit log
- **entity_relationships**: Links between different entities (blocks, relates_to)

## Usage Notes
- PostgreSQL-specific features used (UUIDs, JSONB, full-text search)
- Row-level security policies prepared for multi-tenancy
- Triggers maintain timestamps and search indexes automatically
- Polymorphic associations allow flexible relationships between entities