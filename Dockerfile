# development stage
FROM node:13-alpine AS dev-stage

RUN apk add --no-cache make gcc g++ python

WORKDIR /srv

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD [ "npm", "run", "dev" ]

# build stage
FROM dev-stage AS build-stage

RUN npm run build

RUN rm -rf node_modules

RUN npm install --production

# production stage
FROM node:13-alpine AS production-stage

ARG PACKAGE_VERSION=untagged
LABEL PackageVersion=${PACKAGE_VERSION}

ARG NODE_ENV=production
LABEL Environment=${NODE_ENV}

WORKDIR /srv

COPY --from=build-stage /srv /srv

CMD [ "npm", "start"]
