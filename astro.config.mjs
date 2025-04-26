import { defineConfig } from "astro/config";
import tailwindcss from "@tailwindcss/vite";
import { remarkModifiedTime } from "./remark-modified-time.mjs";

export default defineConfig({
  prefetch: {
    prefetchAll: true,
  },

  vite: {
    plugins: [tailwindcss()],
  },

  markdown: {
    shikiConfig: {
      theme: "github-dark",
    },
    remarkPlugins: [remarkModifiedTime],
  },
});
