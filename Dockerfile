FROM ubuntu:latest
MAINTAINER Nathaniel (nathaniel.davidson@gmail.com)

# Install curl
RUN apt update && apt install -y bash \
  ca-certificates \
  git \
  openssl \
  wget \
  docker

VOLUME /etc/gitlab-runner /home/gitlab-runner

RUN useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
RUN wget -q -O /usr/local/bin/gitlab-ci-multi-runner \
  https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-ci-multi-runner-linux-amd64 && \
  chmod +x /usr/local/bin/gitlab-ci-multi-runner

# Add the entrypoint
COPY assets/entrypoint.sh /entrypoint.sh
COPY resolv.conf /etc/resolv.conf
ENTRYPOINT ["/entrypoint.sh"]
CMD ["run", "--working-directory=/home/gitlab-runner", "--user=root"]
