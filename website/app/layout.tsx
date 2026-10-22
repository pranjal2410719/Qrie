import type { Metadata, Viewport } from "next";
import { Suspense } from "react";
import "./globals.css";
import { Header } from "@/components/layout/Header";
import { Footer } from "@/components/layout/Footer";
import { siteConfig } from "@/lib/seo/siteConfig";
import { generateOrganizationSchema, generateWebSiteSchema } from "@/lib/seo/jsonLd";

export const viewport: Viewport = {
  themeColor: "#0284c7",
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
    "School Education Platform",
    "CBSE Class 10 Learning App",
    "Adaptive Learning India",
    "Teacher Co-Pilot Software",
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
        width: 1200,
        height: 630,
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
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="scroll-smooth">
      <head>
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
      <body className="min-h-screen flex flex-col bg-white text-slate-900 antialiased selection:bg-sky-100 selection:text-sky-900">
        <Suspense fallback={<header className="h-20 bg-white border-b border-slate-100" />}>
          <Header />
        </Suspense>
        <main className="flex-1">{children}</main>
        <Footer />
      </body>
    </html>
  );
}
