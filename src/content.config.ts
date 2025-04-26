import { defineCollection, z } from "astro:content";
import { glob } from "astro/loaders";

const index = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/index" }),
});

const blog = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/blog" }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    pubDate: z.coerce.date(),
    modDate: z.coerce.date().optional(),
  }),
});

const legal = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/legal" }),
});

export const collections = { index, blog, legal };
