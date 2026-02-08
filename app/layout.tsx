import type { Metadata } from 'next'
import { Geist, Geist_Mono } from 'next/font/google'
import './globals.css'

const geistSans = Geist({
  variable: '--font-geist-sans',
  subsets: ['latin'],
})

const geistMono = Geist_Mono({
  variable: '--font-geist-mono',
  subsets: ['latin'],
})

export const metadata: Metadata = {
  title: 'Paoday CRM - Modern Customer Relationship Management',
  description: 'A powerful, modern CRM system built with Next.js and Supabase for managing customer relationships, workspaces, and business intelligence.',
  keywords: ['CRM', 'customer relationship management', 'business', 'nextjs', 'supabase'],
  authors: [{ name: 'Paoday Team' }],
  creator: 'Paoday',
  metadataBase: new URL(process.env.NEXT_PUBLIC_APP_URL || 'http://localhost:3000'),
  openGraph: {
    type: 'website',
    locale: 'en_US',
    url: process.env.NEXT_PUBLIC_APP_URL || 'http://localhost:3000',
    title: 'Paoday CRM - Modern Customer Relationship Management',
    description: 'A powerful, modern CRM system built with Next.js and Supabase for managing customer relationships, workspaces, and business intelligence.',
    siteName: 'Paoday CRM',
    images: [
      {
        url: '/og-image.png',
        width: 1200,
        height: 630,
        alt: 'Paoday CRM',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Paoday CRM - Modern Customer Relationship Management',
    description: 'A powerful, modern CRM system built with Next.js and Supabase for managing customer relationships, workspaces, and business intelligence.',
    creator: '@paoday',
  },
  icons: {
    icon: [
      { url: '/favicon.ico' },
      { url: '/icon.svg', type: 'image/svg+xml' },
    ],
    apple: [
      { url: '/apple-icon.png' },
    ],
  },
  manifest: '/manifest.json',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head />
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased`}
      >
        {children}
      </body>
    </html>
  )
}