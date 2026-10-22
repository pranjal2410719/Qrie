import type { Metadata, Viewport } from "next";
import { Suspense } from "react";
import "./globals.css";
import { Header } from "@/components/layout/Header";
import { Footer } from "@/components/layout/Footer";
import { siteConfig } from "@/lib/seo/siteConfig";
import { generateOrganizationSchema, generateWebSiteSchema } from "@/lib/seo/jsonLd";

export const viewport: Viewport = {
  themeColor: "#1868db",
  width: "device-width",
  initialScale: 1,
};

export const metadata: Metadata = {
  metadataBase: new URL(siteConfig.url),
  title: {
    default: "Qrie AI — Adaptive Learning Platform & Learning Adaptation Model",
    template: "%s | Qrie AI",
  },
  description: siteConfig.description,
  keywords: [
    "Qrie AI",
    "Learning Adaptation Model",
    "LAM",
    "Bayesian Knowledge Tracing",
    "NCERT AI Tutor",
    "CBSE Class 10 Learning App",
    "School Education Platform",
    "Adaptive Learning India",
    "Teacher Co-Pilot Software",
    "Offline Education App Android",
    "DPDP Act 2023 Compliant LMS",
    "Bengaluru EdTech",
    "K-12 STEM Education India",
  ],
  authors: [{ name: "Qrie Learning Technologies", url: siteConfig.url }],
  creator: "Qrie Learning Technologies",
  publisher: "Qrie Learning Technologies",
  icons: {
    icon: "/Q_logo.png",
    apple: "/Q_logo.png",
  },
  openGraph: {
    type: "website",
    locale: "en_IN",
    url: siteConfig.url,
    title: "Qrie AI — Adaptive Learning Platform & Learning Adaptation Model",
    description: siteConfig.description,
    siteName: siteConfig.name,
    images: [
      {
        url: "/Q_logo.png",
        width: 512,
        height: 512,
        alt: "Qrie AI — Adaptive Learning Intelligence",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title: "Qrie AI — Adaptive Learning Platform & LAM",
    description: siteConfig.description,
    images: ["/Q_logo.png"],
    creator: "@qrieai",
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      "max-video-preview": -1,
      "max-image-preview": "large",
      "max-snippet": -1,
    },
  },
  other: {
    "geo.region": "IN-KA",
    "geo.placename": "Bengaluru",
    "geo.position": "12.9279;77.6835",
    "ICBM": "12.9279, 77.6835",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="scroll-smooth">
      <head>
        <meta name="geo.region" content="IN-KA" />
        <meta name="geo.placename" content="Bengaluru" />
        <meta name="geo.position" content="12.9279;77.6835" />
        <meta name="ICBM" content="12.9279, 77.6835" />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{
            __html: JSON.stringify(generateOrganizationSchema()),
          }}
        />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{
            __html: JSON.stringify(generateWebSiteSchema()),
          }}
        />
      </head>
      <body className="min-h-screen flex flex-col bg-white text-[#101214] antialiased selection:bg-[#e9f2fe] selection:text-[#101214]">
        <Suspense fallback={<header className="h-14 bg-white border-b border-[#f0f1f2]" />}>
          <Header />
        </Suspense>
        <main className="flex-1">{children}</main>
        <Footer />
      </body>
    </html>
  );
}
