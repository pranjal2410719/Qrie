import { NextResponse } from "next/server";
import crypto from "crypto";

// In-memory set of processed event IDs to prevent duplicate webhook processing
const processedEventIds = new Set<string>();

export async function POST(request: Request) {
  try {
    const rawBody = await request.text();
    const signature = request.headers.get("x-razorpay-signature");
    const webhookSecret = process.env.RAZORPAY_WEBHOOK_SECRET;

    if (webhookSecret && signature) {
      const expectedSignature = crypto
        .createHmac("sha256", webhookSecret)
        .update(rawBody)
        .digest("hex");

      if (expectedSignature !== signature) {
        console.warn("[Qrie Webhook] Invalid webhook signature detected.");
        return NextResponse.json({ error: "Invalid signature" }, { status: 400 });
      }
    }

    const payload = JSON.parse(rawBody);
    const eventId = payload.event_id || payload.id || `evt_${Date.now()}`;

    // Idempotency check: don't process duplicate events
    if (processedEventIds.has(eventId)) {
      console.log(`[Qrie Webhook] Event ${eventId} already processed. Skipping duplicate.`);
      return NextResponse.json({ status: "already_processed" });
    }

    processedEventIds.add(eventId);

    // Keep processed event cache bounded
    if (processedEventIds.size > 1000) {
      const firstKey = processedEventIds.values().next().value;
      if (firstKey) processedEventIds.delete(firstKey);
    }

    const eventType = payload.event || "payment.captured";
    console.log(`[Qrie Webhook] Successfully processed event: ${eventType} (ID: ${eventId})`);

    return NextResponse.json({ status: "ok", processed: true, eventId });
  } catch (err: unknown) {
    console.error("Webhook processing error:", err);
    return NextResponse.json({ error: "Webhook error" }, { status: 500 });
  }
}
