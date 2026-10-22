import { MetadataRoute } from "next";
import { siteConfig } from "@/lib/seo/siteConfig";

export default function robots(): MetadataRoute.Robots {
  return {
    rules: [
      {
        userAgent: "*",
        allow: "/",
        disallow: ["/checkout/success", "/payment/*", "/api/*", "/orders/*"],
      },
    ],
    sitemap: `${siteConfig.url}/sitemap.xml`,
  };
}
