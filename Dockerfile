# ACC-F11 — UI deployable is Flutter web (not this Dockerfile alone).
# Build/push via control-plane:
#   UI_SHA=... API_SHA=... bash scripts/build-dual-repo-images.sh
# which runs `flutter build web` with --dart-define=UI_SHA/API_SHA and packs nginx:alpine.
#
# This file documents the intended runtime layout for operators reading the repo.
FROM nginx:1.27-alpine
# Expect image layers to provide /usr/share/nginx/html (Flutter web) + conf on :8080
EXPOSE 8080
