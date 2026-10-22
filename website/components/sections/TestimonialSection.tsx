import React from "react";
import { EditorialHeadline } from "@/components/ui/EditorialHeadline";
import { Quote, Building } from "lucide-react";

export function TestimonialSection() {
  const testimonials = [
    {
      quote:
        "The struggle heatmaps have completely changed how I begin my morning science classes. Instead of guessing where the class is confused after homework, I immediately know which chemical reaction step needs attention.",
      name: "S. Mukherjee",
      role: "Senior Science Faculty",
      school: "Delhi Public School Partner Cohort",
      type: "Educator Feedback",
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
    <section className="py-20 bg-[#f0f1f2]/50 border-b border-[#f0f1f2]">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <EditorialHeadline
          badge="Verified Educational Feedback"
          title="Trusted by Educators, Parents, and Principals"
          highlightWord="Educators"
          description="Real-world feedback from partner schools and pilot cohorts using the Qrie Learning Adaptation Model."
        />

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {testimonials.map((item, idx) => (
            <div
              key={idx}
              className="p-8 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] flex flex-col justify-between"
            >
              <div className="space-y-4">
                <Quote className="w-7 h-7 text-[#1868db] opacity-40" />
                <p className="text-[14px] text-[#292a2e] leading-[1.6] font-normal italic">
                  &quot;{item.quote}&quot;
                </p>
              </div>

              <div className="pt-6 border-t border-[#f0f1f2] mt-6 space-y-1">
                <div className="font-bold text-[14px] text-[#101214]">{item.name}</div>
                <div className="text-[12px] text-[#42526e]">{item.role}</div>
                <div className="text-[12px] font-medium text-[#1868db] flex items-center gap-1.5 pt-0.5">
                  <Building className="w-3.5 h-3.5 text-[#1868db]" />
                  <span>{item.school}</span>
                </div>
                <div className="text-[11px] text-[#b7b9be] uppercase tracking-wider font-semibold pt-1">
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
