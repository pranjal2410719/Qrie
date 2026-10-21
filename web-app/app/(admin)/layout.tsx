import Link from 'next/link';
import { School, Users, GraduationCap, Settings, Shield, LogOut, Menu } from 'lucide-react';
import { BrandMark } from '@/components/BrandMark';

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex min-h-screen bg-canvas">
      {/* Hamburger toggle (CSS-only) */}
      <input type="checkbox" id="admin-sidebar-toggle" className="peer hidden" />

      {/* Hamburger button */}
      <label
        htmlFor="admin-sidebar-toggle"
        className="md:hidden fixed top-4 left-4 z-[51] w-10 h-10 rounded-full bg-white border border-mist flex items-center justify-center text-slate cursor-pointer hover:bg-canvas transition-colors"
        aria-label="Toggle navigation"
      >
        <Menu className="w-5 h-5" />
      </label>

      {/* Overlay */}
      <label
        htmlFor="admin-sidebar-toggle"
        className="md:hidden fixed inset-0 bg-black/50 z-40 hidden peer-checked:block cursor-pointer"
        aria-hidden="true"
      />

      {/* Sidebar */}
      <aside className="fixed md:static top-0 left-0 z-50 w-64 h-screen bg-white border-r border-mist p-6 flex flex-col justify-between transform -translate-x-full md:translate-x-0 peer-checked:translate-x-0 transition-transform duration-200">
        <div className="space-y-6 mt-12 md:mt-0">
          <div className="flex items-center gap-2">
            <BrandMark name="Qrie" />
            <span className="text-[10px] px-2 py-0.5 bg-canvas text-graphite font-medium rounded-full border border-mist">
              ADMIN
            </span>
          </div>

          <nav className="space-y-1">
            <Link
              href="/admin/dashboard"
              className="flex items-center gap-3 px-3 py-2 text-[14px] font-medium rounded-lg bg-canvas text-google-blue"
            >
              <School className="w-4 h-4" />
              <span>School Overview</span>
            </Link>
            <Link
              href="/admin/dashboard"
              className="flex items-center gap-3 px-3 py-2 text-[14px] font-normal rounded-lg text-slate hover:bg-canvas hover:text-charcoal"
            >
              <GraduationCap className="w-4 h-4" />
              <span>Teacher Staff</span>
            </Link>
            <Link
              href="/admin/dashboard"
              className="flex items-center gap-3 px-3 py-2 text-[14px] font-normal rounded-lg text-slate hover:bg-canvas hover:text-charcoal"
            >
              <Users className="w-4 h-4" />
              <span>Student Enrolments</span>
            </Link>
            <Link
              href="/admin/dashboard"
              className="flex items-center gap-3 px-3 py-2 text-[14px] font-normal rounded-lg text-slate hover:bg-canvas hover:text-charcoal"
            >
              <Shield className="w-4 h-4" />
              <span>Audit & Compliance</span>
            </Link>
          </nav>
        </div>

        <div className="pt-6 border-t border-mist flex items-center justify-between">
          <div className="text-[12px]">
            <p className="font-medium text-charcoal">Rajesh Varma</p>
            <p className="text-slate">School Administrator</p>
          </div>
          <Link href="/" className="text-slate hover:text-danger">
            <LogOut className="w-4 h-4" />
          </Link>
        </div>
      </aside>

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col">
        <header className="h-16 bg-white border-b border-mist flex items-center justify-between px-8 pl-16 md:pl-8">
          <h1 className="text-[18px] font-medium text-charcoal">School Administration Portal</h1>
          <div className="flex items-center gap-2 text-[12px] text-slate">
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
