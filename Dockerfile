FROM ubuntu:24.04
ENV TARGETARCH="linux-x64"

RUN apt update
RUN apt upgrade -y
RUN apt install -y curl git jq libicu74

# Install dependencies
# Install buildctl & buildkitd
ENV BUILDKIT_VERSION=v0.26.2

RUN curl -sSL https://github.com/moby/buildkit/releases/download/${BUILDKIT_VERSION}/buildkit-${BUILDKIT_VERSION}.linux-amd64.tar.gz \
  | tar -xz -C /usr/local

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