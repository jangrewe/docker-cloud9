FROM ubuntu
MAINTAINER Jan Grewe <jan@faked.org>

RUN apt-get update && \
    apt-get install -qq build-essential g++ curl libssl-dev apache2-utils git libxml2-dev sshfs python

RUN curl -sL https://deb.nodesource.com/setup | bash - && \
    apt-get install -qq nodejs

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/c9/core.git /cloud9
WORKDIR /cloud9
RUN scripts/install-sdk.sh

RUN sed -i -e 's/127.0.0.1/0.0.0.0/g' /cloud9/configs/standalone.js

EXPOSE 8080
ENV NODE_ENV production
CMD ["/root/.c9/node/bin/node", "server.js", "--listen", "0.0.0.0", "--port", "8080", "-w", "/workspace"]
