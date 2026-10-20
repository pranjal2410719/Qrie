import Link from 'next/link';
import { School, Users, GraduationCap, Settings, Shield, LogOut } from 'lucide-react';

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex min-h-screen">
      {/* Sidebar */}
      <aside className="w-64 bg-surface border-r border-border p-6 flex flex-col justify-between">
        <div className="space-y-6">
          <div className="flex items-center gap-2">
            <span className="font-extrabold text-2xl text-purple-600 tracking-tight">Qrie</span>
            <span className="text-xs px-2 py-0.5 bg-purple-100 text-purple-700 font-bold rounded">ADMIN</span>
          </div>

          <nav className="space-y-1">
            <Link
              href="/admin/dashboard"
              className="flex items-center gap-3 px-3 py-2 text-sm font-medium rounded-lg bg-purple-50 text-purple-700"
            >
              <School className="w-4 h-4" />
              <span>School Overview</span>
            </Link>
            <Link
              href="/admin/dashboard"
              className="flex items-center gap-3 px-3 py-2 text-sm font-medium rounded-lg text-text-muted hover:bg-surface-subtle"
            >
              <GraduationCap className="w-4 h-4" />
              <span>Teacher Staff</span>
            </Link>
            <Link
              href="/admin/dashboard"
              className="flex items-center gap-3 px-3 py-2 text-sm font-medium rounded-lg text-text-muted hover:bg-surface-subtle"
            >
              <Users className="w-4 h-4" />
              <span>Student Enrolments</span>
            </Link>
            <Link
              href="/admin/dashboard"
              className="flex items-center gap-3 px-3 py-2 text-sm font-medium rounded-lg text-text-muted hover:bg-surface-subtle"
            >
              <Shield className="w-4 h-4" />
              <span>Audit & Compliance</span>
            </Link>
          </nav>
        </div>

        <div className="pt-6 border-t border-border flex items-center justify-between">
          <div className="text-xs">
            <p className="font-semibold text-text">Rajesh Varma</p>
            <p className="text-text-muted">School Administrator</p>
          </div>
          <Link href="/" className="text-text-muted hover:text-danger">
            <LogOut className="w-4 h-4" />
          </Link>
        </div>
      </aside>

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col">
        <header className="h-16 bg-surface border-b border-border flex items-center justify-between px-8">
          <h1 className="text-lg font-bold text-text">School Administration Portal</h1>
          <div className="flex items-center gap-2 text-xs text-text-muted">
            <span className="w-2 h-2 rounded-full bg-success"></span>
            <span>Delhi Public School — Academic Year 2026-2027</span>
          </div>
        </header>

        <main className="flex-1 p-8 overflow-y-auto">
          {children}
        </main>
      </div>
    </div>
  );
}
