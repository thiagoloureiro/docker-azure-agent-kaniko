FROM debian:stable-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl git ca-certificates unzip jq \
    && rm -rf /var/lib/apt/lists/*

# Install Kaniko
ENV KANIKO_DIR=/kaniko
RUN mkdir -p $KANIKO_DIR && cd $KANIKO_DIR && \
    curl -LO https://github.com/GoogleContainerTools/kaniko/releases/download/v1.23.2/executor \
    && chmod +x executor

ENV PATH="/kaniko:${PATH}"

WORKDIR /azp

COPY start.sh .
RUN chmod +x start.sh

ENTRYPOINT ["./start.sh"]
