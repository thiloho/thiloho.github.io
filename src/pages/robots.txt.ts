import type { APIRoute } from "astro";

const getRobotsTxt = (sitemapURL: URL) => `User-agent: *
Allow: /

Sitemap: ${sitemapURL.href}
`;

export const GET: APIRoute = (context) => {
  const sitemapURL = new URL("sitemap-index.xml", context.url.origin);
  return new Response(getRobotsTxt(sitemapURL));
};
