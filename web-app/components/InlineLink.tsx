import Link from 'next/link';
import React from 'react';

type Props = React.AnchorHTMLAttributes<HTMLAnchorElement> & { href: string };

export function InlineLink({ children, className = '', ...props }: Props) {
  return (
    <Link className={`inline-link ${className}`} {...props}>
      {children}
    </Link>
  );
}
