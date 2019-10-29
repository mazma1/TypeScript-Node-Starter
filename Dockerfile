#job 1: build application
FROM node:10.15.3-alpine AS build
RUN mkdir -p /usr/src/ts-node-starter/
WORKDIR /usr/src/ts-node-starter

COPY . ./
RUN npm install && npm rebuild node-sass
RUN npm run build

#Job 2: build image using artifacts from job 1
FROM node:10.15.3-alpine
RUN mkdir -p /usr/src/ts-node-starter/
WORKDIR /usr/src/ts-node-starter

COPY --from=build /usr/src/ts-node-starter/dist ./dist
COPY package.json ./
COPY views/ ./views

EXPOSE 3000
RUN npm install

CMD ["npm", "start"]
