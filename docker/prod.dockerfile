# Vue.js Deployment Guide - Docker (Nginx)
# https://cli.vuejs.org/guide/deployment.html#docker-nginx

# build stage
## prepare app
FROM node:12-alpine as build-stage
WORKDIR /app
COPY package*.json ./
COPY yarn*.lock ./
RUN yarn install --production
## build
COPY . .
RUN yarn run build

# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
