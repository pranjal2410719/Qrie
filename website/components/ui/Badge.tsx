import React from "react";

interface BadgeProps {
  children: React.ReactNode;
  variant?: "default" | "primary" | "success" | "warning" | "outline" | "accent";
  className?: string;
  size?: "sm" | "md";
}

export function Badge({
  children,
  variant = "default",
  className = "",
  size = "md",
}: BadgeProps) {
  const sizeClasses = size === "sm" ? "px-2 py-0.5 text-xs" : "px-3 py-1 text-xs font-semibold";

  const variantClasses = {
    default: "bg-slate-100 text-slate-800 border border-slate-200",
    primary: "bg-sky-50 text-sky-700 border border-sky-200",
    success: "bg-emerald-50 text-emerald-700 border border-emerald-200",
    warning: "bg-amber-50 text-amber-700 border border-amber-200",
    outline: "border border-slate-300 text-slate-700 bg-transparent",
    accent: "bg-indigo-50 text-indigo-700 border border-indigo-200",
  }[variant];

  return (
    <span
      className={`inline-flex items-center gap-1.5 rounded-full tracking-wide uppercase transition-colors ${sizeClasses} ${variantClasses} ${className}`}
    >
      {children}
    </span>
  );
}
