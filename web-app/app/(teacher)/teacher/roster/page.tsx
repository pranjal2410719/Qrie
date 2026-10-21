export default function StudentRosterPage() {
  const students = [
    { name: 'Diya Sharma', roll: '02', cls: 'Class 8-A', mastery: 62, status: 'Needs support' },
    { name: 'Rohan Mehra', roll: '14', cls: 'Class 9-B', mastery: 58, status: 'Needs support' },
    { name: 'Ananya Gupta', roll: '07', cls: 'Class 8-A', mastery: 84, status: 'On track' },
    { name: 'Vikram Singh', roll: '21', cls: 'Class 10-C', mastery: 91, status: 'On track' },
    { name: 'Pooja Iyer', roll: '11', cls: 'Class 9-B', mastery: 73, status: 'On track' },
  ];

  return (
    <div className="space-y-8 max-w-container">
      <section className="space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-[22px] font-medium text-charcoal">Student Roster</h2>
          <span className="text-[12px] text-slate">{students.length} students</span>
        </div>
        <div className="bg-white border border-mist rounded-3xl overflow-hidden">
          <table className="w-full text-left text-[14px]">
            <thead className="bg-canvas border-b border-mist text-slate text-[12px] uppercase font-medium">
              <tr>
                <th className="py-3 px-6">Student Name</th>
                <th className="py-3 px-6">Roll No.</th>
                <th className="py-3 px-6">Class</th>
                <th className="py-3 px-6">Mastery</th>
                <th className="py-3 px-6">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-mist">
              {students.map((s, idx) => (
                <tr key={idx} className="hover:bg-canvas/50 transition">
                  <td className="py-4 px-6 font-medium text-charcoal">{s.name}</td>
                  <td className="py-4 px-6 text-slate">{s.roll}</td>
                  <td className="py-4 px-6 text-charcoal">{s.cls}</td>
                  <td className="py-4 px-6 text-charcoal">{s.mastery}%</td>
                  <td className="py-4 px-6">
                    <span
                      className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-[12px] font-medium border ${
                        s.status === 'Needs support'
                          ? 'bg-amber-50 text-amber-800 border-amber-200'
                          : 'bg-green-50 text-success border-green-200'
                      }`}
                    >
                      {s.status}
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
