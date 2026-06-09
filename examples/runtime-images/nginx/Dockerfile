# syntax=docker/dockerfile:1

FROM nginx:1.27-alpine

LABEL org.opencontainers.image.title="nginx-proxy" \
      org.opencontainers.image.description="Reverse proxy sidecar for Podman runtime stack" \
      org.opencontainers.image.vendor="client-platform"

COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d/ /etc/nginx/conf.d/

RUN chown -R nginx:nginx /var/cache/nginx /var/log/nginx && \
    touch /var/run/nginx.pid && chown nginx:nginx /var/run/nginx.pid

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/health || exit 1

USER nginx

CMD ["nginx", "-g", "daemon off;"]
