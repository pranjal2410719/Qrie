import { siteConfig } from "./siteConfig";

export function generateOrganizationSchema() {
  return {
    "@context": "https://schema.org",
    "@type": "EducationalOrganization",
    name: siteConfig.name,
    legalName: siteConfig.legalName,
    url: siteConfig.url,
    logo: `${siteConfig.url}/Q_logo.png`,
    description: siteConfig.description,
    address: {
      "@type": "PostalAddress",
      streetAddress: siteConfig.address.street,
      addressLocality: siteConfig.address.city,
      addressRegion: siteConfig.address.state,
      postalCode: siteConfig.address.postalCode,
      addressCountry: siteConfig.address.country,
    },
    geo: {
      "@type": "GeoCoordinates",
      latitude: 12.9279,
      longitude: 77.6835,
    },
    serviceArea: {
      "@type": "AdministrativeArea",
      name: "India",
    },
    knowsAbout: [
      "Learning Adaptation Model (LAM)",
      "Bayesian Knowledge Tracing (BKT)",
      "NCERT Classes 6–12 Curriculum",
      "CBSE Secondary & Senior Secondary Education",
      "Socratic AI Tutoring",
      "K-12 School Management Software",
      "India Digital Personal Data Protection (DPDP) Act 2023",
      "Offline-First Mobile Learning Systems",
    ],
    contactPoint: {
      "@type": "ContactPoint",
      telephone: siteConfig.phone,
      contactType: "customer service",
      email: siteConfig.contactEmail,
      areaServed: "IN",
      availableLanguage: ["English", "Hindi"],
    },
    sameAs: [
      siteConfig.social.twitter,
      siteConfig.social.github,
      siteConfig.social.linkedin,
      siteConfig.social.youtube,
    ],
  };
}

export function generateWebSiteSchema() {
  return {
    "@context": "https://schema.org",
    "@type": "WebSite",
    name: siteConfig.name,
    url: siteConfig.url,
    description: siteConfig.description,
    publisher: {
      "@type": "EducationalOrganization",
      name: siteConfig.name,
    },
  };
}

export function generateSoftwareApplicationSchema(app: {
  name: string;
  operatingSystem: string;
  applicationCategory: string;
  description: string;
  price?: string;
  currency?: string;
}) {
  return {
    "@context": "https://schema.org",
    "@type": "SoftwareApplication",
    name: app.name,
    operatingSystem: app.operatingSystem,
    applicationCategory: app.applicationCategory,
    description: app.description,
    offers: {
      "@type": "Offer",
      price: app.price || "0",
      priceCurrency: app.currency || "INR",
    },
    author: {
      "@type": "EducationalOrganization",
      name: siteConfig.name,
    },
  };
}

export function generateBreadcrumbSchema(items: { name: string; url: string }[]) {
  return {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    itemListElement: items.map((item, index) => ({
      "@type": "ListItem",
      position: index + 1,
      name: item.name,
      item: item.url.startsWith("http") ? item.url : `${siteConfig.url}${item.url}`,
    })),
  };
}

export function generateProductSchema(product: {
  name: string;
  description: string;
  image?: string;
  price?: number;
  currency?: string;
  sku: string;
  availability?: string;
}) {
  return {
    "@context": "https://schema.org",
    "@type": "Product",
    name: product.name,
    description: product.description,
    image: product.image || `${siteConfig.url}/Q_logo.png`,
    sku: product.sku,
    brand: {
      "@type": "Brand",
      name: siteConfig.name,
    },
    offers: {
      "@type": "Offer",
      price: product.price ? product.price.toString() : "0",
      priceCurrency: product.currency || "INR",
      availability: product.availability || "https://schema.org/InStock",
      url: `${siteConfig.url}/products/${product.sku.toLowerCase()}`,
    },
  };
}

export function generateArticleSchema(article: {
  headline: string;
  description: string;
  url: string;
  publishedAt: string;
  updatedAt?: string;
  authorName?: string;
  image?: string;
}) {
  return {
    "@context": "https://schema.org",
    "@type": "Article",
    headline: article.headline,
    description: article.description,
    url: `${siteConfig.url}${article.url}`,
    datePublished: article.publishedAt,
    dateModified: article.updatedAt || article.publishedAt,
    author: {
      "@type": "Person",
      name: article.authorName || "Qrie Research Team",
    },
    publisher: {
      "@type": "EducationalOrganization",
      name: siteConfig.name,
      logo: {
        "@type": "ImageObject",
        url: `${siteConfig.url}/Q_logo.png`,
      },
    },
    mainEntityOfPage: {
      "@type": "WebPage",
      "@id": `${siteConfig.url}${article.url}`,
    },
  };
}

export function generateFaqSchema(faqs: { question: string; answer: string }[]) {
  return {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: faqs.map((f) => ({
      "@type": "Question",
      name: f.question,
      acceptedAnswer: {
        "@type": "Answer",
        text: f.answer,
      },
    })),
  };
}
