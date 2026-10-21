import { AlertTriangle, CheckCircle2, TrendingUp, Users } from 'lucide-react';

export default function TeacherDashboardPage() {
  const classes = [
    {
      id: 'cls_8a',
      name: 'Class 8-A',
      subject: 'Mathematics (NCERT)',
      studentsCount: 34,
      avgMastery: 74,
      strugglingCount: 3,
    },
    {
      id: 'cls_9b',
      name: 'Class 9-B',
      subject: 'Mathematics (NCERT)',
      studentsCount: 31,
      avgMastery: 68,
      strugglingCount: 5,
    },
  ];

  const struggleAlerts = [
    {
      student: 'Diya Sharma (Roll 02)',
      class: 'Class 8-A',
      concept: 'Division of Rational Numbers',
      failures: 3,
      misconception: 'Reciprocal sign omission',
      level: 'High Priority',
    },
    {
      student: 'Rohan Mehra (Roll 14)',
      class: 'Class 9-B',
      concept: 'Polynomial Remainder Theorem',
      failures: 2,
      misconception: 'Synthetic division sign flip',
      level: 'Needs Review',
    },
  ];

  return (
    <div className="space-y-8 max-w-container">
      {/* Top metrics */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="p-8 bg-white border border-mist rounded-3xl">
          <div className="flex items-center justify-between text-slate mb-2">
            <span className="text-[14px] font-medium">Total Students Active</span>
            <Users className="w-5 h-5 text-google-blue" />
          </div>
          <p className="text-[32px] font-normal text-charcoal">65</p>
          <p className="text-[12px] text-slate mt-1 tracking-[0.432px]">Across 2 assigned sections</p>
        </div>

        <div className="p-8 bg-white border border-mist rounded-3xl">
          <div className="flex items-center justify-between text-slate mb-2">
            <span className="text-[14px] font-medium">Average Concept Mastery</span>
            <TrendingUp className="w-5 h-5 text-success" />
          </div>
          <p className="text-[32px] font-normal text-charcoal">71.2%</p>
          <p className="text-[12px] text-success mt-1 tracking-[0.432px]">↑ +4.2% since baseline assessment</p>
        </div>

        <div className="p-8 bg-white border border-mist rounded-3xl">
          <div className="flex items-center justify-between text-slate mb-2">
            <span className="text-[14px] font-medium">Struggle Alerts</span>
            <AlertTriangle className="w-5 h-5 text-warning" />
          </div>
          <p className="text-[32px] font-normal text-charcoal">8</p>
          <p className="text-[12px] text-warning mt-1 tracking-[0.432px]">Students flagged for targeted intervention</p>
        </div>
      </div>

      {/* Assigned Classes */}
      <section className="space-y-4">
        <h2 className="text-[22px] font-medium text-charcoal">Assigned Classes</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {classes.map((c) => (
            <div key={c.id} className="p-8 bg-white border border-mist rounded-3xl space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="font-medium text-[18px] text-charcoal">{c.name}</h3>
                  <p className="text-[12px] text-slate">{c.subject}</p>
                </div>
                <span className="px-3 py-1 bg-canvas text-google-blue text-[12px] font-medium rounded-full border border-mist">
                  {c.studentsCount} Students
                </span>
              </div>

              <div>
                <div className="flex justify-between text-[12px] font-medium mb-1 text-slate">
                  <span>Class Mastery</span>
                  <span>{c.avgMastery}%</span>
                </div>
                <div className="w-full bg-mist h-2 rounded-full overflow-hidden">
                  <div
                    className="bg-google-blue h-full rounded-full"
                    style={{ width: `${c.avgMastery}%` }}
                  />
                </div>
              </div>

              <div className="flex items-center justify-between pt-2 border-t border-mist text-[12px] text-slate">
                <span>{c.strugglingCount} students need support</span>
                <a
                  href="#!"
                  className="text-google-blue font-medium hover:text-google-blue-deep transition-colors underline underline-offset-2"
                >
                  View Class Roster →
                </a>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* Misconception & Struggle Indicators */}
      <section className="space-y-4">
        <h2 className="text-[22px] font-medium text-charcoal">Active Learning Interventions</h2>
        <div className="bg-white border border-mist rounded-3xl overflow-hidden">
          <table className="w-full text-left text-[14px]">
            <thead className="bg-canvas border-b border-mist text-slate text-[12px] uppercase font-medium">
              <tr>
                <th className="py-3 px-6">Student</th>
                <th className="py-3 px-6">Class</th>
                <th className="py-3 px-6">Topic / Concept</th>
                <th className="py-3 px-6">Identified Misconception</th>
                <th className="py-3 px-6">Priority</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-mist">
              {struggleAlerts.map((alert, idx) => (
                <tr key={idx} className="hover:bg-canvas/50 transition">
                  <td className="py-4 px-6 font-medium text-charcoal">{alert.student}</td>
                  <td className="py-4 px-6 text-slate">{alert.class}</td>
                  <td className="py-4 px-6 text-charcoal">{alert.concept}</td>
                  <td className="py-4 px-6 text-slate">{alert.misconception}</td>
                  <td className="py-4 px-6">
                    <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-[12px] font-medium bg-amber-50 text-amber-800 border border-amber-200">
                      {alert.level}
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
