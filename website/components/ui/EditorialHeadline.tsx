import React from "react";

interface EditorialHeadlineProps {
  badge?: string;
  badgeIcon?: React.ReactNode;
  title: string;
  highlightWord?: string;
  description?: string;
  align?: "center" | "left";
  className?: string;
  theme?: "light" | "dark";
}

export function EditorialHeadline({
  badge,
  badgeIcon,
  title,
  highlightWord,
  description,
  align = "center",
  className = "",
  theme = "light",
}: EditorialHeadlineProps) {
  const isDark = theme === "dark";

  // Split title if highlightWord is present
  const renderTitle = () => {
    if (!highlightWord || !title.includes(highlightWord)) {
      return title;
    }

    const parts = title.split(highlightWord);
    return (
      <>
        {parts[0]}
        <span className="relative inline-block whitespace-nowrap">
          <span>{highlightWord}</span>
          {/* Signature Atlassian Taxicab Yellow Hand-drawn Scribble */}
          <svg
            className="absolute -bottom-1.5 left-0 w-full h-3 text-[#fca700] overflow-visible pointer-events-none"
            viewBox="0 0 100 12"
            fill="none"
            preserveAspectRatio="none"
            aria-hidden="true"
          >
            <path
              d="M1 9.5 C 24 3.5, 52 11.5, 99 5 C 68 8, 38 7, 6 10.5"
              stroke="currentColor"
              strokeWidth="3.2"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
          </svg>
        </span>
        {parts.slice(1).join(highlightWord)}
      </>
    );
  };

  return (
    <div
      className={`space-y-3.5 ${
        align === "center" ? "text-center mx-auto" : "text-left"
      } ${className}`}
    >
      {badge && (
        <div>
          <span
            className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-[13px] font-medium leading-[1.29] ${
              isDark
                ? "bg-[#1c2b42] text-[#fca700]"
                : "bg-[#f0f1f2] text-[#42526e]"
            }`}
          >
            {badgeIcon && <span className="shrink-0">{badgeIcon}</span>}
            <span>{badge}</span>
          </span>
        </div>
      )}

      <h2
        className={`text-3xl sm:text-4xl lg:text-[44px] font-medium tracking-[0.012em] leading-[1.17] ${
          isDark ? "text-white" : "text-[#101214]"
        }`}
      >
        {renderTitle()}
      </h2>

      {description && (
        <p
          className={`text-base leading-[1.5] max-w-[620px] font-normal ${
            align === "center" ? "mx-auto" : ""
          } ${isDark ? "text-[#b7b9be]" : "text-[#42526e]"}`}
        >
          {description}
        </p>
      )}
    </div>
  );
}
