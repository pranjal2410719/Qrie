'use client';
import React, { useEffect, useRef } from 'react';
import { X } from 'lucide-react';
import { BtnFilled } from './BtnFilled';

export function ModalDialog({
  open,
  onClose,
  title = 'Region selection',
  body = 'Select your region to get started.',
}: {
  open: boolean;
  onClose: () => void;
  title?: string;
  body?: string;
}) {
  const modalRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!open) return;
    const prevOverflow = document.body.style.overflow;
    document.body.style.overflow = 'hidden';

    const handleKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        e.preventDefault();
        onClose();
        return;
      }
      if (e.key === 'Tab' && modalRef.current) {
        const focusable = modalRef.current.querySelectorAll<HTMLElement>(
          'a[href], button:not([disabled]), textarea, input, select, [tabindex]:not([tabindex="-1"])'
        );
        if (focusable.length === 0) return;
        const first = focusable[0];
        const last = focusable[focusable.length - 1];
        if (e.shiftKey) {
          if (document.activeElement === first) {
            e.preventDefault();
            last.focus();
          }
        } else {
          if (document.activeElement === last) {
            e.preventDefault();
            first.focus();
          }
        }
      }
    };

    document.addEventListener('keydown', handleKey);
    // focus first focusable
    const firstFocusable = modalRef.current?.querySelector<HTMLElement>(
      'a[href], button:not([disabled]), textarea, input, select, [tabindex]:not([tabindex="-1"])'
    );
    firstFocusable?.focus();

    return () => {
      document.removeEventListener('keydown', handleKey);
      document.body.style.overflow = prevOverflow;
    };
  }, [open, onClose]);

  if (!open) return null;
  return (
    <div
      className="fixed inset-0 z-[51] bg-black/50 backdrop-blur-sm flex items-center justify-center p-6"
      onClick={onClose}
    >
      <div
        ref={modalRef}
        className="max-w-[480px] w-full bg-white rounded-[8px] overflow-hidden"
        onClick={(e) => e.stopPropagation()}
        role="dialog"
        aria-modal="true"
        aria-labelledby="modal-title"
      >
        <div className="p-6 border-b border-mist flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 rounded-md bg-cloud-shadow flex items-center justify-center">
              <span className="text-[14px] font-medium text-charcoal">Q</span>
            </div>
            <span id="modal-title" className="font-display text-[18px] font-medium text-charcoal">{title}</span>
          </div>
          <button
            aria-label="Close modal"
            onClick={onClose}
            className="rounded-full bg-transparent p-1 hover:bg-canvas hover:text-charcoal transition-colors text-slate"
          >
            <X className="w-5 h-5" />
          </button>
        </div>
        <div className="p-6">
          <p className="text-[16px] font-normal text-graphite">{body}</p>
        </div>
        <div className="p-6 flex justify-end gap-4 border-t border-mist">
          <a
            href="#!"
            className="text-[14px] font-medium text-google-blue hover:text-google-blue-deep transition-colors"
          >
            Stay here
          </a>
          <BtnFilled onClick={onClose}>Go</BtnFilled>
        </div>
      </div>
    </div>
  );
}
