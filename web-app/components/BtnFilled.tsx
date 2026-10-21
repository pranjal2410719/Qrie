import React from 'react';

export function BtnFilled({
  children,
  className = '',
  ...props
}: React.ButtonHTMLAttributes<HTMLButtonElement>) {
  return (
    <button className={`btn-filled ${className}`} {...props}>
      {children}
    </button>
  );
}
