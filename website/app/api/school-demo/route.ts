import { NextResponse } from "next/server";

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { name, email, phone, schoolName, city, gradeLevels, preferredDate, comments } = body;

    if (!name || !email || !schoolName || !city) {
      return NextResponse.json(
        { error: "Name, email, school name, and city are required to schedule a demonstration." },
        { status: 400 }
      );
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return NextResponse.json(
        { error: "Please provide a valid work or school email address." },
        { status: 400 }
      );
    }

    const demoRef = `QRIE-DEMO-${Date.now().toString(36).toUpperCase()}`;

    const demoRecord = {
      reference: demoRef,
      status: "SCHEDULED_PENDING_CONFIRMATION",
      createdAt: new Date().toISOString(),
      applicant: {
        name: name.trim(),
        email: email.trim().toLowerCase(),
        phone: phone ? phone.trim() : null,
        schoolName: schoolName.trim(),
        city: city.trim(),
        gradeLevels: gradeLevels || "Classes 6–10",
      },
      preferredDate: preferredDate || "Next Available",
      comments: comments ? comments.trim() : null,
    };

    console.log("[Qrie School Demo] Scheduled Demonstration Request:", JSON.stringify(demoRecord));

    return NextResponse.json({
      success: true,
      reference: demoRef,
      message:
        "Your institutional demonstration has been scheduled. A Qrie academic deployment specialist will reach out to confirm your virtual or on-campus walk-through.",
      record: demoRecord,
    });
  } catch (err: unknown) {
    console.error("School Demo API error:", err);
    return NextResponse.json(
      { error: "Failed to schedule demonstration. Please try again or email us directly." },
      { status: 500 }
    );
  }
}
