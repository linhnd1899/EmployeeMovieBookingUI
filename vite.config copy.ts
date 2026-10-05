import { defineConfig } from "vitest/config"
import { loadEnv } from "vite"
import react from "@vitejs/plugin-react"
import fs from 'fs';
import IstanbulPlugin from 'vite-plugin-istanbul';

// https://vitejs.dev/config/
export default defineConfig(({ mode }) =>{
  const env = loadEnv(mode, process.cwd(), '');
  const isLocal = env.VITE_HTTPS_LOCAL_SUPPORT === "true"
    && fs.existsSync('./localhost-key.pem')
    && fs.existsSync('./localhost.pem');
  
  return isLocal ? {
    plugins: [react(),
      IstanbulPlugin({
        include: ['src/**/*'],
        exclude: ['node_modules', 'test/'],
        extension: [ '.js', '.ts','.tsx' ],
      })
    ],
    server: {
      open: true,
      https: {
        key: fs.readFileSync('./localhost-key.pem'),
        cert: fs.readFileSync('./localhost.pem'),
      },
      port: 7074,
    },
    test: {
      globals: true,
      environment: "jsdom",
      setupFiles: "src/setupTests",
      mockReset: true,
    },
  } : {
    plugins: [react()],
    base: '/', //Base path for production
    server: {
      open: true,
      port: 7074,
    },
    test: {
      globals: true,
      environment: "jsdom",
      setupFiles: "src/setupTests",
      mockReset: true,
    },
  };
})
