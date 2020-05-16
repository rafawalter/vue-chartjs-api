FROM node:10
WORKDIR /app
VOLUME /app

RUN npm -g add @vue/cli @vue/cli-init @vue/cli-service-global

EXPOSE 8080:8080
