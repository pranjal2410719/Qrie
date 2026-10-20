import './globals.css';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Qrie AI — School Learning Platform',
  description: 'Teacher and School Admin Portals for Qrie AI',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="min-h-screen antialiased bg-surface-subtle text-text">
        {children}
      </body>
    </html>
  );
}
