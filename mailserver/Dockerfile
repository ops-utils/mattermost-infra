FROM debian:buster

RUN apt-get update && apt-get install -y \
      postfix \
    && rm -rf /var/cache/apt/*

EXPOSE 10025

CMD ["postfix", "start-fg"]
