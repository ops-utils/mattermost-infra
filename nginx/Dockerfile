FROM nginx:1.17-alpine

# Wipe conflicting, boilerplate default.conf file
RUN rm /etc/nginx/conf.d/default.conf

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/mattermost.conf /etc/nginx/conf.d/mattermost.conf
COPY nginx/*.html /usr/share/nginx/html/

EXPOSE 80 443
