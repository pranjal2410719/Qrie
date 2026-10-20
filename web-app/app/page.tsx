import Link from 'next/link';
import { GraduationCap, School, ShieldCheck } from 'lucide-react';

export default function HomePage() {
  return (
    <main className="flex flex-col items-center justify-center min-h-screen px-4 py-12">
      <div className="max-w-xl w-full text-center space-y-6">
        <div className="inline-flex items-center gap-2 px-3 py-1 bg-blue-50 border border-blue-200 text-primary rounded-full text-sm font-medium">
          <ShieldCheck className="w-4 h-4" />
          <span>School-Ready Adaptive Learning</span>
        </div>

        <h1 className="text-4xl font-extrabold tracking-tight text-text">
          Qrie AI Portals
        </h1>
        <p className="text-text-muted text-lg">
          Dedicated portals for Educators and School Administrators.
        </p>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-4">
          <Link
            href="/teacher/dashboard"
            className="flex flex-col items-center p-6 bg-surface border border-border rounded-xl shadow-sm hover:border-primary hover:shadow-md transition text-left"
          >
            <div className="p-3 bg-blue-50 text-primary rounded-lg mb-4">
              <GraduationCap className="w-6 h-6" />
            </div>
            <h2 className="text-xl font-bold text-text mb-1">Teacher Portal</h2>
            <p className="text-sm text-text-muted text-center">
              Monitor student mastery, review struggle indicators, and guide classroom progression.
            </p>
          </Link>

          <Link
            href="/admin/dashboard"
            className="flex flex-col items-center p-6 bg-surface border border-border rounded-xl shadow-sm hover:border-primary hover:shadow-md transition text-left"
          >
            <div className="p-3 bg-purple-50 text-purple-600 rounded-lg mb-4">
              <School className="w-6 h-6" />
            </div>
            <h2 className="text-xl font-bold text-text mb-1">Admin Portal</h2>
            <p className="text-sm text-text-muted text-center">
              Manage school rosters, teachers, grade enrollments, and academic configurations.
            </p>
          </Link>
        </div>
      </div>
    </main>
  );
}
