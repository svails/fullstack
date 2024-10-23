FROM oven/bun:slim AS base

# Build project
FROM base AS build

WORKDIR /app

ENV NODE_ENV=production

# Install packages
COPY package.json bun.lockb ./
RUN bun install

# Build application
COPY . .
RUN bun run build
RUN rm -rf node_modules && bun install --production

# Copy over artifacts
FROM base

WORKDIR /app

ENV NODE_ENV=production

COPY migrations /app/migrations
COPY --from=build /app/build /app/build
COPY --from=build /app/node_modules /app/node_modules

# Start the server
EXPOSE 3000
CMD [ "bun", "./build/index.js" ]
