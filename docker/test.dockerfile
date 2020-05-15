# Dockerize Vue.js app - Simple Example
# https://vuejs.org/v2/cookbook/dockerize-vuejs-app.html#Simple-Example

# build stage
## prepare app
FROM node:12-alpine as build-stage
WORKDIR /app
COPY package*.json ./
COPY yarn*.lock ./
RUN yarn install
## build
COPY . .
RUN yarn run build

# install simple http server for serving static content
RUN yarn global add http-server
EXPOSE 8080
RUN ls build
CMD [ "http-server", "dist" ]
