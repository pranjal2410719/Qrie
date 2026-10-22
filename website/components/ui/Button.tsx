import React from "react";
import Link from "next/link";

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?:
    | "primary"
    | "secondary"
    | "outline"
    | "ghost"
    | "yellow"
    | "white"
    | "muted"
    | "danger";
  size?: "sm" | "md" | "lg";
  href?: string;
  external?: boolean;
  isLoading?: boolean;
  icon?: React.ReactNode;
}

export function Button({
  children,
  variant = "primary",
  size = "md",
  href,
  external,
  isLoading,
  icon,
  className = "",
  disabled,
  ...props
}: ButtonProps) {
  // Atlassian buttons: flat with zero shadow, pill radius 28px (or 9999px), Charlie Text font-medium
  const baseClasses =
    "inline-flex items-center justify-center font-medium rounded-[28px] transition-colors duration-150 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#1868db] focus-visible:ring-offset-2 active:opacity-90 disabled:opacity-50 disabled:pointer-events-none select-none";

  const sizeClasses = {
    sm: "text-[14px] px-3.5 py-1.5 gap-1.5 leading-[1.25]",
    md: "text-[16px] px-5 py-2.5 gap-2 leading-[1.5]",
    lg: "text-[16px] px-6 py-3 gap-2.5 leading-[1.5]",
  }[size];

  const variantClasses = {
    // Primary: The single chromatic action color #1868db across the system
    primary:
      "bg-[#1868db] text-[#ffffff] hover:bg-[#1557b0] border-0",
    // Yellow: Sporadic CTA alternative strictly for dark hero banners
    yellow:
      "bg-[#fca700] text-[#101214] hover:bg-[#e59700] border-0 font-medium",
    // Secondary: Text-link counterpart with subtle underline on hover
    secondary:
      "bg-transparent text-[#101214] hover:underline border-0",
    // Outline: Clean 1px border with no drop shadow
    outline:
      "border border-[#101214] text-[#101214] bg-transparent hover:bg-[#f0f1f2]",
    // Ghost: Flat interactive control
    ghost:
      "text-[#101214] hover:bg-[#f0f1f2] bg-transparent border-0",
    // White button: For inverted dark panels
    white:
      "bg-[#ffffff] text-[#101214] hover:bg-[#f0f1f2] border-0",
    // Muted / Fog white button
    muted:
      "bg-[#f0f1f2] text-[#101214] hover:bg-[#e4e6e9] border-0",
    // Danger
    danger:
      "bg-rose-600 text-white hover:bg-rose-700 border-0",
  }[variant];

  const combinedClasses = `${baseClasses} ${sizeClasses} ${variantClasses} ${className}`;

  if (href) {
    if (external) {
      return (
        <a
          href={href}
          target="_blank"
          rel="noopener noreferrer"
          className={combinedClasses}
        >
          {icon && <span className="shrink-0">{icon}</span>}
          {children}
        </a>
      );
    }
    return (
      <Link href={href} className={combinedClasses}>
        {icon && <span className="shrink-0">{icon}</span>}
        {children}
      </Link>
    );
  }

  return (
    <button
      className={combinedClasses}
      disabled={disabled || isLoading}
      {...props}
    >
      {isLoading ? (
        <svg
          className="animate-spin -ml-1 mr-2 h-4 w-4 text-current"
          fill="none"
          viewBox="0 0 24 24"
        >
          <circle
            className="opacity-25"
            cx="12"
            cy="12"
            r="10"
            stroke="currentColor"
            strokeWidth="4"
          />
          <path
            className="opacity-75"
            fill="currentColor"
            d="M4 12a8 8 0 018-8v8H4z"
          />
        </svg>
      ) : (
        icon && <span className="shrink-0">{icon}</span>
      )}
      {children}
    </button>
  );
}
