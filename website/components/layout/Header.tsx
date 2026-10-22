"use client";

import React, { useState, useEffect } from "react";
import Link from "next/link";
import Image from "next/image";
import { usePathname } from "next/navigation";
import { siteConfig } from "@/lib/seo/siteConfig";
import { useCart } from "@/lib/store/cartStore";
import { Button } from "@/components/ui/Button";
import {
  Menu,
  X,
  ChevronDown,
  ShoppingCart,
  GraduationCap,
  Sparkles,
  School,
  ArrowRight,
  Cpu,
} from "lucide-react";

export function Header() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [openDropdown, setOpenDropdown] = useState<string | null>(null);
  const [scrolled, setScrolled] = useState(false);
  const pathname = usePathname();
  const { count } = useCart();

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 15);
    };
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  // Close menus on route change
  const [prevPathname, setPrevPathname] = useState(pathname);
  if (prevPathname !== pathname) {
    setPrevPathname(pathname);
    setMobileMenuOpen(false);
    setOpenDropdown(null);
  }

  return (
    <header
      className={`sticky top-0 z-50 transition-all duration-200 ${
        scrolled
          ? "bg-white/95 backdrop-blur-md shadow-xs border-b border-slate-200/80"
          : "bg-white border-b border-slate-100"
      }`}
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-20">
          {/* Logo */}
          <Link href="/" className="flex items-center gap-3 shrink-0 group">
            <div className="relative w-10 h-10 rounded-xl overflow-hidden shadow-xs border border-sky-100 group-hover:scale-105 transition-transform duration-200 bg-white p-1">
              <Image
                src="/Q_logo.png"
                alt="Qrie AI Logo"
                fill
                className="object-contain"
                priority
              />
            </div>
            <div className="flex flex-col">
              <span className="font-extrabold text-xl tracking-tight text-slate-900 group-hover:text-sky-600 transition-colors">
                Qrie <span className="text-sky-600">AI</span>
              </span>
              <span className="text-[10px] font-semibold text-slate-400 tracking-wider uppercase -mt-1">
                Adaptive Learning
              </span>
            </div>
          </Link>

          {/* Desktop Navigation */}
          <nav className="hidden lg:flex items-center gap-1.5 xl:gap-2">
            {siteConfig.mainNav.map((item) => {
              const hasChildren = item.children && item.children.length > 0;
              const isActive =
                pathname === item.href ||
                (hasChildren && item.children?.some((c) => pathname.startsWith(c.href)));

              if (!hasChildren) {
                return (
                  <Link
                    key={item.href}
                    href={item.href}
                    className={`px-3.5 py-2 rounded-xl text-sm font-medium transition-colors ${
                      isActive
                        ? "text-sky-600 bg-sky-50/80 font-semibold"
                        : "text-slate-700 hover:text-slate-900 hover:bg-slate-50"
                    }`}
                  >
                    {item.title}
                  </Link>
                );
              }

              return (
                <div
                  key={item.title}
                  className="relative group"
                  onMouseEnter={() => setOpenDropdown(item.title)}
                  onMouseLeave={() => setOpenDropdown(null)}
                >
                  <button
                    className={`flex items-center gap-1.5 px-3.5 py-2 rounded-xl text-sm font-medium transition-colors ${
                      isActive
                        ? "text-sky-600 bg-sky-50/80 font-semibold"
                        : "text-slate-700 hover:text-slate-900 hover:bg-slate-50"
                    }`}
                  >
                    <span>{item.title}</span>
                    <ChevronDown className="w-3.5 h-3.5 opacity-60 group-hover:rotate-180 transition-transform duration-200" />
                  </button>

                  {/* Dropdown Menu */}
                  {openDropdown === item.title && (
                    <div className="absolute top-full left-0 w-80 p-2.5 bg-white rounded-2xl shadow-xl border border-slate-100 animate-in fade-in slide-in-from-top-2 duration-150 z-50">
                      <div className="space-y-1">
                        {item.children?.map((child) => (
                          <Link
                            key={child.href}
                            href={child.href}
                            className="block p-3 rounded-xl hover:bg-slate-50 transition-colors group/item"
                          >
                            <div className="flex items-center justify-between">
                              <span className="font-semibold text-sm text-slate-800 group-hover/item:text-sky-600 transition-colors">
                                {child.title}
                              </span>
                              {child.badge && (
                                <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-sky-100 text-sky-700">
                                  {child.badge}
                                </span>
                              )}
                            </div>
                            {child.description && (
                              <p className="text-xs text-slate-500 mt-0.5 line-clamp-2 leading-relaxed">
                                {child.description}
                              </p>
                            )}
                          </Link>
                        ))}
                      </div>
                    </div>
                  )}
                </div>
              );
            })}
          </nav>

          {/* Action CTAs & Cart */}
          <div className="hidden sm:flex items-center gap-3">
            {/* Cart Icon Button */}
            <Link
              href="/cart"
              className="relative p-2.5 rounded-xl text-slate-700 hover:text-slate-900 hover:bg-slate-100 transition-colors"
              title="View Cart"
            >
              <ShoppingCart className="w-5 h-5" />
              {count > 0 && (
                <span className="absolute -top-1 -right-1 bg-sky-600 text-white text-[10px] font-extrabold w-5 h-5 rounded-full flex items-center justify-center animate-in zoom-in">
                  {count}
                </span>
              )}
            </Link>

            {/* School Demo Primary CTA */}
            <Button
              href="/school-demo"
              variant="primary"
              size="sm"
              icon={<School className="w-4 h-4" />}
            >
              Request School Demo
            </Button>
          </div>

          {/* Mobile Menu Button */}
          <div className="flex items-center gap-2 lg:hidden">
            <Link
              href="/cart"
              className="relative p-2 rounded-xl text-slate-700 hover:bg-slate-100"
              title="Cart"
            >
              <ShoppingCart className="w-5 h-5" />
              {count > 0 && (
                <span className="absolute -top-1 -right-1 bg-sky-600 text-white text-[10px] font-bold w-4 h-4 rounded-full flex items-center justify-center">
                  {count}
                </span>
              )}
            </Link>

            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="p-2 rounded-xl text-slate-700 hover:bg-slate-100 focus:outline-none"
              aria-label="Toggle navigation menu"
            >
              {mobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Drawer Menu */}
      {mobileMenuOpen && (
        <div className="lg:hidden border-t border-slate-200 bg-white px-4 pt-4 pb-6 space-y-4 max-h-[calc(100vh-5rem)] overflow-y-auto">
          <div className="space-y-1">
            {siteConfig.mainNav.map((item) => {
              if (!item.children) {
                return (
                  <Link
                    key={item.href}
                    href={item.href}
                    className="block px-3 py-2.5 rounded-xl text-base font-medium text-slate-800 hover:bg-slate-100"
                  >
                    {item.title}
                  </Link>
                );
              }

              return (
                <div key={item.title} className="py-2">
                  <div className="px-3 text-xs font-bold text-slate-400 uppercase tracking-wider">
                    {item.title}
                  </div>
                  <div className="mt-1 pl-2 space-y-1">
                    {item.children.map((child) => (
                      <Link
                        key={child.href}
                        href={child.href}
                        className="block px-3 py-2 rounded-xl text-sm font-medium text-slate-700 hover:bg-slate-50"
                      >
                        <div className="flex items-center justify-between">
                          <span>{child.title}</span>
                          {child.badge && (
                            <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-sky-100 text-sky-700">
                              {child.badge}
                            </span>
                          )}
                        </div>
                      </Link>
                    ))}
                  </div>
                </div>
              );
            })}
          </div>

          <div className="pt-4 border-t border-slate-100 flex flex-col gap-2.5">
            <Button href="/school-demo" variant="primary" className="w-full">
              Request School Demo
            </Button>
            <Button href="/get-a-quote" variant="outline" className="w-full">
              Get a Custom Quote
            </Button>
            <Button href="/demo" variant="ghost" className="w-full">
              Explore Interactive Demo
            </Button>
          </div>
        </div>
      )}
    </header>
  );
}
