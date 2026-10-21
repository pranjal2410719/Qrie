import { Plus } from 'lucide-react';
import { BtnFilled } from '@/components/BtnFilled';

export default function TeacherStaffPage() {
  const staff = [
    { name: 'Dr. Ananya Sharma', subject: 'Mathematics (8 & 9)', email: 'a.sharma@dps.edu.in', classes: 2, status: 'Active' },
    { name: 'Vikram Joshi', subject: 'Mathematics (10 & 11)', email: 'v.joshi@dps.edu.in', classes: 3, status: 'Active' },
    { name: 'Pooja Iyer', subject: 'Science (8 & 9)', email: 'p.iyer@dps.edu.in', classes: 2, status: 'Active' },
    { name: 'Rahul Mehta', subject: 'English (8-10)', email: 'r.mehta@dps.edu.in', classes: 4, status: 'On leave' },
  ];

  return (
    <div className="space-y-8 max-w-container">
      <section className="space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-[22px] font-medium text-charcoal">Teacher Staff</h2>
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
              {staff.map((m, idx) => (
                <tr key={idx} className="hover:bg-canvas/50 transition">
                  <td className="py-4 px-6 font-medium text-charcoal">{m.name}</td>
                  <td className="py-4 px-6 text-charcoal">{m.subject}</td>
                  <td className="py-4 px-6 text-slate">{m.email}</td>
                  <td className="py-4 px-6 text-slate">{m.classes} Sections</td>
                  <td className="py-4 px-6">
                    <span
                      className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-[12px] font-medium border ${
                        m.status === 'Active'
                          ? 'bg-green-50 text-success border-green-200'
                          : 'bg-amber-50 text-amber-800 border-amber-200'
                      }`}
                    >
                      {m.status}
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
