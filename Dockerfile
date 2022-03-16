# Stage 0, "build-stage", based on Node.js 16, to build and compile NestJS
FROM node:16.13.2 as build-stage

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY . /app

RUN npm run build

# Stage 1, based on Node.js 16-alpine, to have only the dist, ready for production
FROM node:16.13.2-alpine as hydra

WORKDIR /usr/src/app

COPY --from=build-stage /app/tsconfig.build.json /app/package.json /app/package-lock.json ./
COPY --from=build-stage /app/node_modules ./node_modules
COPY --from=build-stage /app/dist ./dist

RUN mkdir -p ./logs

EXPOSE 3000

CMD ["npm", "run" ,"start:prod"]
