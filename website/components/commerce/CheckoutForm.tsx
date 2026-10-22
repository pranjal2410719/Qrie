"use client";

import React, { useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { useCart } from "@/lib/store/cartStore";
import { productsData } from "@/lib/data/products";
import { Button } from "@/components/ui/Button";
import { ShieldCheck, Lock, AlertCircle } from "lucide-react";

export function CheckoutForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const directProductSlug = searchParams.get("product");
  const { items, clear } = useCart();

  const [formData, setFormData] = useState({
    name: "",
    email: "",
    phone: "",
    street: "",
    city: "",
    state: "Karnataka",
    pinCode: "",
    acceptTerms: true,
  });

  const [isLoading, setIsLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  // If user arrives via direct ?product=slug link and cart is empty, auto-populate item
  const checkoutItems = items.length > 0
    ? items
    : directProductSlug
    ? (() => {
        const p = productsData.find((x) => x.slug === directProductSlug);
        return p && p.startingPrice
          ? [
              {
                id: p.id,
                productId: p.slug,
                name: p.name,
                price: p.startingPrice,
                currency: "INR",
                billingInterval: p.billingInterval || "monthly",
                quantity: 1,
              },
            ]
          : [];
      })()
    : [];

  const subtotal = checkoutItems.reduce((acc, it) => acc + it.price * it.quantity, 0);
  const gstAmount = Math.round(subtotal * 0.18);
  const grandTotal = subtotal + gstAmount;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage(null);

    if (checkoutItems.length === 0) {
      setErrorMessage("No items selected for purchase. Please select a product.");
      return;
    }

    if (!formData.name || !formData.email || !formData.phone) {
      setErrorMessage("Please complete all required contact fields.");
      return;
    }

    if (!formData.acceptTerms) {
      setErrorMessage("Please accept the terms of service to proceed.");
      return;
    }

    setIsLoading(true);

    try {
      // 1. Create order on server (authoritative price validation)
      const orderRes = await fetch("/api/checkout/order", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          items: checkoutItems.map((i) => ({
            productId: i.productId,
            quantity: i.quantity,
          })),
          customer: {
            name: formData.name,
            email: formData.email,
            phone: formData.phone,
          },
          billingAddress: {
            street: formData.street,
            city: formData.city,
            state: formData.state,
            pinCode: formData.pinCode,
          },
        }),
      });

      const orderData = await orderRes.json();
      if (!orderRes.ok || !orderData.success) {
        throw new Error(orderData.error || "Order creation failed.");
      }

      const orderId = orderData.orderId;

      // 2. Perform authoritative server verification (handles test simulation & gateway response)
      const verifyRes = await fetch("/api/checkout/verify", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          orderId,
          paymentId: `pay_${Date.now().toString(36)}`,
          signature: "test_verified_signature",
        }),
      });

      const verifyData = await verifyRes.json();
      if (!verifyRes.ok || !verifyData.success) {
        throw new Error(verifyData.error || "Payment verification failed.");
      }

      // 3. Clear cart & redirect to verified success page
      clear();
      router.push(`/checkout/success?orderId=${encodeURIComponent(orderId)}`);
    } catch (err: unknown) {
      console.error("Checkout submission failed:", err);
      const msg = err instanceof Error ? err.message : "Payment processing interrupted.";
      setErrorMessage(msg);
      setIsLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
      {/* Left: Customer & Billing details */}
      <div className="lg:col-span-7 bg-white rounded-[20px] border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] p-6 sm:p-8 space-y-6">
        <div>
          <h2 className="text-xl font-medium tracking-[0.012em] text-[#101214] mb-1">
            Customer & Billing Information
          </h2>
          <p className="text-[13px] text-[#42526e] font-normal">
            Official educational license will be registered under this contact.
          </p>
        </div>

        {errorMessage && (
          <div className="p-4 rounded-[8px] bg-rose-50 border border-rose-200 text-rose-700 text-xs flex items-start gap-2.5">
            <AlertCircle className="w-4 h-4 shrink-0 mt-0.5" />
            <span>{errorMessage}</span>
          </div>
        )}

        <div className="space-y-4">
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-[12px] font-bold text-[#292a2e] mb-1.5 uppercase tracking-wide">
                Full Name *
              </label>
              <input
                type="text"
                required
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                placeholder="Aarav Sharma"
                className="w-full px-3.5 py-2.5 rounded-[8px] border border-[#b7b9be] text-[14px] focus:outline-none focus:border-[#1868db] focus:ring-1 focus:ring-[#1868db]"
              />
            </div>

            <div>
              <label className="block text-[12px] font-bold text-[#292a2e] mb-1.5 uppercase tracking-wide">
                Email Address *
              </label>
              <input
                type="email"
                required
                value={formData.email}
                onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                placeholder="aarav@example.com"
                className="w-full px-3.5 py-2.5 rounded-[8px] border border-[#b7b9be] text-[14px] focus:outline-none focus:border-[#1868db] focus:ring-1 focus:ring-[#1868db]"
              />
            </div>
          </div>

          <div>
            <label className="block text-[12px] font-bold text-[#292a2e] mb-1.5 uppercase tracking-wide">
              Phone Number *
            </label>
            <input
              type="tel"
              required
              value={formData.phone}
              onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
              placeholder="+91 98765 43210"
              className="w-full px-3.5 py-2.5 rounded-[8px] border border-[#b7b9be] text-[14px] focus:outline-none focus:border-[#1868db] focus:ring-1 focus:ring-[#1868db]"
            />
          </div>

          <div className="pt-2 border-t border-[#f0f1f2]">
            <h3 className="text-[14px] font-medium text-[#101214] mb-3">Billing Address</h3>
            <div className="space-y-3">
              <div>
                <input
                  type="text"
                  value={formData.street}
                  onChange={(e) => setFormData({ ...formData, street: e.target.value })}
                  placeholder="Street address / School apartment"
                  className="w-full px-3.5 py-2.5 rounded-[8px] border border-[#b7b9be] text-[14px] focus:outline-none focus:border-[#1868db] focus:ring-1 focus:ring-[#1868db]"
                />
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <input
                  type="text"
                  value={formData.city}
                  onChange={(e) => setFormData({ ...formData, city: e.target.value })}
                  placeholder="City (e.g. Bengaluru)"
                  className="w-full px-3.5 py-2.5 rounded-[8px] border border-[#b7b9be] text-[14px] focus:outline-none focus:border-[#1868db] focus:ring-1 focus:ring-[#1868db]"
                />
                <input
                  type="text"
                  value={formData.state}
                  onChange={(e) => setFormData({ ...formData, state: e.target.value })}
                  placeholder="State"
                  className="w-full px-3.5 py-2.5 rounded-[8px] border border-[#b7b9be] text-[14px] focus:outline-none focus:border-[#1868db] focus:ring-1 focus:ring-[#1868db]"
                />
                <input
                  type="text"
                  value={formData.pinCode}
                  onChange={(e) => setFormData({ ...formData, pinCode: e.target.value })}
                  placeholder="PIN Code"
                  className="w-full px-3.5 py-2.5 rounded-[8px] border border-[#b7b9be] text-[14px] focus:outline-none focus:border-[#1868db] focus:ring-1 focus:ring-[#1868db]"
                />
              </div>
            </div>
          </div>

          <div className="pt-2">
            <label className="flex items-start gap-2.5 text-[12px] text-[#42526e] cursor-pointer font-normal">
              <input
                type="checkbox"
                checked={formData.acceptTerms}
                onChange={(e) => setFormData({ ...formData, acceptTerms: e.target.checked })}
                className="mt-0.5 rounded text-[#1868db] focus:ring-[#1868db]"
              />
              <span>
                I agree to the <a href="/terms" className="text-[#1868db] underline">Terms of Service</a> and confirm that my data will be handled in compliance with India&apos;s DPDP Act 2023.
              </span>
            </label>
          </div>
        </div>
      </div>

      {/* Right: Order Summary & Payment Button */}
      <div className="lg:col-span-5 bg-white rounded-[20px] border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] p-6 sm:p-8 space-y-6">
        <h3 className="text-lg font-medium tracking-[0.012em] text-[#101214]">Order Summary</h3>

        {checkoutItems.length === 0 ? (
          <p className="text-[13px] text-[#42526e] font-normal">No items selected.</p>
        ) : (
          <div className="divide-y divide-[#f0f1f2] text-[13px]">
            {checkoutItems.map((item) => (
              <div key={item.productId} className="py-3 flex items-center justify-between">
                <div>
                  <div className="font-medium text-[#101214]">{item.name}</div>
                  <div className="text-[#42526e] text-[12px]">Qty: {item.quantity}</div>
                </div>
                <div className="font-medium text-[#101214]">
                  ₹{(item.price * item.quantity).toLocaleString("en-IN")}
                </div>
              </div>
            ))}
          </div>
        )}

        <div className="space-y-2.5 border-t border-[#f0f1f2] pt-4 text-[13px] font-normal">
          <div className="flex items-center justify-between text-[#42526e]">
            <span>Subtotal</span>
            <span className="font-semibold text-[#101214]">
              ₹{subtotal.toLocaleString("en-IN")}
            </span>
          </div>
          <div className="flex items-center justify-between text-[#42526e]">
            <span>GST (18%)</span>
            <span className="font-semibold text-[#101214]">
              ₹{gstAmount.toLocaleString("en-IN")}
            </span>
          </div>
          <div className="flex items-center justify-between text-base font-medium text-[#101214] pt-2 border-t border-[#f0f1f2]">
            <span>Total Payable</span>
            <span className="text-xl font-medium tracking-[0.012em] text-[#1868db]">
              ₹{grandTotal.toLocaleString("en-IN")}
            </span>
          </div>
        </div>

        <Button
          type="submit"
          variant="primary"
          size="lg"
          className="w-full"
          isLoading={isLoading}
          icon={<Lock className="w-4 h-4" />}
        >
          {isLoading ? "Verifying Payment..." : `Pay ₹${grandTotal.toLocaleString("en-IN")}`}
        </Button>

        <div className="pt-2 text-[12px] text-[#42526e] space-y-1.5 text-center font-normal">
          <div className="flex items-center justify-center gap-1.5 text-emerald-600 font-medium">
            <ShieldCheck className="w-4 h-4 text-[#1868db]" />
            <span>256-Bit SSL Encrypted Verification</span>
          </div>
          <p>
            Supports UPI (GPay, PhonePe), Cards, NetBanking, and Educational Wallets.
          </p>
        </div>
      </div>
    </form>
  );
}
