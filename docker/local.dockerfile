FROM node:lts-alpine
WORKDIR /source

# copy both 'package.json' and 'package-lock.json' (if available)
COPY package*.json ./
COPY yarn.* ./

# install project dependencies
RUN yarn install

VOLUME ["/source"]

EXPOSE 8080
CMD [ "yarn", "run", "dev" ]
