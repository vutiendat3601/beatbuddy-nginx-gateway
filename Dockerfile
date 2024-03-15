FROM nginx:mainline-bookworm
WORKDIR /script

RUN apt-get update && apt-get install -y jq

COPY ./conf.d/default.conf /etc/nginx/conf.d/
COPY ./script/*.sh /script/
RUN mkdir -p /etc/nginx/conf.d/proxy
RUN touch /etc/nginx/conf.d/proxy/upstream.conf
RUN touch /etc/nginx/conf.d/proxy/location.conf

COPY ./entrypoint/10-listen-on-ipv6-by-default.sh /docker-entrypoint.d/
COPY ./entrypoint/15-local-resolvers.envsh /docker-entrypoint.d/ 
COPY ./entrypoint/20-envsubst-on-templates.sh /docker-entrypoint.d/ 
COPY ./entrypoint/30-tune-worker-processes.sh /docker-entrypoint.d/ 

COPY ./entrypoint/entrypoint.sh /docker-entrypoint.sh
ENV GATEWAY_PROXY_CONFIG_DIR=/etc/nginx/conf.d
ENV GATEWAY_REFRESH_SEC=10
ENV GATEWAY_EUREKA_SERVER_URL=
ENV GATEWAY_SERVICES=
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD ["nginx", "-g", "daemon off;"]
