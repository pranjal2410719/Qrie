import Link from 'next/link';
import { BookOpen, Users, BarChart3, Bell, LogOut } from 'lucide-react';

export default function TeacherLayout({
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
            <span className="font-extrabold text-2xl text-primary tracking-tight">Qrie</span>
            <span className="text-xs px-2 py-0.5 bg-blue-100 text-primary font-bold rounded">TEACHER</span>
          </div>

          <nav className="space-y-1">
            <Link
              href="/teacher/dashboard"
              className="flex items-center gap-3 px-3 py-2 text-sm font-medium rounded-lg bg-blue-50 text-primary"
            >
              <BookOpen className="w-4 h-4" />
              <span>Assigned Classes</span>
            </Link>
            <Link
              href="/teacher/dashboard"
              className="flex items-center gap-3 px-3 py-2 text-sm font-medium rounded-lg text-text-muted hover:bg-surface-subtle"
            >
              <Users className="w-4 h-4" />
              <span>Student Roster</span>
            </Link>
            <Link
              href="/teacher/dashboard"
              className="flex items-center gap-3 px-3 py-2 text-sm font-medium rounded-lg text-text-muted hover:bg-surface-subtle"
            >
              <BarChart3 className="w-4 h-4" />
              <span>Mastery Heatmap</span>
            </Link>
          </nav>
        </div>

        <div className="pt-6 border-t border-border flex items-center justify-between">
          <div className="text-xs">
            <p className="font-semibold text-text">Dr. Ananya Sharma</p>
            <p className="text-text-muted">Math Department</p>
          </div>
          <Link href="/" className="text-text-muted hover:text-danger">
            <LogOut className="w-4 h-4" />
          </Link>
        </div>
      </aside>

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col">
        <header className="h-16 bg-surface border-b border-border flex items-center justify-between px-8">
          <h1 className="text-lg font-bold text-text">Classroom Intelligence Dashboard</h1>
          <div className="flex items-center gap-4">
            <button className="p-2 text-text-muted hover:text-text rounded-full hover:bg-surface-subtle">
              <Bell className="w-5 h-5" />
            </button>
          </div>
        </header>

        <main className="flex-1 p-8 overflow-y-auto">
          {children}
        </main>
      </div>
    </div>
  );
}
