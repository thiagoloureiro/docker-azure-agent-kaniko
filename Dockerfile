FROM debian:stable-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl git ca-certificates unzip jq \
    && rm -rf /var/lib/apt/lists/*

# Install Azure DevOps agent
ARG AGENT_VERSION=3.229.2
RUN mkdir /azp && cd /azp && \
    curl -LsS https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz -o agent.tar.gz && \
    tar -xzf agent.tar.gz && rm agent.tar.gz

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
