import { Plus, Users, GraduationCap, School, CheckCircle2 } from 'lucide-react';
import { BtnFilled } from '@/components/BtnFilled';

export default function AdminDashboardPage() {
  const staff = [
    { name: 'Dr. Ananya Sharma', subject: 'Mathematics (8 & 9)', email: 'a.sharma@dps.edu.in', classes: 2, status: 'Active' },
    { name: 'Vikram Joshi', subject: 'Mathematics (10 & 11)', email: 'v.joshi@dps.edu.in', classes: 3, status: 'Active' },
    { name: 'Pooja Iyer', subject: 'Science (8 & 9)', email: 'p.iyer@dps.edu.in', classes: 2, status: 'Active' },
  ];

  return (
    <div className="space-y-8 max-w-container">
      {/* Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="p-8 bg-white border border-mist rounded-3xl">
          <div className="flex items-center justify-between text-slate mb-2">
            <span className="text-[14px] font-medium">Total Students</span>
            <Users className="w-5 h-5 text-google-blue" />
          </div>
          <p className="text-[32px] font-normal text-charcoal">480</p>
          <p className="text-[12px] text-slate mt-1 tracking-[0.432px]">Grades 6 through 12</p>
        </div>

        <div className="p-8 bg-white border border-mist rounded-3xl">
          <div className="flex items-center justify-between text-slate mb-2">
            <span className="text-[14px] font-medium">Teaching Faculty</span>
            <GraduationCap className="w-5 h-5 text-google-blue" />
          </div>
          <p className="text-[32px] font-normal text-charcoal">32</p>
          <p className="text-[12px] text-slate mt-1 tracking-[0.432px]">Assigned educators</p>
        </div>

        <div className="p-8 bg-white border border-mist rounded-3xl">
          <div className="flex items-center justify-between text-slate mb-2">
            <span className="text-[14px] font-medium">Class Sections</span>
            <School className="w-5 h-5 text-google-blue" />
          </div>
          <p className="text-[32px] font-normal text-charcoal">16</p>
          <p className="text-[12px] text-slate mt-1 tracking-[0.432px]">Sections A through D</p>
        </div>

        <div className="p-8 bg-white border border-mist rounded-3xl">
          <div className="flex items-center justify-between text-slate mb-2">
            <span className="text-[14px] font-medium">Tenant Compliance</span>
            <CheckCircle2 className="w-5 h-5 text-success" />
          </div>
          <p className="text-[32px] font-normal text-charcoal">100%</p>
          <p className="text-[12px] text-success mt-1 tracking-[0.432px]">RLS policies enforced</p>
        </div>
      </div>

      {/* Roster & Quick Actions */}
      <section className="space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-[22px] font-medium text-charcoal">Faculty Roster</h2>
          <BtnFilled>
            <Plus className="w-4 h-4" />
            <span>Invite Teacher</span>
          </BtnFilled>
        </div>

        <div className="bg-white border border-mist rounded-3xl overflow-hidden">
          <table className="w-full text-left text-[14px]">
            <thead className="bg-canvas border-b border-mist text-slate text-[12px] uppercase font-medium">
              <tr>
                <th className="py-3 px-6">Teacher Name</th>
                <th className="py-3 px-6">Assigned Subjects</th>
                <th className="py-3 px-6">Official Email</th>
                <th className="py-3 px-6">Assigned Classes</th>
                <th className="py-3 px-6">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-mist">
              {staff.map((member, idx) => (
                <tr key={idx} className="hover:bg-canvas/50 transition">
                  <td className="py-4 px-6 font-medium text-charcoal">{member.name}</td>
                  <td className="py-4 px-6 text-charcoal">{member.subject}</td>
                  <td className="py-4 px-6 text-slate">{member.email}</td>
                  <td className="py-4 px-6 text-slate">{member.classes} Sections</td>
                  <td className="py-4 px-6">
                    <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-[12px] font-medium bg-green-50 text-success border border-green-200">
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
