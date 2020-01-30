FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y build-essential \
        curl \
        git \
        vim \
        zsh

#RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
#RUN apt-get install -y nodejs

RUN chsh -s /usr/bin/zsh
RUN curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh || true

WORKDIR /oa

ENV TERM=xterm-256color

CMD [ "zsh" ]
