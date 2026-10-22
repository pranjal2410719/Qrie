import { NextResponse } from "next/server";

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { name, email, subject, category, message } = body;

    if (!name || !email || !message) {
      return NextResponse.json(
        { error: "Name, email, and message are required." },
        { status: 400 }
      );
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return NextResponse.json(
        { error: "Please provide a valid email address." },
        { status: 400 }
      );
    }

    const ticketId = `QRIE-TICKET-${Date.now().toString(36).toUpperCase()}`;

    const contactRecord = {
      ticketId,
      status: "OPEN",
      createdAt: new Date().toISOString(),
      sender: {
        name: name.trim(),
        email: email.trim().toLowerCase(),
      },
      category: category || "General Inquiry",
      subject: subject ? subject.trim() : "Website Contact",
      message: message.trim(),
    };

    console.log("[Qrie Contact Desk] New Inquiry Received:", JSON.stringify(contactRecord));

    return NextResponse.json({
      success: true,
      ticketId,
      message:
        "Thank you for contacting Qrie AI. Your message has been received and a member of our team will respond within 24 hours.",
    });
  } catch (err: unknown) {
    console.error("Contact API error:", err);
    return NextResponse.json(
      { error: "Failed to submit inquiry. Please try again or reach out to support@qrie.ai." },
      { status: 500 }
    );
  }
}
