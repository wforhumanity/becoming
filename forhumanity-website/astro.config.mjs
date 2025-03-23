import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
  site: 'https://forhumanity.art',
  compressHTML: true,
  build: {
    assets: '_assets'
  },
  server: {
    port: 3000,
    host: true
  }
});
