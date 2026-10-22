import { MetadataRoute } from "next";
import { siteConfig } from "@/lib/seo/siteConfig";
import { productsData } from "@/lib/data/products";
import { servicesData } from "@/lib/data/services";
import { resourcesData } from "@/lib/data/resources";

export default function sitemap(): MetadataRoute.Sitemap {
  const baseUrl = siteConfig.url;
  const now = new Date("2026-10-22T00:00:00Z");

  // Static core routes
  const staticRoutes: MetadataRoute.Sitemap = [
    "",
    "/platform",
    "/how-it-works",
    "/lam",
    "/ai-tutor",
    "/schools",
    "/school-demo",
    "/demo",
    "/students",
    "/parents",
    "/teachers",
    "/about",
    "/products",
    "/services",
    "/pricing",
    "/get-a-quote",
    "/resources",
    "/faq",
    "/contact",
    "/contact/sales",
    "/privacy",
    "/terms",
  ].map((route) => ({
    url: `${baseUrl}${route}`,
    lastModified: now,
    changeFrequency: route === "" ? "daily" : "weekly",
    priority: route === "" ? 1.0 : route === "/lam" || route === "/schools" ? 0.9 : 0.8,
  }));

  // Dynamic Product routes
  const productRoutes: MetadataRoute.Sitemap = productsData.map((prod) => ({
    url: `${baseUrl}/products/${prod.slug}`,
    lastModified: now,
    changeFrequency: "weekly",
    priority: 0.85,
  }));

  // Dynamic Service routes
  const serviceRoutes: MetadataRoute.Sitemap = servicesData.map((srv) => ({
    url: `${baseUrl}/services/${srv.slug}`,
    lastModified: now,
    changeFrequency: "weekly",
    priority: 0.8,
  }));

  // Dynamic Resource routes
  const resourceRoutes: MetadataRoute.Sitemap = resourcesData.map((res) => ({
    url: `${baseUrl}/resources/${res.slug}`,
    lastModified: new Date(res.publishedAt),
    changeFrequency: "monthly",
    priority: 0.7,
  }));

  return [...staticRoutes, ...productRoutes, ...serviceRoutes, ...resourceRoutes];
}
