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
  School,
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
      className={`sticky top-0 z-50 bg-white border-b border-[#f0f1f2] transition-shadow duration-150 ${
        scrolled ? "shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px]" : ""
      }`}
    >
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-14">
          {/* Logo & Atlassian-style Wordmark */}
          <Link href="/" className="flex items-center gap-2.5 shrink-0 group">
            <div className="relative w-8 h-8 rounded-[8px] overflow-hidden bg-white p-0.5 border border-[#f0f1f2] transition-transform duration-150 group-hover:scale-105">
              <Image
                src="/Q_logo.png"
                alt="Qrie AI Logo"
                fill
                sizes="32px"
                className="object-contain"
                priority
              />
            </div>
            <div className="flex items-baseline gap-1.5">
              <span className="font-semibold text-lg tracking-tight text-[#101214] group-hover:text-[#1868db] transition-colors">
                Qrie
              </span>
              <span className="text-xs font-bold text-[#1868db] uppercase tracking-wider">
                AI
              </span>
            </div>
          </Link>

          {/* Desktop Navigation: Charlie Text 14px weight 400 #101214 */}
          <nav className="hidden lg:flex items-center gap-1">
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
                    className={`px-3 py-1.5 rounded-[20px] text-[14px] font-normal transition-colors ${
                      isActive
                        ? "text-[#1868db] bg-[#e9f2fe] font-medium"
                        : "text-[#101214] hover:bg-[#f0f1f2]"
                    }`}
                  >
                    {item.title}
                  </Link>
                );
              }

              return (
                <div
                  key={item.title}
                  className="relative"
                  onMouseEnter={() => setOpenDropdown(item.title)}
                  onMouseLeave={() => setOpenDropdown(null)}
                >
                  <button
                    className={`flex items-center gap-1 px-3 py-1.5 rounded-[20px] text-[14px] font-normal transition-colors ${
                      isActive
                        ? "text-[#1868db] bg-[#e9f2fe] font-medium"
                        : "text-[#101214] hover:bg-[#f0f1f2]"
                    }`}
                    aria-expanded={openDropdown === item.title}
                  >
                    <span>{item.title}</span>
                    <ChevronDown
                      className={`w-3.5 h-3.5 text-[#42526e] transition-transform duration-150 ${
                        openDropdown === item.title ? "rotate-180 text-[#1868db]" : ""
                      }`}
                    />
                  </button>

                  {/* Dropdown Menu Container (20px radius, subtle navy micro-shadow) */}
                  {openDropdown === item.title && (
                    <div className="absolute top-full left-0 w-80 p-2 bg-white rounded-[20px] border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_2px_4px_0px] z-50">
                      <div className="space-y-1">
                        {item.children?.map((child) => (
                          <Link
                            key={child.href}
                            href={child.href}
                            className="block p-2.5 rounded-[12px] hover:bg-[#f0f1f2] transition-colors group/item"
                          >
                            <div className="flex items-center justify-between">
                              <span className="text-[14px] font-medium text-[#101214] group-hover/item:text-[#1868db] transition-colors">
                                {child.title}
                              </span>
                              {child.badge && (
                                <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-[#e9f2fe] text-[#1868db]">
                                  {child.badge}
                                </span>
                              )}
                            </div>
                            {child.description && (
                              <p className="text-[12px] text-[#42526e] mt-0.5 line-clamp-2 leading-relaxed font-normal">
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

          {/* Right Action Area */}
          <div className="hidden sm:flex items-center gap-3">
            {/* Sign in text-link in #1868db, 14px as in design.md */}
            <Link
              href="/demo"
              className="text-[14px] font-medium text-[#1868db] hover:underline px-2 py-1"
            >
              Sign In
            </Link>

            {/* Cart Icon Button */}
            <Link
              href="/cart"
              className="relative p-2 rounded-full text-[#101214] hover:bg-[#f0f1f2] transition-colors"
              title="View Cart"
            >
              <ShoppingCart className="w-4 h-4 text-[#101214]" />
              {count > 0 && (
                <span className="absolute -top-1 -right-1 bg-[#1868db] text-white text-[10px] font-bold w-4 h-4 rounded-full flex items-center justify-center">
                  {count}
                </span>
              )}
            </Link>

            {/* School Demo Primary Action Button (Pill radius 28px, #1868db) */}
            <Button
              href="/school-demo"
              variant="primary"
              size="sm"
              icon={<School className="w-3.5 h-3.5" />}
            >
              Request School Demo
            </Button>
          </div>

          {/* Mobile Menu Button */}
          <div className="flex items-center gap-2 lg:hidden">
            <Link
              href="/cart"
              className="relative p-2 rounded-full text-[#101214] hover:bg-[#f0f1f2]"
              title="Cart"
            >
              <ShoppingCart className="w-5 h-5 text-[#101214]" />
              {count > 0 && (
                <span className="absolute -top-1 -right-1 bg-[#1868db] text-white text-[10px] font-bold w-4 h-4 rounded-full flex items-center justify-center">
                  {count}
                </span>
              )}
            </Link>

            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="p-2 rounded-[8px] text-[#101214] hover:bg-[#f0f1f2] focus:outline-none"
              aria-label="Toggle navigation menu"
            >
              {mobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Drawer */}
      {mobileMenuOpen && (
        <div className="lg:hidden border-t border-[#f0f1f2] bg-white px-4 pt-3 pb-6 space-y-4 max-h-[calc(100vh-3.5rem)] overflow-y-auto">
          <div className="space-y-1">
            {siteConfig.mainNav.map((item) => {
              if (!item.children) {
                return (
                  <Link
                    key={item.href}
                    href={item.href}
                    className="block px-3 py-2 rounded-[12px] text-[14px] font-medium text-[#101214] hover:bg-[#f0f1f2]"
                  >
                    {item.title}
                  </Link>
                );
              }

              return (
                <div key={item.title} className="py-2">
                  <div className="px-3 text-[11px] font-bold text-[#42526e] uppercase tracking-wider">
                    {item.title}
                  </div>
                  <div className="mt-1 pl-2 space-y-0.5">
                    {item.children.map((child) => (
                      <Link
                        key={child.href}
                        href={child.href}
                        className="block px-3 py-2 rounded-[12px] text-[14px] font-normal text-[#101214] hover:bg-[#f0f1f2]"
                      >
                        <div className="flex items-center justify-between">
                          <span>{child.title}</span>
                          {child.badge && (
                            <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-[#e9f2fe] text-[#1868db]">
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

          <div className="pt-4 border-t border-[#f0f1f2] flex flex-col gap-2">
            <Button href="/school-demo" variant="primary" size="md" className="w-full">
              Request School Demo
            </Button>
            <Button href="/demo" variant="outline" size="md" className="w-full">
              Explore Interactive Demo
            </Button>
          </div>
        </div>
      )}
    </header>
  );
}
