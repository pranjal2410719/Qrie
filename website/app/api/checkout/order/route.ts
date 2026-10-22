import { NextResponse } from "next/server";
import { productsData } from "@/lib/data/products";

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { items, customer, billingAddress } = body;

    if (!items || !Array.isArray(items) || items.length === 0) {
      return NextResponse.json({ error: "Cart is empty." }, { status: 400 });
    }

    if (!customer?.name || !customer?.email) {
      return NextResponse.json(
        { error: "Customer name and email are required for order creation." },
        { status: 400 }
      );
    }

    // SERVER-SIDE PRICE RE-VALIDATION:
    // Never trust client prices. Recompute based on official productsData.
    let serverSubtotal = 0;
    const validatedItems = [];

    for (const item of items) {
      const canonicalProduct = productsData.find((p) => p.slug === item.productId || p.id === item.productId);
      if (!canonicalProduct) {
        return NextResponse.json(
          { error: `Product '${item.productId}' not found in canonical catalog.` },
          { status: 400 }
        );
      }

      if (!canonicalProduct.canAddToCart || !canonicalProduct.startingPrice) {
        return NextResponse.json(
          { error: `Product '${canonicalProduct.name}' requires institutional quotation and cannot be directly purchased online.` },
          { status: 400 }
        );
      }

      const quantity = Math.max(1, parseInt(item.quantity || "1", 10));
      const lineTotal = canonicalProduct.startingPrice * quantity;
      serverSubtotal += lineTotal;

      validatedItems.push({
        productId: canonicalProduct.slug,
        name: canonicalProduct.name,
        unitPrice: canonicalProduct.startingPrice,
        quantity,
        lineTotal,
        currency: "INR",
        billingInterval: canonicalProduct.billingInterval || "one-time",
      });
    }

    // 18% GST standard Indian software tax
    const gstRate = 0.18;
    const taxAmount = Math.round(serverSubtotal * gstRate);
    const grandTotal = serverSubtotal + taxAmount;

    const orderId = `QRIE-ORD-${Date.now().toString(36).toUpperCase()}-${Math.random().toString(36).substring(2, 6).toUpperCase()}`;

    const orderRecord = {
      orderId,
      status: "PENDING_PAYMENT",
      createdAt: new Date().toISOString(),
      currency: "INR",
      subtotal: serverSubtotal,
      taxAmount,
      grandTotal,
      items: validatedItems,
      customer: {
        name: customer.name.trim(),
        email: customer.email.trim().toLowerCase(),
        phone: customer.phone ? customer.phone.trim() : null,
      },
      billingAddress: billingAddress || null,
      paymentGateway: process.env.RAZORPAY_KEY_ID ? "Razorpay" : "TestGateway (Evaluation Mode)",
    };

    console.log("[Qrie Commerce] Order Created:", JSON.stringify(orderRecord));

    return NextResponse.json({
      success: true,
      orderId,
      order: orderRecord,
      keyId: process.env.RAZORPAY_KEY_ID || "rzp_test_qrie_simulation",
      amountInPaise: grandTotal * 100,
    });
  } catch (err: unknown) {
    console.error("Order creation error:", err);
    return NextResponse.json(
      { error: "Failed to initialize order." },
      { status: 500 }
    );
  }
}
