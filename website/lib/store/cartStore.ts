"use client";

import { useSyncExternalStore } from "react";

export interface CartItem {
  id: string;
  productId: string;
  name: string;
  price: number;
  currency: string;
  billingInterval?: "monthly" | "annually" | "one-time";
  quantity: number;
  image?: string;
}

const CART_STORAGE_KEY = "qrie_cart_v1";

let listeners: Array<() => void> = [];
let memoryCart: CartItem[] = [];
let initialized = false;

function loadFromStorage(): CartItem[] {
  if (typeof window === "undefined") return [];
  try {
    const raw = localStorage.getItem(CART_STORAGE_KEY);
    if (raw) {
      return JSON.parse(raw);
    }
  } catch (err) {
    console.error("Failed to load cart from storage:", err);
  }
  return [];
}

function persistCart(items: CartItem[]) {
  memoryCart = items;
  if (typeof window !== "undefined") {
    try {
      localStorage.setItem(CART_STORAGE_KEY, JSON.stringify(items));
    } catch (err) {
      console.error("Failed to persist cart:", err);
    }
  }
  listeners.forEach((listener) => listener());
}

export const cartStore = {
  getItems(): CartItem[] {
    if (!initialized && typeof window !== "undefined") {
      memoryCart = loadFromStorage();
      initialized = true;
    }
    return memoryCart;
  },

  addItem(item: Omit<CartItem, "quantity"> & { quantity?: number }) {
    const current = this.getItems();
    const existingIndex = current.findIndex((i) => i.productId === item.productId);

    if (existingIndex > -1) {
      const updated = [...current];
      updated[existingIndex].quantity += item.quantity || 1;
      persistCart(updated);
    } else {
      persistCart([...current, { ...item, quantity: item.quantity || 1 }]);
    }
  },

  removeItem(productId: string) {
    const current = this.getItems();
    persistCart(current.filter((i) => i.productId !== productId));
  },

  updateQuantity(productId: string, quantity: number) {
    if (quantity <= 0) {
      this.removeItem(productId);
      return;
    }
    const current = this.getItems();
    const updated = current.map((i) =>
      i.productId === productId ? { ...i, quantity } : i
    );
    persistCart(updated);
  },

  clear() {
    persistCart([]);
  },

  getTotal(): number {
    return this.getItems().reduce((acc, item) => acc + item.price * item.quantity, 0);
  },

  getItemCount(): number {
    return this.getItems().reduce((acc, item) => acc + item.quantity, 0);
  },
};

const EMPTY_ITEMS: CartItem[] = [];

function subscribe(callback: () => void) {
  listeners.push(callback);
  return () => {
    listeners = listeners.filter((l) => l !== callback);
  };
}

export function useCart() {
  const items = useSyncExternalStore(
    subscribe,
    () => cartStore.getItems(),
    () => EMPTY_ITEMS
  );

  const total = items.reduce((acc, item) => acc + item.price * item.quantity, 0);
  const count = items.reduce((acc, item) => acc + item.quantity, 0);

  return {
    items,
    total,
    count,
    addItem: (item: Omit<CartItem, "quantity"> & { quantity?: number }) => cartStore.addItem(item),
    removeItem: (productId: string) => cartStore.removeItem(productId),
    updateQuantity: (productId: string, qty: number) => cartStore.updateQuantity(productId, qty),
    clear: () => cartStore.clear(),
    mounted: true,
  };
}
