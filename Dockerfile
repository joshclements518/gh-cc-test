# Built from gh-cc-test (Harborline Navigator) tree — ACC-F11 dual-repo deployable.
# Serves a thin web identity surface from this repo (Flutter app lives under app/).
FROM node:22-slim
WORKDIR /app
COPY deploy/package.json ./
COPY deploy/server.js ./
COPY README.md ./README.md
COPY app/docs ./app/docs
COPY app/pubspec.yaml ./app/pubspec.yaml
ENV PORT=8080
ENV NODE_ENV=production
EXPOSE 8080
CMD ["node", "server.js"]
