import { Plus, Users, GraduationCap, School, CheckCircle2 } from 'lucide-react';

export default function AdminDashboardPage() {
  const staff = [
    { name: 'Dr. Ananya Sharma', subject: 'Mathematics (8 & 9)', email: 'a.sharma@dps.edu.in', classes: 2, status: 'Active' },
    { name: 'Vikram Joshi', subject: 'Mathematics (10 & 11)', email: 'v.joshi@dps.edu.in', classes: 3, status: 'Active' },
    { name: 'Pooja Iyer', subject: 'Science (8 & 9)', email: 'p.iyer@dps.edu.in', classes: 2, status: 'Active' },
  ];

  return (
    <div className="space-y-8 max-w-6xl">
      {/* Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <div className="p-6 bg-surface border border-border rounded-xl shadow-sm">
          <div className="flex items-center justify-between text-text-muted mb-2">
            <span className="text-sm font-medium">Total Students</span>
            <Users className="w-5 h-5 text-purple-600" />
          </div>
          <p className="text-3xl font-extrabold text-text">480</p>
          <p className="text-xs text-text-muted mt-1">Grades 6 through 12</p>
        </div>

        <div className="p-6 bg-surface border border-border rounded-xl shadow-sm">
          <div className="flex items-center justify-between text-text-muted mb-2">
            <span className="text-sm font-medium">Teaching Faculty</span>
            <GraduationCap className="w-5 h-5 text-purple-600" />
          </div>
          <p className="text-3xl font-extrabold text-text">32</p>
          <p className="text-xs text-text-muted mt-1">Assigned educators</p>
        </div>

        <div className="p-6 bg-surface border border-border rounded-xl shadow-sm">
          <div className="flex items-center justify-between text-text-muted mb-2">
            <span className="text-sm font-medium">Class Sections</span>
            <School className="w-5 h-5 text-purple-600" />
          </div>
          <p className="text-3xl font-extrabold text-text">16</p>
          <p className="text-xs text-text-muted mt-1">Sections A through D</p>
        </div>

        <div className="p-6 bg-surface border border-border rounded-xl shadow-sm">
          <div className="flex items-center justify-between text-text-muted mb-2">
            <span className="text-sm font-medium">Tenant Compliance</span>
            <CheckCircle2 className="w-5 h-5 text-success" />
          </div>
          <p className="text-3xl font-extrabold text-text">100%</p>
          <p className="text-xs text-success mt-1">RLS policies enforced</p>
        </div>
      </div>

      {/* Roster & Quick Actions */}
      <section className="space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-xl font-bold text-text">Faculty Roster</h2>
          <button className="inline-flex items-center gap-2 px-4 py-2 bg-purple-600 hover:bg-purple-700 text-white rounded-lg text-sm font-semibold transition shadow-sm">
            <Plus className="w-4 h-4" />
            <span>Invite Teacher</span>
          </button>
        </div>

        <div className="bg-surface border border-border rounded-xl overflow-hidden shadow-sm">
          <table className="w-full text-left text-sm">
            <thead className="bg-surface-subtle border-b border-border text-text-muted text-xs uppercase font-semibold">
              <tr>
                <th className="py-3 px-6">Teacher Name</th>
                <th className="py-3 px-6">Assigned Subjects</th>
                <th className="py-3 px-6">Official Email</th>
                <th className="py-3 px-6">Assigned Classes</th>
                <th className="py-3 px-6">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {staff.map((member, idx) => (
                <tr key={idx} className="hover:bg-surface-subtle/50 transition">
                  <td className="py-4 px-6 font-medium text-text">{member.name}</td>
                  <td className="py-4 px-6 text-text">{member.subject}</td>
                  <td className="py-4 px-6 text-text-muted">{member.email}</td>
                  <td className="py-4 px-6 text-text-muted">{member.classes} Sections</td>
                  <td className="py-4 px-6">
                    <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold bg-green-100 text-green-800">
                      {member.status}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
    </div>
  );
}
