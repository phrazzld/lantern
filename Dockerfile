FROM ubuntu:18.04
MAINTAINER Phaedrus Raznikov <phraznikov@gmail.com>

ARG HOME=/root
ARG SEASTEAD_HOME=${HOME}/seastead

RUN export TERM="screen-256color" \
        && export DEBIAN_FRONTEND="noninteractive" \
        && apt-get update \
        && apt-get install -y \
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
        && locale-gen en_US.UTF-8 \
        && export LANG="en_US.UTF-8" \
        && export LANGUAGE="en_US:en" \
        && export LC_ALL="en_US.UTF-8" \
        # Install Neovim
        && add-apt-repository -y ppa:neovim-ppa/stable \
        && apt-get install -y neovim \
        # Install Node
        && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
        && apt-get install -y nodejs \
        # Install Oh My ZSH
        && chsh -s $(which zsh) \
        && curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh || true \
        # Install Vim Plug
        && curl -fLo ${HOME}/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | bash - \
        # Get dev config
        && git clone https://github.com/phrazzld/seastead ${SEASTEAD_HOME} \
        # zsh config
        && ln -sf ${SEASTEAD_HOME}/zshrc ${HOME}/.zshrc \
        # nvim config
        && mkdir -p ${HOME}/.config/nvim \
        && ln -sf ${SEASTEAD_HOME}/init.vim ${HOME}/.config/nvim/init.vim \
        && nvim +PlugInstall +qall \
        # gitconfigs
        && ln -sf ${SEASTEAD_HOME}/gitconfig ${HOME}/.gitconfig \
        && ln -sf ${SEASTEAD_HOME}/gitignore ${HOME}/.gitignore \
        # Install Rust
        && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
        && /root/.cargo/bin/cargo install exa \
        && /root/.cargo/bin/cargo install bat \
        # Install Go
        && apt-get install -y golang \
        && mkdir -p ${HOME}/go/src \
        && go get github.com/phrazzld/rubberduck \
        # LastPass
        # Install dependencies
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
        && rm -rf /var/lib/apt/lists/*

# Set timezone
RUN apt-get update -y \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata \
        && rm -rf /var/lib/apt/lists/*
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

WORKDIR ${HOME}/rose_island

CMD [ "zsh" ]
