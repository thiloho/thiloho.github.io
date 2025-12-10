# CLAUDE.md - AI Assistant Guide for thiloho.github.io

This document provides comprehensive guidance for AI assistants working on this codebase. It covers the project structure, development workflows, and key conventions to follow.

## Project Overview

This is the source code for **thilohohlt.com**, a personal website built with the Astro web framework. The repository also includes Nix configuration files for self-hosted services and server deployment.

**Live Site**: https://thilohohlt.com
**Tech Stack**: Astro 5.14.6, Tailwind CSS 4.1.14, TypeScript, Markdown
**Deployment**: GitHub Pages (automated via GitHub Actions)

## Directory Structure

```
thiloho.github.io/
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions deployment workflow
├── public/                     # Static assets (served as-is)
│   ├── fonts/                  # Custom font files (Styrene, Tiempos)
│   ├── favicon.ico
│   ├── CNAME                   # Custom domain configuration
│   └── site.webmanifest
├── server/                     # NixOS server configuration
│   ├── default.nix
│   └── hardware-configuration.nix
├── src/
│   ├── components/             # Reusable Astro components
│   │   ├── Button.astro
│   │   ├── Date.astro
│   │   ├── Footer.astro
│   │   ├── Head.astro
│   │   ├── Header.astro
│   │   ├── Icon.astro
│   │   ├── Nav.astro
│   │   ├── TableOfContents.astro
│   │   └── Track.astro
│   ├── content/                # Content collections
│   │   ├── blog/               # Blog post markdown files
│   │   │   ├── custom-email-domain/
│   │   │   ├── e2e-testing-spring-boot-applications/
│   │   │   ├── nixos-with-ext4-and-luks/
│   │   │   └── privacy-focused-operating-systems/
│   │   └── tracks.json         # Music tracks data
│   ├── layouts/
│   │   └── PageLayout.astro    # Main page layout
│   ├── pages/                  # Routes (file-based routing)
│   │   ├── blog/
│   │   │   ├── [slug].astro    # Dynamic blog post pages
│   │   │   └── index.astro     # Blog listing page
│   │   ├── 404.astro
│   │   ├── index.astro         # Homepage
│   │   ├── legal-disclosure.astro
│   │   ├── robots.txt.ts
│   │   ├── rss.xml.ts          # RSS feed
│   │   ├── services.astro
│   │   └── tracks.astro
│   ├── styles/
│   │   └── global.css          # Global styles and font definitions
│   └── content.config.ts       # Content collections schema
├── astro.config.ts             # Astro configuration
├── flake.nix                   # Nix flake configuration
├── flake.lock                  # Nix flake lock file
├── package.json                # Node.js dependencies and scripts
├── package-lock.json
├── tsconfig.json               # TypeScript configuration
└── .prettierrc                 # Prettier configuration
```

## Tech Stack Details

### Core Framework

- **Astro 5.14.6**: Static site generator with component islands architecture
- **TypeScript**: Strict mode enabled (`extends: "astro/tsconfigs/strict"`)
- **Node.js**: ES Modules (`"type": "module"`)

### Styling

- **Tailwind CSS 4.1.14**: Utility-first CSS framework
- **@tailwindcss/typography**: Typography plugin for prose content
- **Custom Fonts**:
  - **Styrene A**: Sans-serif font for headings (weights: 100-900)
  - **Styrene B**: Monospace font for code (weights: 100-900)
  - **Tiempos Text**: Serif font for body text (weights: 400-700)
  - **Tiempos Fine**: Serif variant (weights: 300-900)
  - **Tiempos Headline**: Serif variant for headlines (weights: 300-900)

### Markdown Processing

- **markdown-it**: Markdown parser
- **rehype-slug**: Automatically add IDs to headings
- **rehype-autolink-headings**: Make headings linkable (wrap behavior)
- **Custom rehype plugin**: `rehypeWrapTables` wraps tables in scrollable divs
- **Syntax highlighting**: GitHub Dark theme via Shiki

### Content Management

- **Content Collections**: Defined in `src/content.config.ts`
  - **blog**: Markdown files with frontmatter (title, description, pubDate, modDate)
  - **tracks**: JSON file with music track data (id, title, youtubeLink, artist, album)

### Integrations

- **@astrojs/sitemap**: Automatic sitemap generation
- **@astrojs/rss**: RSS feed support
- **sanitize-html**: HTML sanitization

### Development Tools

- **Prettier**: Code formatting with plugins for Astro and Tailwind
- **Nix**: Development environment and server deployment

## Development Workflows

### Essential Commands

```bash
# Development
npm run dev          # Start Astro dev server (http://localhost:4321)
npm run build        # Build for production
npm run preview      # Preview production build
npm run format       # Format code with Prettier

# Nix (if using Nix)
nix develop          # Enter dev shell (includes nixd, nixfmt)
nix run .#eval-server    # Validate NixOS configuration
nix run .#deploy-server  # Deploy to remote NixOS server
```

### Starting Development

1. Install dependencies: `npm install`
2. Start dev server: `npm run dev`
3. Open browser to `http://localhost:4321`

### Building for Production

1. Run build: `npm run build`
2. Output is in `dist/` directory
3. Preview with: `npm run preview`

## Content Management

### Creating Blog Posts

Blog posts are stored in `src/content/blog/` with each post in its own directory containing a `index.md` file.

**Required frontmatter structure**:

```markdown
---
title: "Your Post Title"
description: "A brief description of the post"
pubDate: "2025-01-04"
modDate: "2025-04-27" # Optional
---

## Your Content Here

Write your blog post content using Markdown...
```

**Blog post conventions**:

- Each post lives in its own directory: `src/content/blog/post-slug/index.md`
- Use kebab-case for directory names (e.g., `nixos-with-ext4-and-luks`)
- Include high-quality images in the same directory as the post
- Dates in `YYYY-MM-DD` format
- `modDate` is optional (use when updating existing posts)

### Adding Music Tracks

Edit `src/content/tracks.json` following this schema:

```json
{
  "id": 1,
  "title": "Track Title",
  "youtubeLink": "https://youtube.com/...",
  "artist": "Artist Name",
  "album": "Album Name"
}
```

## Code Conventions

### TypeScript

- Use strict TypeScript configuration
- Define types explicitly where needed
- Leverage Astro's built-in type system

### Astro Components

- Use `.astro` file extension
- Component names should be PascalCase (e.g., `TableOfContents.astro`)
- Place reusable components in `src/components/`
- Use layouts for page templates (`src/layouts/`)

### Styling

- Use Tailwind utility classes for styling
- Custom styles go in `src/styles/global.css`
- Follow the custom variant pattern: `@custom-variant dark (&:where(.dark, .dark *))`
- Apply responsive design with Tailwind's breakpoint prefixes

### Formatting

- Always run `npm run format` before committing
- Prettier automatically formats:
  - Astro files (via `prettier-plugin-astro`)
  - Tailwind classes (via `prettier-plugin-tailwindcss`)
- Configuration is in `.prettierrc`

### File Naming

- Components: PascalCase (e.g., `Header.astro`)
- Pages: kebab-case or descriptive names (e.g., `index.astro`, `legal-disclosure.astro`)
- Content directories: kebab-case (e.g., `nixos-with-ext4-and-luks`)
- Configuration files: standard names (e.g., `astro.config.ts`)

## Deployment

### GitHub Pages

- **Automatic deployment** on push to `main` branch
- Workflow file: `.github/workflows/deploy.yml`
- Uses official Astro GitHub Action (`withastro/action@v3`)
- Custom domain: thilohohlt.com (configured via `public/CNAME`)

### Deployment Process

1. Push to `main` branch
2. GitHub Actions builds the site
3. Astro generates static files
4. Deploy to GitHub Pages
5. Site available at https://thilohohlt.com

### Build Configuration

- Site URL: `https://thilohohlt.com` (defined in `astro.config.ts`)
- Prefetch: All links are prefetched (`prefetchAll: true`)
- Output: Static HTML/CSS/JS in `dist/`

## NixOS Server Configuration

This repository includes Nix configuration for self-hosted services listed at https://thilohohlt.com/services.

### Nix Files

- `flake.nix`: Main Nix flake configuration
- `flake.lock`: Dependency lock file
- `server/default.nix`: NixOS system configuration
- `server/hardware-configuration.nix`: Hardware-specific settings

### Nix Workflows

```bash
# Enter development shell (provides nixd, nixfmt)
nix develop

# Validate server configuration
nix run .#eval-server

# Deploy to remote server
nix run .#deploy-server
# This will:
# 1. Evaluate the configuration
# 2. Connect to the remote server (91.98.171.83)
# 3. Build and switch to new configuration
```

### IDE Support for Nix

For NixOS option completions, use the `jnoortheen.nix-ide` VSCode extension with these settings:

```json
{
  "nix.enableLanguageServer": true,
  "nix.serverPath": "nil",
  "nix.serverSettings": {
    "nixd": {
      "formatting": {
        "command": ["nixfmt"]
      }
    }
  }
}
```

## Key Features to Preserve

### Custom Rehype Plugins

The `rehypeWrapTables` plugin wraps tables in scrollable divs for responsive design:

```typescript
const rehypeWrapTables = () => {
  // Wraps tables in div.overflow-x-auto.max-w-full
  // Ensures tables are scrollable on mobile
};
```

### Markdown Configuration

- Syntax highlighting: GitHub Dark theme
- Auto-generated heading IDs (via rehype-slug)
- Clickable headings that wrap content (via rehype-autolink-headings)
- Tables wrapped for horizontal scrolling

### Font Loading

- All fonts use `font-display: swap` for performance
- Fonts are self-hosted in `/public/fonts/`
- Font families defined in `src/styles/global.css`

## Important Notes for AI Assistants

### When Making Changes

1. **Always read files before editing**: Use the Read tool before making changes to understand existing code structure
2. **Preserve existing conventions**: Don't introduce new patterns unless necessary
3. **Test locally**: Encourage running `npm run dev` to test changes
4. **Format before committing**: Run `npm run format` to ensure consistent code style
5. **Respect content structure**: Blog posts must have proper frontmatter and directory structure
6. **Don't over-engineer**: Keep solutions simple and focused on the requested changes

### Common Tasks

**Adding a new blog post**:

1. Create directory in `src/content/blog/` with kebab-case name
2. Add `index.md` with proper frontmatter
3. Write content using Markdown
4. Test with `npm run dev`

**Modifying a component**:

1. Read the component file first
2. Understand its usage across the site
3. Make targeted changes
4. Preserve existing styling patterns
5. Format with Prettier

**Updating styles**:

1. Check `src/styles/global.css` for existing patterns
2. Use Tailwind utilities when possible
3. Add custom CSS only when necessary
4. Maintain dark mode support via custom variant

**Working with NixOS configuration**:

1. Changes to server config go in `server/` directory
2. Always validate with `nix run .#eval-server` before deploying
3. Be cautious with production server changes
4. Test locally when possible

### Things to Avoid

- ❌ Don't create documentation files unless explicitly requested
- ❌ Don't add unnecessary comments or docstrings
- ❌ Don't refactor code that isn't related to the task
- ❌ Don't add dependencies without good reason
- ❌ Don't modify font files or licenses in `/public/fonts/`
- ❌ Don't change the deployment workflow without understanding implications
- ❌ Don't edit generated files in `.astro/` or `dist/`

## Troubleshooting

### Build Fails

- Check `astro.config.ts` for syntax errors
- Verify all blog posts have required frontmatter
- Ensure TypeScript types are correct
- Run `npm install` to update dependencies

### Dev Server Issues

- Port 4321 might be in use (kill the process or use `--port` flag)
- Clear `.astro/` directory and rebuild: `rm -rf .astro && npm run dev`
- Check for TypeScript errors in components

### Styling Problems

- Run `npm run format` to fix Tailwind class ordering
- Check global.css for font loading issues
- Verify Tailwind plugin is loaded in Vite config

### Content Not Appearing

- Verify content collection schema in `src/content.config.ts`
- Check frontmatter matches schema requirements
- Ensure file paths are correct
- Restart dev server after adding new content files

## Resources

- **Astro Docs**: https://docs.astro.build/
- **Tailwind CSS Docs**: https://tailwindcss.com/docs
- **Nix Manual**: https://nixos.org/manual/nix/stable/
- **Site Repository**: https://github.com/thiloho/thiloho.github.io (inferred)

## Version Info

Last updated: 2025-12-07
Astro version: 5.14.6
Tailwind version: 4.1.14
Node.js: ES Modules
