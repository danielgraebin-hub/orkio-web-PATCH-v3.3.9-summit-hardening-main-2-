# ORKIO FRONTEND DOCKERFILE (React + Vite SPA)
// Place this file at project root as: Dockerfile

# ---------- BUILD STAGE ----------
FROM node:20-alpine AS builder

WORKDIR /app

# install deps (layer caching)
COPY package*.json ./
RUN npm install

# copy source
COPY . .

# production build
RUN npm run build


# ---------- RUNTIME STAGE ----------
FROM nginx:stable-alpine

# clean default nginx html
RUN rm -rf /usr/share/nginx/html/*

# copy compiled app
COPY --from=builder /app/dist /usr/share/nginx/html

# copy SPA-safe nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
