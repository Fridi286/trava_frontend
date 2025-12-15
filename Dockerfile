# Multi-stage build for Flutter Web
# Build stage
# Use a Flutter image with Dart >= 3.9 to satisfy sdk: ^3.9.2
FROM ghcr.io/cirruslabs/flutter:latest AS build
ARG API_BASE_URL=http://localhost:8080
WORKDIR /app

# Pre-copy pubspec to leverage Docker cache
COPY pubspec.yaml pubspec.lock ./
COPY analysis_options.yaml .
RUN flutter pub get

# Copy the rest
COPY . .
# Ensure .env exists for Flutter assets; populate with API_BASE_URL by default
RUN [ -f .env ] || echo "API_BASE_URL=${API_BASE_URL}" > .env
RUN flutter pub get
# Disable wasm dry run (dart:html usage is intended for JS build)
RUN flutter build web --release --dart-define API_BASE_URL=${API_BASE_URL} --no-wasm-dry-run

# Runtime stage
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY --from=build /app/build/web .

# Replace default nginx config for SPA routing
COPY deploy/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
