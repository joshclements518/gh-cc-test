# Runtime image is produced by .github/workflows/publish-image.yml (Flutter web → nginx).
# See deploy/Dockerfile.publish.
FROM nginx:1.27-alpine
EXPOSE 8080
