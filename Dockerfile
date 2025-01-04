# # Base Image for Angular
# FROM node:18-alpine

# # Set working directory
# WORKDIR /app

# # Install dependencies
# COPY frontend/package*.json ./
# RUN npm install
# # Copy the entire Angular project into the container
# COPY frontend/ .
# # Build the Angular app with the production configuration
# # RUN npm run build -- --project frontend --configuration production

# RUN cp src/environments/environment.prod.ts src/environments/environment.ts
# # Expose the app port
# EXPOSE 4200

# # Start the Angular app
# CMD ["npm", "run", "start"]

# # CMD ["npx", "http-server", "dist", "-p", "4200"]

# Stage 1: Install dependencies
FROM node:18-alpine AS deps-stage
WORKDIR /app
COPY frontend/package*.json ./
RUN npm install --frozen-lockfile

# Stage 2: Development server with `ng serve`
FROM node:18-alpine
WORKDIR /app

# Copy dependencies from deps stage
COPY --from=deps-stage /app/node_modules ./node_modules
COPY frontend/ .

# Ensure Angular dev environment is set to production
RUN cp src/environments/environment.prod.ts src/environments/environment.ts

# Expose the port for the Angular dev server
EXPOSE 4200

# Run the Angular development server
CMD ["npx", "ng", "serve", "--host", "0.0.0.0", "--port", "4200", "--disable-host-check"]
