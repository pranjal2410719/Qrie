import React from "react";
import Link from "next/link";

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "primary" | "secondary" | "outline" | "ghost" | "danger" | "white";
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
  const baseClasses =
    "inline-flex items-center justify-center font-medium rounded-xl transition-all duration-200 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-sky-500 focus-visible:ring-offset-2 active:scale-[0.98] disabled:opacity-50 disabled:pointer-events-none disabled:active:scale-100";

  const sizeClasses = {
    sm: "text-xs px-3.5 py-1.5 gap-1.5",
    md: "text-sm px-5 py-2.5 gap-2",
    lg: "text-base px-7 py-3.5 gap-2.5 shadow-sm",
  }[size];

  const variantClasses = {
    primary:
      "bg-sky-600 text-white hover:bg-sky-700 shadow-sm shadow-sky-600/20 active:bg-sky-800",
    secondary:
      "bg-slate-900 text-white hover:bg-slate-800 shadow-sm shadow-slate-900/10 active:bg-slate-950",
    outline:
      "border border-slate-300 text-slate-800 bg-white hover:bg-slate-50 hover:border-slate-400",
    ghost:
      "text-slate-700 hover:bg-slate-100 hover:text-slate-900 bg-transparent",
    danger:
      "bg-rose-600 text-white hover:bg-rose-700 active:bg-rose-800",
    white:
      "bg-white text-slate-900 hover:bg-slate-100 shadow-sm shadow-black/10",
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
