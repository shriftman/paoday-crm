/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    serverActions: true,
  },
  images: {
    domains: ['localhost', 'avatars.githubusercontent.com', 'lh3.googleusercontent.com'],
    unoptimized: true // Disable next/image optimization for Netlify Free tier to save bandwidth
  },
  env: {
    SUPABASE_URL: process.env.NEXT_PUBLIC_SUPABASE_URL,
    SUPABASE_ANON_KEY: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY,
  },
  output: 'export',
  trailingSlash: true,
  skipTrailingSlashRedirect: true, // Allow trailing slashes for Netlify compatibility
  distDir: '.next',
  
  // Netlify Free tier optimizations
  generateBuildId: async () => {
    // Ensure consistent builds for better caching
    return new Date().toISOString().split('T')[0]
  },
}

module.exports = nextConfig