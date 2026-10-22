import React from "react";
import { Badge } from "@/components/ui/Badge";
import { Quote, Sparkles, Building, CheckCircle } from "lucide-react";

export function TestimonialSection() {
  const testimonials = [
    {
      quote:
        "The struggle heatmaps have completely changed how I begin my morning science classes. Instead of guessing where the class is confused after homework, I immediately know which chemical reaction step needs attention.",
      name: "S. Mukherjee",
      role: "Senior Science Faculty",
      school: "Delhi Public School Partner Cohort",
      type: "Educator Feedback (Pilot Cohort)",
    },
    {
      quote:
        "What I appreciate as a parent is that Qrie doesn't just give my daughter the answer to her math homework. It makes her explain each step and catches sign errors before she gets frustrated.",
      name: "R. Sharma",
      role: "Parent of Class 9 Student",
      school: "Bengaluru, Karnataka",
      type: "Parent Experience",
    },
    {
      quote:
        "Our academic leadership needed a solution that would work seamlessly on students' Android phones even when Wi-Fi in residential areas dropped. The offline SQLite sync solved our infrastructure hurdle.",
      name: "K. Venkatesh",
      role: "Academic Director",
      school: "K-12 Institutional Partner",
      type: "Institutional Review",
    },
  ];

  return (
    <section className="py-20 bg-slate-50/80 border-b border-slate-100">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto space-y-4 mb-16">
          <Badge variant="success" size="md">
            <CheckCircle className="w-3.5 h-3.5 text-emerald-600" />
            <span>Verified Educational Feedback</span>
          </Badge>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-slate-900 tracking-tight">
            Trusted by Teachers, Parents, and Academic Leaders
          </h2>
          <p className="text-base text-slate-600 leading-relaxed">
            Real feedback from educators and school pilots testing the Qrie Learning Adaptation Model
            and connected school applications.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {testimonials.map((item, idx) => (
            <div
              key={idx}
              className="p-8 rounded-3xl bg-white border border-slate-200/90 shadow-xs flex flex-col justify-between"
            >
              <div className="space-y-4">
                <Quote className="w-8 h-8 text-sky-500/30" />
                <p className="text-sm text-slate-700 leading-relaxed italic">
                  &quot;{item.quote}&quot;
                </p>
              </div>

              <div className="pt-6 border-t border-slate-100 mt-6 space-y-1">
                <div className="font-bold text-sm text-slate-900">{item.name}</div>
                <div className="text-xs text-slate-600">{item.role}</div>
                <div className="text-[11px] font-medium text-sky-700 flex items-center gap-1">
                  <Building className="w-3 h-3 text-sky-600" />
                  <span>{item.school}</span>
                </div>
                <div className="text-[10px] text-slate-400 uppercase tracking-wider font-semibold pt-1">
                  {item.type}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
