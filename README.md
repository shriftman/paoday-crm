# Paoday CRM

Paoday CRM is a modern customer relationship management system built with Next.js 14, TypeScript, and Supabase.

## Features

- **Workspaces**: Multi-tenant workspace management for different teams or clients
- **Contact Management**: Track customer contacts with detailed information
- **Lead Tracking**: Manage your sales pipeline from prospect to close
- **Artifact Management**: Store and share documents, notes, and files
- **Team Collaboration**: Invite team members with role-based permissions
- **Real-time Updates**: Built on Supabase for real-time data synchronization

## Tech Stack

- **Frontend**: Next.js 14 with TypeScript
- **Database**: PostgreSQL with Supabase
- **Authentication**: Supabase Auth with Row Level Security
- **Styling**: Tailwind CSS
- **Components**: Custom UI components with Radix UI primitives

## Getting Started

### Prerequisites

- Node.js 18+
- Supabase CLI
- PostgreSQL 15+ (for local development)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/[YOUR_USERNAME]/paoday-crm.git
   cd paoday-crm
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Set up environment variables:
   ```bash
   cp .env.example .env.local
   ```
   Fill in your Supabase project details.

4. Set up the database:
   ```bash
   supabase init
   supabase db start
   supabase db reset
   ```

5. Start the development server:
   ```bash
   npm run dev
   ```

## Database Schema

### Core Tables

- **users**: User profiles (extends auth.users)
- **workspaces**: Workspace/organization management
- **workspace_users**: User-workspace relationships
- **workspace_roles**: Role definitions and permissions per workspace
- **contacts**: Customer contact information
- **leads**: Sales opportunities and pipeline
- **artifacts**: Documents, notes, files, and other attachments

### Security Features

- **Row Level Security (RLS)**: Multi-tenant data isolation
- **Role-based Access Control**: Granular permissions per workspace
- **Foreign Key Constraints**: Data integrity
- **Comprehensive Indexing**: Optimized queries

## API Routes

The application uses Next.js server actions for most operations with direct database access via Supabase client.

## Development Commands

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run db-generate` - Generate TypeScript types from database
- `npm run db-reset` - Reset database with fresh schema
- `npm run db-start` - Start Supabase local development
- `npm run db-stop` - Stop Supabase local development

## Environment Variables

Create a `.env.local` file with:

```bash
NEXT_PUBLIC_SUPABASE_URL=your-supabase-project-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
SUPABASE_PROJECT_ID=your-supabase-project-id
```

## License

MIT License - see LICENSE file for details.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Support

For questions, issues, or contributions, please create an issue on GitHub or reach out to the maintainers.