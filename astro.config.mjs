import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import { copyFileSync, existsSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

/** Copy @astrojs/sitemap chunk to `sitemap.xml` for crawlers expecting that URL. */
function sitemapXmlAlias() {
  return {
    name: 'sitemap-xml-alias',
    hooks: {
      'astro:build:done': ({ dir }) => {
        const outDir = fileURLToPath(dir);
        const chunk = join(outDir, 'sitemap-0.xml');
        const dest = join(outDir, 'sitemap.xml');
        if (existsSync(chunk)) copyFileSync(chunk, dest);
      },
    },
  };
}

export default defineConfig({
  site: 'https://villa-vert-bocage.com',
  output: 'static',
  compressHTML: true,
  integrations: [sitemap(), sitemapXmlAlias()],
});
