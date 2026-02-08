import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'

export default async function DashboardPage() {
  const supabase = createClient()
  
  const { data: { user } } = await supabase.auth.getUser()
  
  if (!user) {
    redirect('/signin')
  }

  // Fetch user's workspaces
  const { data: workspaces } = await supabase
    .from('workspaces')
    .select('*, workspace_users!inner(*)')
    .eq('workspace_users.user_id', user.id)

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-900">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <h1 className="text-3xl font-bold text-slate-900 dark:text-slate-100">
          Welcome to Paoday CRM
        </h1>
        
        <div className="mt-8">
          <h2 className="text-xl font-semibold text-slate-800 dark:text-slate-200 mb-4">
            Your Workspaces
          </h2>
          
          {workspaces && workspaces.length > 0 ? (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {workspaces.map((workspace) => (
                <div key={workspace.id} className="bg-white dark:bg-slate-800 rounded-lg shadow p-6">
                  <h3 className="text-lg font-semibold text-slate-900 dark:text-slate-100">
                    {workspace.name}
                  </h3>
                  <p className="text-slate-600 dark:text-slate-400 mt-2">
                    {workspace.description || 'No description provided'}
                  </p>
                  <p className="text-sm text-slate-500 dark:text-slate-500 mt-4">
                    Role: {workspace.workspace_users?.[0]?.role_id || 'Member'}
                  </p>
                </div>
              ))}
            </div>
          ) : (
            <p className="text-slate-600 dark:text-slate-400">
              You haven't been invited to any workspaces yet.
            </p>
          )}
        </div>
      </div>
    </div>
  )
}