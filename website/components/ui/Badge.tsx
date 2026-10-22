import React from "react";

interface BadgeProps {
  children: React.ReactNode;
  variant?: "default" | "primary" | "success" | "warning" | "outline" | "lavender";
  className?: string;
  size?: "sm" | "md";
}

export function Badge({
  children,
  variant = "default",
  className = "",
  size = "md",
}: BadgeProps) {
  const sizeClasses =
    size === "sm"
      ? "px-2.5 py-0.5 text-[11px] leading-[1.2]"
      : "px-3 py-1 text-[13px] leading-[1.29]";

  const variantClasses = {
    // Default Atlassian tag: #42526e text on #f0f1f2 background
    default: "bg-[#f0f1f2] text-[#42526e]",
    // Brand tinted: #1868db text on #e9f2fe background
    primary: "bg-[#e9f2fe] text-[#1868db]",
    // Success: green tint
    success: "bg-[#e3fcef] text-[#006644]",
    // Warning: orange tint
    warning: "bg-[#fff7e6] text-[#974f0c]",
    // Outline: 1px border
    outline: "border border-[#292a2e] text-[#101214] bg-transparent",
    // Lavender editorial tint
    lavender: "bg-[#eed7fc] text-[#101214]",
  }[variant];

  return (
    <span
      className={`inline-flex items-center gap-1.5 rounded-[10000px] font-medium tracking-normal ${sizeClasses} ${variantClasses} ${className}`}
    >
      {children}
    </span>
  );
}
