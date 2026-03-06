FROM node:24

WORKDIR /app

RUN apt-get update && apt-get install -y \
    jq \
    curl \
    git \
    nano \
    unzip \
    && rm -rf /var/lib/apt/lists/*

ARG TARGETARCH
RUN case ${TARGETARCH} in \
    "amd64")  AWS_ARCH="x86_64" ;; \
    "arm64")  AWS_ARCH="aarch64" ;; \
    *) echo "Unsupported architecture"; exit 1 ;; \
    esac \
    && curl -sSfL "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip" -o /tmp/awscliv2.zip \
    && unzip -q /tmp/awscliv2.zip -d /tmp \
    && /tmp/aws/install -i /usr/local/aws-cli -b /usr/local/bin \
    && rm -rf /tmp/awscliv2.zip /tmp/aws

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
