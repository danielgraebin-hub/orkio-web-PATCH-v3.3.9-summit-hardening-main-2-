# ORKIO FRONTEND DOCKERFILE (React + Vite SPA)

# ---------- BUILD STAGE ----------
FROM node:20-alpine AS builder

WORKDIR /app

# instalar dependências
COPY package*.json ./
RUN npm install

# copiar código
COPY . .

# build produção
RUN npm run build


# ---------- RUNTIME STAGE ----------
FROM nginx:stable-alpine

# limpar html default
RUN rm -rf /usr/share/nginx/html/*

# copiar build
COPY --from=builder /app/dist /usr/share/nginx/html

# copiar config nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
