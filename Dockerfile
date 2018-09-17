FROM alpine:latest
MAINTAINER Nathaniel (nathaniel.davidson@gmail.com)

# Install curl
RUN apk update && apk add bash \
  ca-certificates \
  git \
  openssl \
  wget \
  docker

VOLUME /etc/gitlab-runner /home/gitlab-runner

ADD https://storage.googleapis.com/kubernetes-release/release/v1.11.3/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN set -x && \
    apk add --no-cache curl ca-certificates && \
    chmod +x /usr/local/bin/kubectl && \
    \
    # Create non-root user (with a randomly chosen UID/GUI).
    adduser kubectl -Du 2342 -h /config && \
    \
    # Basic check it works.
    kubectl version --client
    
RUN adduser -h /home/gitlab-runner -s /bin/bash -D gitlab-runner
RUN wget -q -O /usr/local/bin/gitlab-ci-multi-runner \
  https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-ci-multi-runner-linux-amd64 && \
  chmod +x /usr/local/bin/gitlab-ci-multi-runner

# Add the entrypoint
COPY assets/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["run", "--working-directory=/home/gitlab-runner", "--user=root"]
