# Paoday.com Database Setup Commands

## Quick Start

### 1. Database Creation
```bash
# Create database
createdb paoday_production

# For development/test
createdb paoday_development
createdb paoday_test
```

### 2. Schema Setup
```bash
# Apply schema
psql -d paoday_development -f database/schema.sql

# Load sample data
gpql -d paoday_development -f database/sample_data.sql
```

### 3. Docker Setup
```bash
# Using Docker Compose
docker run --name paoday-postgres \
  -e POSTGRES_DB=paoday_development \
  -e POSTGRES_USER=paoday \
  -e POSTGRES_PASSWORD=secure_password \
  -p 5432:5432 \
  -d postgres:15

# Make sure PostgreSQL extensions are available for UUIDs
psql -d paoday_development -c "CREATE EXTENSION IF NOT EXISTS pgcrypto;"
```

### 4. Migration Commands
```bash
# Create migration from schema
sequelize migration:generate --name initial_schema

# Run migrations
sequelize db:migrate

# Rollback (if needed)
sequelize db:migrate:undo
```

## Environment Variables

Set these in your `.env` file:

```bash
# Database
DATABASE_URL=postgresql://paoday:secure_password@localhost:5432/paoday_development
DATABASE_TEST_URL=postgresql://paoday:secure_password@localhost:5432/paoday_test
DATABASE_PROD_URL=postgresql://paoday:secure_password@localhost:5432/paoday_production

# Connection options
DB_SSL=false
DB_MAX_CONNS=10
DB_IDLE_TIMEOUT=10000
```

## ORM Configuration

### Sequelize (Node.js)
```javascript
const config = {
  development: {
    url: process.env.DATABASE_URL,
    dialect: 'postgres',
    logging: console.log,
    define: {
      underscored: true,
      timestamps: true
    }
  }
};
```

### Prisma Schema
```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id                String    @id @default(dbgenerated("gen_random_uuid()")) @db.Uuid
  email             String    @unique
  username          String    @unique
  fullName          String    @map("full_name")
  avatarUrl         String?   @map("avatar_url")
  timezone          String    @default("UTC")
  locale            String    @default("en")
  isEmailVerified   Boolean   @default(false) @map("is_email_verified")
  isActive          Boolean   @default(true) @map("is_active")
  lastLoginAt       DateTime? @map("last_login_at")
  createdAt         DateTime  @default(now()) @map("created_at")
  updatedAt         DateTime  @updatedAt @map("updated_at")
  deletedAt         DateTime? @map("deleted_at")

  workspaceMembers  WorkspaceMember[]
  createdBoards     Board[]       @relation("BoardCreator")
  createdDeals      CrmDeal[]     @relation("DealCreator")
  ownedDeals        CrmDeal[]     @relation("DealOwner")
  createdDocs       Doc[]         @relation("DocCreator")
  lastEditedDocs    Doc[]         @relation("DocLastEditor")
  createdWhiteboards Whiteboard[]  @relation("WhiteboardCreator")
  lastEditedWhiteboards Whiteboard[] @relation("WhiteboardLastEditor")
  createdArtifacts  Artifact[]
  activities        ActivityEvent[]
  comments          Comment[]
  
  @@map("users")
}

model Workspace {
  id            String    @id @default(dbgenerated("gen_random_uuid()")) @db.Uuid
  name          String
  slug          String    @unique
  description   String?
  logoUrl       String?   @map("logo_url")
  isPersonal    Boolean   @default(false) @map("is_personal")
  maxMembers    Int       @default(50) @map("max_members")
  planTier      String    @default("free") @map("plan_tier")
  isActive      Boolean   @default(true) @map("is_active")
  createdBy     String    @map("created_by") @db.Uuid
  createdAt     DateTime  @default(now()) @map("created_at")
  updatedAt     DateTime  @updatedAt @map("updated_at")
  archivedAt    DateTime? @map("archived_at")

  creator       User      @relation(fields: [createdBy], references: [id])
  members       WorkspaceMember[]
  boards        Board[]
  deals         CrmDeal[]
  docs          Doc[]
  whiteboards   Whiteboard[]
  artifacts     Artifact[]
  activities    ActivityEvent[]
  comments      Comment[]
  
  @@map("workspaces")
}
```

## Performance Optimization

### Connection Pooling
```bash
# Using pg-pool or similar
POOL_SIZE=20
POOL_MAX_CLIENTS=20
POOL_IDLE_TIMEOUT=30000
```

### Common Queries
```sql
-- Find recent activity in a workspace
SELECT * FROM activity_events 
WHERE workspace_id = ? 
ORDER BY created_at DESC 
LIMIT 50;

-- Search across all entities in a workspace
SELECT entity_type, entity_name, title
FROM search_index 
WHERE workspace_id = ? 
  AND content @@ to_tsquery('english', ?)
ORDER BY updated_at DESC;

-- Get all CRM deals for a user
SELECT * FROM crm_deals 
WHERE workspace_id = ? 
  AND (owner_id = ? OR owner_id IS NULL);
```

## Monitoring

### Query Stats
```sql
-- Monitor slow queries
SELECT query, mean_exec_time, calls 
FROM pg_stat_statements 
WHERE calls > 100 
ORDER BY mean_exec_time DESC 
LIMIT 10;

-- Check table sizes
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables 
WHERE schemaname='public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

## Backup & Restore
```bash
# Backup
pg_dump -h localhost -U paoday -d paoday_development -f backup.sql

# Restore
psql -h localhost -U paoday -d paoday_development -f backup.sql
```