import { defineConfig } from "astro/config";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  site: "https://thiloho.github.io",

  trailingSlash: "never",

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
  },
});
