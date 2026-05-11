# Villa Vert Bocage — static Astro site

## Cloudflare Pages

- **Framework preset:** None (or Astro if listed).
- **Build command:** `npm run build`
- **Build output directory:** `dist`
- **Node.js:** **20** or newer (see `package.json` `engines` and optionally set **Environment variables** → `NODE_VERSION=20` in the Pages project).

Install dependencies with `npm ci` or `npm install` before build (Pages runs this automatically when using package manager detection).

Set **`site`** in [`astro.config.mjs`](astro.config.mjs) to your production origin if it differs from `https://www.villa-vert-bocage.co.uk` so canonical URLs and Open Graph tags stay correct.

## Images

The wget mirror did not include files under `wp-content/uploads/`. Add those assets under [`public/wp-content/uploads/`](public/wp-content/uploads/) so image URLs such as `/wp-content/uploads/...` resolve after deploy.

## Local development

```bash
npm install
npm run dev
```

Production preview:

```bash
npm run build
npm run preview
```
