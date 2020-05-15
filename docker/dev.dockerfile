## prepare app
FROM node:12-alpine as build-stage
WORKDIR /app
COPY package*.json ./
COPY yarn*.lock ./
RUN yarn install
## update dependencies
VOLUME ["/app"]
RUN yarn install
## serve
EXPOSE 8080
ENV HOST 0.0.0.0
CMD [ "yarn", "run", "dev" ]
