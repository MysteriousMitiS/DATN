import { fileURLToPath, URL } from 'url'

import vue from '@vitejs/plugin-vue'
import { defineConfig } from 'vite'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  define: {
    baseURL: JSON.stringify('http://localhost:2710'),
    SecretKey: JSON.stringify('1012198815021989')
  },
  server: {
    host: true
  }
})
