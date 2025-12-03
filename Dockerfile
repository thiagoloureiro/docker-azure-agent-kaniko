FROM ubuntu:24.04
ENV TARGETARCH="linux-x64"

RUN apt update
RUN apt upgrade -y
RUN apt install -y curl git jq libicu74

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

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

# Create agent user and set up home directory
RUN useradd -m -d /home/agent agent
RUN chown -R agent:agent /azp /home/agent

USER agent
# Another option is to run the agent as root.
# ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT [ "./start.sh" ]