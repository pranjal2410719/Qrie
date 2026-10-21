import { Users, BookOpen, AlertTriangle } from 'lucide-react';

export default function AssignedClassesPage() {
  const classes = [
    { id: 'cls_8a', name: 'Class 8-A', subject: 'Mathematics (NCERT)', studentsCount: 34, avgMastery: 74, strugglingCount: 3 },
    { id: 'cls_9b', name: 'Class 9-B', subject: 'Mathematics (NCERT)', studentsCount: 31, avgMastery: 68, strugglingCount: 5 },
    { id: 'cls_10c', name: 'Class 10-C', subject: 'Mathematics (NCERT)', studentsCount: 36, avgMastery: 81, strugglingCount: 2 },
  ];

  return (
    <div className="space-y-8 max-w-container">
      <section className="space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-[22px] font-medium text-charcoal">Assigned Classes</h2>
          <span className="text-[12px] text-slate">{classes.length} sections</span>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
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
                <span className="flex items-center gap-1">
                  <AlertTriangle className="w-3 h-3 text-warning" />
                  {c.strugglingCount} need support
                </span>
                <a
                  href="#!"
                  className="text-google-blue font-medium hover:text-google-blue-deep transition-colors underline underline-offset-2"
                >
                  View Roster →
                </a>
              </div>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
}
