import rss from "@astrojs/rss";
import { getCollection } from "astro:content";
import sanitizeHtml from "sanitize-html";
import MarkdownIt from "markdown-it";
const parser = new MarkdownIt();

export const GET = async (context) => {
  const blog = await getCollection("blog");
  return rss({
    title: "Thilo Hohlt’s Blog",
    description: "Thilo Hohlt’s Blog",
    site: context.site,
    trailingSlash: false,
    stylesheet: "pretty-feed-v3.xsl",
    items: blog.map((article) => ({
      link: `/blog/${article.id}/`,
      content: sanitizeHtml(parser.render(article.body), {
        allowedTags: sanitizeHtml.defaults.allowedTags.concat(["img"]),
      }),
      ...article.data,
    })),
  });
};
