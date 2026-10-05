# Use Node.js to build React app
FROM node:22-alpine AS build
WORKDIR /app

# Copy package.json and yarn.lock for home module
COPY src/package.json src/
COPY src/yarn.lock src/

WORKDIR /app/src/

# Install dependencies
RUN yarn install

WORKDIR /app

# Copy rest of files
COPY . .

WORKDIR /app/src/

# Build the app
RUN yarn build

# Use a runtime image to run the app
# Stage 2: Serve the React app with Nginx fixed
FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html

# Copy React app's built files from the dist folder
COPY --from=build /app/src/dist/ .

# Nginx configuration (optional: for custom routes, etc.)
COPY src/nginx.conf /etc/nginx/nginx.conf

# Copy all .env.* files so env.sh can source the right one at runtime
COPY src/.env.* /app/config/

# Copy entrypoint script to generate runtime env config
COPY src/env.sh /docker-entrypoint.d/40-env-config.sh
RUN chmod +x /docker-entrypoint.d/40-env-config.sh

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]