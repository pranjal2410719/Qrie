import { School, Users, GraduationCap, CheckCircle2 } from 'lucide-react';

export default function SchoolOverviewPage() {
  return (
    <div className="space-y-8 max-w-container">
      <section className="space-y-4">
        <h2 className="text-[22px] font-medium text-charcoal">School Overview</h2>
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
              <span className="text-[14px] font-medium">Compliance</span>
              <CheckCircle2 className="w-5 h-5 text-success" />
            </div>
            <p className="text-[32px] font-normal text-charcoal">100%</p>
            <p className="text-[12px] text-success mt-1 tracking-[0.432px]">RLS policies enforced</p>
          </div>
        </div>
      </section>

      <section className="space-y-4">
        <h3 className="text-[18px] font-medium text-charcoal">Academic Year 2026-2027</h3>
        <div className="bg-white border border-mist rounded-3xl p-8">
          <p className="text-[14px] text-slate leading-relaxed">
            Delhi Public School — all grade levels 6 through 12 are active. Faculty assignments, student
            enrolments, and compliance policies are current for the academic year.
          </p>
        </div>
      </section>
    </div>
  );
}
