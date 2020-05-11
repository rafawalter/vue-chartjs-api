FROM node:lts
RUN yarn global add @vue/cli @vue/cli-init
WORKDIR /source
VOLUME /source
EXPOSE 8080:8080
