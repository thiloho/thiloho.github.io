import { defineConfig } from "astro/config";
import tailwindcss from "@tailwindcss/vite";
import sitemap from "@astrojs/sitemap";
import rehypeAutolinkHeadings from "rehype-autolink-headings";
import rehypeSlug from "rehype-slug";

type RehypeNode = {
  type: string;
  tagName?: string;
  children?: RehypeNode[];
  properties?: {
    [key: string]: unknown;
    className?: string[];
  };
};

type RehypeParent = RehypeNode & {
  children: RehypeNode[];
};

type RehypeRoot = RehypeParent;

const rehypeWrapTables = () => {
  const visit = (node: RehypeNode, parent: RehypeParent | null) => {
    if (node.type === "element" && node.tagName === "table" && parent) {
      const wrapper: RehypeNode = {
        type: "element",
        tagName: "div",
        properties: {
          className: ["overflow-x-auto", "max-w-full"],
        },
        children: [node],
      };

      const index = parent.children.indexOf(node);
      if (index !== -1) {
        parent.children[index] = wrapper;
      }

      return;
    }

    if (Array.isArray(node.children)) {
      for (const child of node.children) {
        visit(child, node as RehypeParent);
      }
    }
  };

  return (tree: RehypeRoot) => {
    visit(tree, null);
  };
};

export default defineConfig({
  site: "https://thilohohlt.com",

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
    rehypePlugins: [
      rehypeSlug,
      [
        rehypeAutolinkHeadings,
        {
          behavior: "wrap",
        },
      ],
      rehypeWrapTables,
    ],
  },

  integrations: [sitemap()],
});
