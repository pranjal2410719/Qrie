const concepts = [
  'Rational Numbers',
  'Polynomials',
  'Linear Equations',
  'Quadratic Eq.',
  'Triangles',
];

const students = ['Diya S.', 'Rohan M.', 'Ananya G.', 'Vikram S.', 'Pooja I.'];

const heat = [
  [62, 45, 78, 55, 80],
  [58, 72, 60, 48, 65],
  [84, 88, 90, 76, 82],
  [91, 85, 89, 92, 87],
  [73, 68, 75, 70, 78],
];

function cellColor(v: number) {
  if (v >= 85) return 'bg-success/20 text-success';
  if (v >= 70) return 'bg-google-blue/15 text-google-blue';
  if (v >= 55) return 'bg-warning/20 text-amber-800';
  return 'bg-danger/15 text-danger';
}

export default function MasteryHeatmapPage() {
  return (
    <div className="space-y-8 max-w-container">
      <section className="space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-[22px] font-medium text-charcoal">Mastery Heatmap</h2>
          <span className="text-[12px] text-slate">Concept × Student</span>
        </div>
        <div className="bg-white border border-mist rounded-3xl overflow-hidden p-6">
          <div className="overflow-x-auto">
            <table className="w-full text-left text-[12px]">
              <thead>
                <tr>
                  <th className="py-2 px-3 text-slate font-medium">Concept</th>
                  {students.map((s) => (
                    <th key={s} className="py-2 px-3 text-slate font-medium text-center">
                      {s}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody className="divide-y divide-mist">
                {concepts.map((c, i) => (
                  <tr key={c}>
                    <td className="py-2 px-3 font-medium text-charcoal">{c}</td>
                    {heat[i].map((v, j) => (
                      <td key={j} className="py-2 px-3 text-center">
                        <span className={`inline-block w-10 h-8 rounded-md leading-8 font-medium ${cellColor(v)}`}>
                          {v}%
                        </span>
                      </td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <div className="flex items-center gap-4 mt-4 text-[12px] text-slate">
            <span className="flex items-center gap-1">
              <span className="w-3 h-3 rounded bg-success/20" /> ≥85
            </span>
            <span className="flex items-center gap-1">
              <span className="w-3 h-3 rounded bg-google-blue/15" /> 70-84
            </span>
            <span className="flex items-center gap-1">
              <span className="w-3 h-3 rounded bg-warning/20" /> 55-69
            </span>
            <span className="flex items-center gap-1">
              <span className="w-3 h-3 rounded bg-danger/15" /> &lt;55
            </span>
          </div>
        </div>
      </section>
    </div>
  );
}
