FROM node:24

WORKDIR /app

RUN apt-get update && apt-get install -y \
    jq \
    curl \
    git \
    nano \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g cline

RUN mkdir -p /root/.cline/data \
    && mkdir -p /root/.cline/data/settings

COPY .docker/globalState.json /root/.cline/data/
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENV PATH="/usr/local/bin:${PATH}"

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []

ENV CLINE_AWS_REGION="us-east-1"
ENV CLINE_AWS_MODEL_ID=""
