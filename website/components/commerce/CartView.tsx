"use client";

import React from "react";
import { useCart } from "@/lib/store/cartStore";
import { Button } from "@/components/ui/Button";
import { Trash2, Plus, Minus, ArrowRight, ShoppingBag, ShieldCheck } from "lucide-react";

export function CartView() {
  const { items, total, count, updateQuantity, removeItem, clear, mounted } = useCart();

  if (!mounted) {
    return (
      <div className="py-20 text-center text-[#42526e] text-[14px]">
        Loading cart details...
      </div>
    );
  }

  if (items.length === 0) {
    return (
      <div className="py-20 text-center max-w-md mx-auto space-y-5">
        <div className="w-16 h-16 rounded-[20px] bg-[#f0f1f2] flex items-center justify-center mx-auto text-[#42526e]">
          <ShoppingBag className="w-8 h-8" />
        </div>
        <div className="space-y-1.5">
          <h2 className="text-xl font-medium tracking-[0.012em] text-[#101214]">Your cart is empty</h2>
          <p className="text-[14px] text-[#42526e] font-normal">
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
      <div className="lg:col-span-8 bg-white rounded-[20px] border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] p-6 space-y-6">
        <div className="flex items-center justify-between border-b border-[#f0f1f2] pb-4">
          <h2 className="text-lg font-medium text-[#101214]">
            Selected Items ({count})
          </h2>
          <button
            onClick={() => clear()}
            className="text-[13px] text-rose-600 hover:text-rose-700 font-medium"
          >
            Clear All
          </button>
        </div>

        <div className="divide-y divide-[#f0f1f2]">
          {items.map((item) => (
            <div key={item.productId} className="py-4 flex items-center justify-between gap-4">
              <div className="space-y-1">
                <h3 className="font-medium text-[15px] text-[#101214]">{item.name}</h3>
                <div className="text-[13px] text-[#42526e]">
                  ₹{item.price.toLocaleString("en-IN")}{" "}
                  {item.billingInterval ? `/${item.billingInterval}` : ""}
                </div>
              </div>

              {/* Quantity Controls */}
              <div className="flex items-center gap-3">
                <div className="flex items-center border border-[#f0f1f2] rounded-[28px] bg-[#f0f1f2] p-0.5">
                  <button
                    onClick={() => updateQuantity(item.productId, item.quantity - 1)}
                    className="p-1 rounded-full hover:bg-white text-[#42526e] transition-colors"
                    aria-label="Decrease quantity"
                  >
                    <Minus className="w-3.5 h-3.5" />
                  </button>
                  <span className="px-3 text-[13px] font-bold text-[#101214]">
                    {item.quantity}
                  </span>
                  <button
                    onClick={() => updateQuantity(item.productId, item.quantity + 1)}
                    className="p-1 rounded-full hover:bg-white text-[#42526e] transition-colors"
                    aria-label="Increase quantity"
                  >
                    <Plus className="w-3.5 h-3.5" />
                  </button>
                </div>

                <div className="text-right min-w-[70px]">
                  <span className="font-medium text-[15px] text-[#101214]">
                    ₹{(item.price * item.quantity).toLocaleString("en-IN")}
                  </span>
                </div>

                <button
                  onClick={() => removeItem(item.productId)}
                  className="p-2 text-[#42526e] hover:text-rose-600 transition-colors"
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
      <div className="lg:col-span-4 bg-white rounded-[20px] border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] p-6 space-y-6">
        <h3 className="text-lg font-medium text-[#101214]">Order Summary</h3>

        <div className="space-y-3 text-[13px] border-b border-[#f0f1f2] pb-4 font-normal">
          <div className="flex items-center justify-between text-[#42526e]">
            <span>Subtotal</span>
            <span className="font-semibold text-[#101214]">
              ₹{total.toLocaleString("en-IN")}
            </span>
          </div>
          <div className="flex items-center justify-between text-[#42526e]">
            <span>Applicable GST (18%)</span>
            <span className="font-semibold text-[#101214]">
              ₹{gstAmount.toLocaleString("en-IN")}
            </span>
          </div>
        </div>

        <div className="flex items-center justify-between text-base font-medium text-[#101214]">
          <span>Grand Total</span>
          <span className="text-xl font-medium tracking-[0.012em] text-[#1868db]">
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

        <div className="pt-2 text-[12px] text-[#42526e] flex items-center justify-center gap-1.5 text-center font-normal">
          <ShieldCheck className="w-4 h-4 text-[#1868db] shrink-0" />
          <span>Encrypted payment processing & verified server receipts</span>
        </div>
      </div>
    </div>
  );
}
