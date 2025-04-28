import { defineCollection, z } from "astro:content";
import { glob, file } from "astro/loaders";

const blog = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/blog" }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    pubDate: z.coerce.date(),
    modDate: z.coerce.date().optional(),
  }),
});

const tracks = defineCollection({
  loader: file("./src/content/tracks.json"),
  schema: ({ image }) =>
    z.object({
      id: z.number().positive(),
      title: z.string(),
      youtubeLink: z.string().url(),
      artist: z.string(),
      album: z.string(),
      cover: image(),
    }),
});

export const collections = { blog, tracks };
