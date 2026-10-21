import { Shield, CheckCircle2 } from 'lucide-react';

export default function AuditCompliancePage() {
  const audits = [
    { item: 'RLS policies enforced', status: 'Pass', detail: 'All tenant tables have row-level security' },
    { item: 'Data encryption at rest', status: 'Pass', detail: 'AES-256 enabled on all storage' },
    { item: 'Audit logging', status: 'Pass', detail: 'All admin actions logged with timestamps' },
    { item: 'GDPR data export', status: 'Pending', detail: 'Export endpoint in development' },
    { item: 'Role-based access', status: 'Pass', detail: 'Teacher/Admin roles separated' },
  ];

  return (
    <div className="space-y-8 max-w-container">
      <section className="space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-[22px] font-medium text-charcoal">Audit & Compliance</h2>
          <span className="text-[12px] text-slate">5 checks</span>
        </div>
        <div className="bg-white border border-mist rounded-3xl overflow-hidden">
          <table className="w-full text-left text-[14px]">
            <thead className="bg-canvas border-b border-mist text-slate text-[12px] uppercase font-medium">
              <tr>
                <th className="py-3 px-6">Check</th>
                <th className="py-3 px-6">Status</th>
                <th className="py-3 px-6">Detail</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-mist">
              {audits.map((a, idx) => (
                <tr key={idx} className="hover:bg-canvas/50 transition">
                  <td className="py-4 px-6 font-medium text-charcoal flex items-center gap-2">
                    <Shield className="w-4 h-4 text-slate" />
                    {a.item}
                  </td>
                  <td className="py-4 px-6">
                    <span
                      className={`inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[12px] font-medium border ${
                        a.status === 'Pass'
                          ? 'bg-green-50 text-success border-green-200'
                          : 'bg-amber-50 text-amber-800 border-amber-200'
                      }`}
                    >
                      <CheckCircle2 className="w-3 h-3" />
                      {a.status}
                    </span>
                  </td>
                  <td className="py-4 px-6 text-slate">{a.detail}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
    </div>
  );
}
