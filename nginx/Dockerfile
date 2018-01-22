ARG NGINX_VERSION
FROM nginx:${NGINX_VERSION}-alpine

COPY default.conf.template /etc/nginx/conf.d/default.conf

ARG SERVER_NAME
RUN sed -i s/{{SERVER_NAME}}/${SERVER_NAME}/g /etc/nginx/conf.d/default.conf

WORKDIR /etc/nginx