export default function StudentEnrolmentsPage() {
  const enrolments = [
    { grade: 'Grade 6', sections: 2, students: 72 },
    { grade: 'Grade 7', sections: 2, students: 70 },
    { grade: 'Grade 8', sections: 3, students: 102 },
    { grade: 'Grade 9', sections: 3, students: 98 },
    { grade: 'Grade 10', sections: 2, students: 68 },
    { grade: 'Grade 11', sections: 2, students: 42 },
    { grade: 'Grade 12', sections: 2, students: 28 },
  ];

  return (
    <div className="space-y-8 max-w-container">
      <section className="space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-[22px] font-medium text-charcoal">Student Enrolments</h2>
          <span className="text-[12px] text-slate">{enrolments.reduce((a, b) => a + b.students, 0)} total</span>
        </div>
        <div className="bg-white border border-mist rounded-3xl overflow-hidden">
          <table className="w-full text-left text-[14px]">
            <thead className="bg-canvas border-b border-mist text-slate text-[12px] uppercase font-medium">
              <tr>
                <th className="py-3 px-6">Grade</th>
                <th className="py-3 px-6">Sections</th>
                <th className="py-3 px-6">Students</th>
                <th className="py-3 px-6">Avg per Section</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-mist">
              {enrolments.map((e, idx) => (
                <tr key={idx} className="hover:bg-canvas/50 transition">
                  <td className="py-4 px-6 font-medium text-charcoal">{e.grade}</td>
                  <td className="py-4 px-6 text-slate">{e.sections}</td>
                  <td className="py-4 px-6 text-charcoal">{e.students}</td>
                  <td className="py-4 px-6 text-slate">{Math.round(e.students / e.sections)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
    </div>
  );
}
