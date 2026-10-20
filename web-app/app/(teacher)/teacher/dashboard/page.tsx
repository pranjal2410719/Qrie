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
    <div className="space-y-8 max-w-6xl">
      {/* Top metrics */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="p-6 bg-surface border border-border rounded-xl shadow-sm">
          <div className="flex items-center justify-between text-text-muted mb-2">
            <span className="text-sm font-medium">Total Students Active</span>
            <Users className="w-5 h-5 text-primary" />
          </div>
          <p className="text-3xl font-extrabold text-text">65</p>
          <p className="text-xs text-text-muted mt-1">Across 2 assigned sections</p>
        </div>

        <div className="p-6 bg-surface border border-border rounded-xl shadow-sm">
          <div className="flex items-center justify-between text-text-muted mb-2">
            <span className="text-sm font-medium">Average Concept Mastery</span>
            <TrendingUp className="w-5 h-5 text-success" />
          </div>
          <p className="text-3xl font-extrabold text-text">71.2%</p>
          <p className="text-xs text-success mt-1">↑ +4.2% since baseline assessment</p>
        </div>

        <div className="p-6 bg-surface border border-border rounded-xl shadow-sm">
          <div className="flex items-center justify-between text-text-muted mb-2">
            <span className="text-sm font-medium">Struggle Alerts</span>
            <AlertTriangle className="w-5 h-5 text-warning" />
          </div>
          <p className="text-3xl font-extrabold text-text">8</p>
          <p className="text-xs text-warning mt-1">Students flagged for targeted intervention</p>
        </div>
      </div>

      {/* Assigned Classes */}
      <section className="space-y-4">
        <h2 className="text-xl font-bold text-text">Assigned Classes</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {classes.map((c) => (
            <div key={c.id} className="p-6 bg-surface border border-border rounded-xl shadow-sm space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="font-bold text-lg text-text">{c.name}</h3>
                  <p className="text-xs text-text-muted">{c.subject}</p>
                </div>
                <span className="px-3 py-1 bg-blue-50 text-primary text-xs font-semibold rounded-full">
                  {c.studentsCount} Students
                </span>
              </div>

              <div>
                <div className="flex justify-between text-xs font-medium mb-1">
                  <span>Class Mastery</span>
                  <span>{c.avgMastery}%</span>
                </div>
                <div className="w-full bg-border h-2 rounded-full overflow-hidden">
                  <div
                    className="bg-primary h-full rounded-full"
                    style={{ width: `${c.avgMastery}%` }}
                  />
                </div>
              </div>

              <div className="flex items-center justify-between pt-2 border-t border-border text-xs text-text-muted">
                <span>{c.strugglingCount} students need support</span>
                <button className="text-primary font-semibold hover:underline">
                  View Class Roster →
                </button>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* Misconception & Struggle Indicators */}
      <section className="space-y-4">
        <h2 className="text-xl font-bold text-text">Active Learning Interventions</h2>
        <div className="bg-surface border border-border rounded-xl overflow-hidden shadow-sm">
          <table className="w-full text-left text-sm">
            <thead className="bg-surface-subtle border-b border-border text-text-muted text-xs uppercase font-semibold">
              <tr>
                <th className="py-3 px-6">Student</th>
                <th className="py-3 px-6">Class</th>
                <th className="py-3 px-6">Topic / Concept</th>
                <th className="py-3 px-6">Identified Misconception</th>
                <th className="py-3 px-6">Priority</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {struggleAlerts.map((alert, idx) => (
                <tr key={idx} className="hover:bg-surface-subtle/50 transition">
                  <td className="py-4 px-6 font-medium text-text">{alert.student}</td>
                  <td className="py-4 px-6 text-text-muted">{alert.class}</td>
                  <td className="py-4 px-6 text-text">{alert.concept}</td>
                  <td className="py-4 px-6 text-text-muted">{alert.misconception}</td>
                  <td className="py-4 px-6">
                    <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold bg-amber-100 text-amber-800">
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
