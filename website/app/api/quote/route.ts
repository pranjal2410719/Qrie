import { NextResponse } from "next/server";

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const {
      name,
      email,
      phone,
      organization,
      role,
      productOrService,
      studentCount,
      timeline,
      requirements,
    } = body;

    // Strict validation
    if (!name || !email || !organization || !productOrService) {
      return NextResponse.json(
        { error: "Name, email, school/organization, and product/service of interest are required." },
        { status: 400 }
      );
    }

    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return NextResponse.json(
        { error: "Please provide a valid educational or institutional email address." },
        { status: 400 }
      );
    }

    // Generate unique authoritative quote reference
    const timestamp = Date.now().toString(36).toUpperCase();
    const randomSuffix = Math.random().toString(36).substring(2, 6).toUpperCase();
    const quoteReference = `QRIE-QUOTE-${timestamp}-${randomSuffix}`;

    const quoteRecord = {
      reference: quoteReference,
      status: "RECEIVED_PENDING_REVIEW",
      createdAt: new Date().toISOString(),
      customer: {
        name: name.trim(),
        email: email.trim().toLowerCase(),
        phone: phone ? phone.trim() : null,
        organization: organization.trim(),
        role: role ? role.trim() : "Administrator",
      },
      requestDetails: {
        productOrService,
        studentCount: studentCount ? Number(studentCount) : null,
        timeline: timeline || "Within 30 days",
        requirements: requirements ? requirements.trim() : null,
      },
    };

    // Log internally for sales / CRM dispatch
    console.log("[Qrie Quote System] New Quote Request Generated:", JSON.stringify(quoteRecord));

    return NextResponse.json({
      success: true,
      quoteReference,
      status: "RECEIVED_PENDING_REVIEW",
      message:
        "Your quotation request has been securely registered. Our institutional academic team will review your student population requirements and send a formal proposal within 1 business day.",
      record: quoteRecord,
    });
  } catch (err: unknown) {
    console.error("Quote API processing error:", err);
    return NextResponse.json(
      { error: "Internal server error while recording quotation request." },
      { status: 500 }
    );
  }
}
