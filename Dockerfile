FROM ubuntu:18.04
MAINTAINER Phaedrus Raznikov <phraznikov@gmail.com>

ARG HOME=/root
ARG SEASTEAD_HOME=/root/seastead
ARG RBENV=/root/.rbenv/bin
ARG RBENV_SHIMS=/root/.rbenv/shims

# Core
RUN export TERM="screen-256color" \
        && export DEBIAN_FRONTEND="noninteractive" \
        && sed -i 's,^path-exclude=/usr/share/man/,#path-exclude=/usr/share/man/,' /etc/dpkg/dpkg.cfg.d/excludes \
        && apt-get update \
        && apt-get install -y \
        man \
        manpages-posix \
        htop \
        bash \
        curl \
        wget \
        vim \
        man \
        software-properties-common \
        python-dev \
        python-pip \
        python3-dev \
        python3-pip \
        python3-setuptools \
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
        zlib1g-dev \
        build-essential \
        libreadline-dev \
        libyaml-dev \
        libsqlite3-dev \
        sqlite3 \
        libxml2-dev \
        libxslt1-dev \
        libcurl4-openssl-dev \
        libffi-dev \
        && locale-gen en_US.UTF-8 \
        && export LANG="en_US.UTF-8" \
        && export LANGUAGE="en_US:en" \
        && export LC_ALL="en_US.UTF-8" \
        # Cleanup
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# Install Git via PPA
RUN add-apt-repository -y ppa:git-core/ppa \
        && apt-get update \
        && apt-get install -y git \
        # Cleanup
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# Install Neovim
RUN add-apt-repository -y ppa:neovim-ppa/unstable \
        && apt-get update \
        && apt-get install -y neovim \
        # Cleanup
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
        && apt-get update \
        && apt-get install -y nodejs \
        # Cleanup
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

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
RUN apt-get update \
        && apt-get --no-install-recommends -yqq install \
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
        # Cleanup
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

ENV PATH ${PATH}:${RBENV}:${RBENV_SHIMS}

# rbenv
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash \
        # ruby 2.5.5
        && /root/.rbenv/bin/rbenv install 2.5.5 \
        && /root/.rbenv/bin/rbenv install 2.5.1 \
        && /root/.rbenv/bin/rbenv global 2.5.1 \
        && gem install rubocop \
        && gem install rubocop-performance \
        && gem install rubocop-rspec \
        && gem install rubocop-rails \
        && gem install bundler:1.17.3 \
        && gem install bundler \
        && gem install solargraph

# awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o ${HOME}/awscliv2.zip \
        && unzip ${HOME}/awscliv2.zip \
        && ./aws/install

# Dev config
RUN git clone https://github.com/phrazzld/seastead ${SEASTEAD_HOME} \
        && cd ${SEASTEAD_HOME} \
        && git remote set-url origin git@github.com:phrazzld/seastead.git \
        # zsh config
        && ln -sf ${SEASTEAD_HOME}/zshrc ${HOME}/.zshrc \
        && export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom" \
        && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
        && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
        # Cleanup zsh plugin example
        && rm -rf ${HOME}/.oh-my-zsh/custom/plugins/example \
        # nvim config
        && mkdir -p ${HOME}/.config/nvim \
        && ln -sf ${SEASTEAD_HOME}/init.vim ${HOME}/.config/nvim/init.vim \
        && nvim +PlugInstall +qall \
        # gitconfigs
        && ln -sf ${SEASTEAD_HOME}/gitconfig ${HOME}/.gitconfig \
        && ln -sf ${SEASTEAD_HOME}/gitignore ${HOME}/.gitignore \
        # yarn
        && curl -o- -L https://yarnpkg.com/install.sh | bash \
        # thefuck
        && pip3 install thefuck \
        # bullet-train
        && wget -O ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/bullet-train.zsh-theme http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme

# fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
    && ~/.fzf/install

# Autojump
RUN git clone https://github.com/wting/autojump.git \
        && cd autojump \
        && export SHELL="zsh" \
        && ./install.py

# Set timezone
RUN apt-get update -y \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata \
        # Cleanup
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

WORKDIR ${HOME}/respubliko

CMD [ "zsh" ]
