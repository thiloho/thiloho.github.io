import rss from "@astrojs/rss";
import { getCollection } from "astro:content";
import sanitizeHtml from "sanitize-html";
import MarkdownIt from "markdown-it";
const parser = new MarkdownIt();

export const GET = async (context) => {
  const blog = await getCollection("blog");

  const latestModDate = blog.reduce((latest, article) => {
    const modDate = article.data.modDate || article.data.pubDate;
    return modDate > latest ? modDate : latest;
  }, new Date(0));

  return rss({
    title: "Thilo Hohlt's Blog",
    description: "Thilo Hohlt's Blog",
    site: context.site,
    trailingSlash: false,
    xmlns: {
      atom: "http://www.w3.org/2005/Atom",
    },
    customData: `
      <lastBuildDate>${latestModDate.toUTCString()}</lastBuildDate>
      <atom:link href="${context.site}rss.xml" rel="self" type="application/rss+xml" />
    `,
    items: blog.map((article) => ({
      link: `/blog/${article.id}/`,
      content: sanitizeHtml(parser.render(article.body), {
        allowedTags: sanitizeHtml.defaults.allowedTags.concat(["img"]),
      }),
      ...article.data,
    })),
  });
};
