import { Suspense } from 'react'
import Link from 'next/link'

export default function LandingPage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-slate-100 dark:from-slate-900 dark:to-slate-800">
      <header className="relative px-4 lg:px-8 pt-8 pb-12 lg:pt-16 lg:pb-20">
        <div className="relative max-w-7xl mx-auto">
          <div className="text-center">
            <h1 className="text-4xl font-bold tracking-tight text-slate-900 dark:text-slate-100 sm:text-5xl md:text-6xl">
              <span className="block">Modern CRM for</span>
              <span className="block text-indigo-600">Growing Teams</span>
            </h1>
            <p className="mt-3 max-w-md mx-auto text-base text-slate-500 dark:text-slate-400 sm:text-lg md:mt-5 md:text-xl md:max-w-3xl">
              Manage your customer relationships, organize your sales pipeline, and grow your business with confidence. Built on Next.js 14 with the power of Supabase.
            </p>
            
            <div className="mt-5 max-w-md mx-auto sm:flex sm:justify-center md:mt-8">
              <div className="rounded-md shadow">
                <Link
                  href="/signin"
                  className="w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 md:py-4 md:text-lg md:px-10"
                >
                  Get Started
                </Link>
              </div>
              <div className="mt-3 rounded-md shadow sm:mt-0 sm:ml-3">
                <Link
                  href="/features"
                  className="w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-indigo-600 bg-white hover:bg-gray-50 md:py-4 md:text-lg md:px-10"
                >
                  Learn More
                </Link>
              </div>
            </div>
          </div>
        </div>
      </header>

      <section className="py-16 bg-white dark:bg-slate-900 overflow-hidden lg:py-24">
        <div className="relative max-w-xl mx-auto px-4 sm:px-6 lg:px-8 lg:max-w-7xl">
          <div className="relative">
            <div className="text-center">
              <h2 className="text-base font-semibold text-indigo-600 tracking-wide uppercase">
                Features
              </h2>
              <p className="mt-2 text-3xl leading-8 font-extrabold tracking-tight text-slate-900 dark:text-slate-100 sm:text-4xl">
                Everything you need to scale
              </p>
              <p className="mt-4 max-w-2xl text-xl text-slate-500 dark:text-slate-400 lg:mx-auto">
                From lead management to team collaboration, we've got you covered.
              </p>
            </div>

            <div className="mt-12">
              <dl className="space-y-10 md:space-y-0 md:grid md:grid-cols-2 md:gap-x-8 md:gap-y-10">
                {[
                  {
                    name: 'Workspace Management',
                    description: 'Organize your team and projects in dedicated workspaces with granular permissions.',
                    icon: '🏢'
                  },
                  {
                    name: 'Contact & Lead Management',
                    description: 'Track your customer interactions and sales pipeline from first contact to close.',
                    icon: '👥'
                  },
                  {
                    name: 'Artifact Collaboration',
                    description: 'Share documents, notes, and files with your team in real-time.',
                    icon: '📁'
                  },
                  {
                    name: 'Advanced Analytics',
                    description: 'Get insights into your sales performance with detailed analytics and reporting.',
                    icon: '📊'
                  }
                ].map((feature) => (
                  <div key={feature.name} className="relative">
                    <dt>
                      <div className="absolute flex items-center justify-center h-12 w-12 rounded-md bg-indigo-500 text-white">
                        <span className="text-2xl">{feature.icon}</span>
                      </div>
                      <p className="ml-16 text-lg leading-6 font-medium text-slate-900 dark:text-slate-100">
                        {feature.name}
                      </p>
                    </dt>
                    <dd className="mt-2 ml-16 text-base text-slate-500 dark:text-slate-400">
                      {feature.description}
                    </dd>
                  </div>
                ))}
              </dl>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}