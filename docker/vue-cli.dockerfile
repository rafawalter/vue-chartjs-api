FROM node:12-alpine
WORKDIR /app
VOLUME /app

RUN yarn global add @vue/cli @vue/cli-init

ENV NODE_ENV dev

EXPOSE 8080:8080
