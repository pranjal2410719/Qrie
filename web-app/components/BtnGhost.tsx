import React from 'react';

export function BtnGhost({
  children,
  className = '',
  ...props
}: React.ButtonHTMLAttributes<HTMLButtonElement>) {
  return (
    <button className={`btn-ghost ${className}`} {...props}>
      {children}
    </button>
  );
}
