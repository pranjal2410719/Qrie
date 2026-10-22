"use client";

import React from "react";
import Link from "next/link";
import { useCart } from "@/lib/store/cartStore";
import { Button } from "@/components/ui/Button";
import { Trash2, Plus, Minus, ArrowRight, ShoppingBag, ShieldCheck } from "lucide-react";

export function CartView() {
  const { items, total, count, updateQuantity, removeItem, clear, mounted } = useCart();

  if (!mounted) {
    return (
      <div className="py-20 text-center text-slate-500 text-sm">
        Loading cart details...
      </div>
    );
  }

  if (items.length === 0) {
    return (
      <div className="py-20 text-center max-w-md mx-auto space-y-5">
        <div className="w-16 h-16 rounded-3xl bg-slate-100 flex items-center justify-center mx-auto text-slate-400">
          <ShoppingBag className="w-8 h-8" />
        </div>
        <div className="space-y-1.5">
          <h2 className="text-xl font-bold text-slate-900">Your cart is empty</h2>
          <p className="text-xs text-slate-500">
            Explore our verified student apps and diagnostic assessment software.
          </p>
        </div>
        <div className="pt-2">
          <Button href="/products" variant="primary" size="md">
            Browse Products Catalogue
          </Button>
        </div>
      </div>
    );
  }

  const gstAmount = Math.round(total * 0.18);
  const grandTotal = total + gstAmount;

  return (
    <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
      {/* Items List */}
      <div className="lg:col-span-8 bg-white rounded-3xl border border-slate-200 p-6 space-y-6">
        <div className="flex items-center justify-between border-b border-slate-100 pb-4">
          <h2 className="text-lg font-bold text-slate-900">
            Selected Items ({count})
          </h2>
          <button
            onClick={() => clear()}
            className="text-xs text-rose-600 hover:text-rose-700 font-semibold"
          >
            Clear All
          </button>
        </div>

        <div className="divide-y divide-slate-100">
          {items.map((item) => (
            <div key={item.productId} className="py-4 flex items-center justify-between gap-4">
              <div className="space-y-1">
                <h3 className="font-bold text-sm text-slate-900">{item.name}</h3>
                <div className="text-xs text-slate-500">
                  ₹{item.price.toLocaleString("en-IN")}{" "}
                  {item.billingInterval ? `/${item.billingInterval}` : ""}
                </div>
              </div>

              {/* Quantity Controls */}
              <div className="flex items-center gap-3">
                <div className="flex items-center border border-slate-200 rounded-xl bg-slate-50 p-1">
                  <button
                    onClick={() => updateQuantity(item.productId, item.quantity - 1)}
                    className="p-1 rounded-lg hover:bg-white text-slate-600 transition-colors"
                    aria-label="Decrease quantity"
                  >
                    <Minus className="w-3.5 h-3.5" />
                  </button>
                  <span className="px-3 text-xs font-bold text-slate-900">
                    {item.quantity}
                  </span>
                  <button
                    onClick={() => updateQuantity(item.productId, item.quantity + 1)}
                    className="p-1 rounded-lg hover:bg-white text-slate-600 transition-colors"
                    aria-label="Increase quantity"
                  >
                    <Plus className="w-3.5 h-3.5" />
                  </button>
                </div>

                <div className="text-right min-w-[70px]">
                  <span className="font-bold text-sm text-slate-900">
                    ₹{(item.price * item.quantity).toLocaleString("en-IN")}
                  </span>
                </div>

                <button
                  onClick={() => removeItem(item.productId)}
                  className="p-2 text-slate-400 hover:text-rose-600 transition-colors"
                  aria-label="Remove item"
                >
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Order Summary & Checkout */}
      <div className="lg:col-span-4 bg-white rounded-3xl border border-slate-200 p-6 space-y-6">
        <h3 className="text-lg font-bold text-slate-900">Order Summary</h3>

        <div className="space-y-3 text-xs border-b border-slate-100 pb-4">
          <div className="flex items-center justify-between text-slate-600">
            <span>Subtotal</span>
            <span className="font-semibold text-slate-900">
              ₹{total.toLocaleString("en-IN")}
            </span>
          </div>
          <div className="flex items-center justify-between text-slate-600">
            <span>Applicable GST (18%)</span>
            <span className="font-semibold text-slate-900">
              ₹{gstAmount.toLocaleString("en-IN")}
            </span>
          </div>
        </div>

        <div className="flex items-center justify-between text-base font-bold text-slate-900">
          <span>Grand Total</span>
          <span className="text-xl font-black text-sky-600">
            ₹{grandTotal.toLocaleString("en-IN")}
          </span>
        </div>

        <Button
          href="/checkout"
          variant="primary"
          size="lg"
          className="w-full"
          icon={<ArrowRight className="w-4 h-4" />}
        >
          Proceed to Checkout
        </Button>

        <div className="pt-2 text-[11px] text-slate-400 flex items-center justify-center gap-1.5 text-center">
          <ShieldCheck className="w-4 h-4 text-emerald-500 shrink-0" />
          <span>Encrypted payment processing & verified server receipts</span>
        </div>
      </div>
    </div>
  );
}
