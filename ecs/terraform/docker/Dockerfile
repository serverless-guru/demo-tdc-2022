## Stage 1 (production base)
FROM node:16.15-buster-slim as base

ARG NODE_ENV

ENV PATH="/usr/app/node_modules/.bin:$PATH"

RUN mkdir -p /usr/app && chown -R node:node /usr/app

WORKDIR /usr/app

COPY --chown=node:node package.json yarn.lock* ./ 

USER node


## Stage 2
FROM base AS build

ARG NODE_ENV

ENV NODE_ENV="$NODE_ENV"
ENV PUPPETEER_SKIP_DOWNLOAD="1"

WORKDIR /usr/app

USER node

RUN echo "$NODE_ENV"

RUN yarn config set "strict-ssl" false -g && \
  yarn install --production=false --ignore-scripts

COPY --chown=node:node . .

RUN yarn build

RUN rm -rf node_modules && \
  yarn install --production --ignore-scripts

## Stage 3 (image ready for any env)
FROM node:16.14-alpine AS final

ARG NODE_ENV

ENV NODE_ENV="$NODE_ENV"

ENV PATH="/usr/app/node_modules/.bin:$PATH"

RUN mkdir -p /usr/app && chown -R node:node /usr/app

WORKDIR /usr/app

COPY --from=build /usr/app/dist/  .
COPY --from=build /usr/app/node_modules/  ./node_modules

USER node

EXPOSE 8080

# Default Entry (Cannot be overridden) unlike CMD which can be replaced by cli arguments
ENTRYPOINT [ "node" ]
