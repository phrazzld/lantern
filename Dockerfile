FROM alpine:3.7
MAINTAINER Phaedrus Raznikov <phraznikov@gmail.com>

ARG HOME=/root
ARG SEASTEAD_HOME=${HOME}/seastead

# Core
RUN export TERM="screen-256color" \
        && export DEBIAN_FRONTEND="noninteractive" \
        && apk update \
        && apk add -y \
        htop \
        bash \
        curl \
        wget \
        git \
        vim \
        man \
        software-properties-common \
        python-dev \
        python-pip \
        python3-dev \
        python3-pip \
        ctags \
        shellcheck \
        netcat \
        ack-grep \
        sqlite3 \
        unzip \
        libssl-dev \
        libffi-dev \
        libclang-dev \
        locales \
        cmake \
        zsh \
        gpg-agent \
        silversearcher-ag \
        # Install Neovim
        neovim \
        nodejs \
        && locale-gen en_US.UTF-8 \
        && export LANG="en_US.UTF-8" \
        && export LANGUAGE="en_US:en" \
        && export LC_ALL="en_US.UTF-8"

#RUN add-apt-repository -y ppa:neovim-ppa/stable \
    #&& apt-get update \
    #&& apt-get install -y neovim \
        # Cleanup
        #&& apt-get clean \
        #&& rm -rf /var/lib/apt/lists/*

# Install Node
#RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
#        && apt-get update \
#        && apt-get install -y nodejs \
#        # Cleanup
#        && apt-get clean \
#        && rm -rf /var/lib/apt/lists/*

# Install Oh My ZSH
RUN chsh -s $(which zsh) \
        && curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh || true

# Install Vim Plug
RUN curl -fLo ${HOME}/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | bash -

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
        && /root/.cargo/bin/cargo install exa \
        && /root/.cargo/bin/cargo install bat \
        && /root/.cargo/bin/cargo install ripgrep \
        # Cleanup
        && rm -rf /root/.rustup

# Install Go (and rubberduck)
RUN wget https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz \
        && tar -xvf go1.13.3.linux-amd64.tar.gz \
        && chown -R root:root ./go \
        && mv go /usr/local \
        && export GOPATH=$HOME/go \
        && export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin \
        && go get github.com/phrazzld/rubberduck \
        # Cleanup
        && rm /go1.13.3.linux-amd64.tar.gz \
        && rm -rf /root/go/src \
        && rm -rf /root/.cache

# LastPass
# Install dependencies
RUN apk update \
        && apk --no-install-recommends -yqq add \
        bash-completion \
        build-essential \
        cmake \
        libcurl4 \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2 \
        libxml2-dev \
        libssl1.1 \
        pkg-config \
        ca-certificates \
        xclip \
        # lastpass-cli
        && git clone https://github.com/lastpass/lastpass-cli.git /tmp/lastpass-cli \
        && cd /tmp/lastpass-cli \
        && make \
        && make install \

# Dev config
RUN git clone https://github.com/phrazzld/seastead ${SEASTEAD_HOME} \
        # zsh config
        && ln -sf ${SEASTEAD_HOME}/zshrc ${HOME}/.zshrc \
        && export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom" \
        # nvim config
        && mkdir -p ${HOME}/.config/nvim \
        && ln -sf ${SEASTEAD_HOME}/init.vim ${HOME}/.config/nvim/init.vim \
        && nvim +PlugInstall +qall \
        # gitconfigs
        && ln -sf ${SEASTEAD_HOME}/gitconfig ${HOME}/.gitconfig \
        && ln -sf ${SEASTEAD_HOME}/gitignore ${HOME}/.gitignore

# fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
    && ~/.fzf/install

# Autojump
RUN git clone https://github.com/wting/autojump.git \
        && cd autojump \
        && export SHELL="zsh" \
        && ./install.py

# Set timezone
RUN apk update -y \
        && DEBIAN_FRONTEND=noninteractive apk add -y tzdata \
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

WORKDIR ${HOME}/rose_island

CMD [ "zsh" ]
