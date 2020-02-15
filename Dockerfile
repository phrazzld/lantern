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
        locales \
        cmake \
        zsh \
        && locale-gen en_US.UTF-8 \
        && export LANG="en_US.UTF-8" \
        && export LANGUAGE="en_US:en" \
        && export LC_ALL="en_US.UTF-8" \
        # Install Neovim
        && add-apt-repository -y ppa:neovim-ppa/stable \
        && apt-get update -y \
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
        && cp ${SEASTEAD_HOME}/zshrc ${HOME}/.zshrc \
        && mkdir -p ${HOME}/.config/nvim \
        && cp ${SEASTEAD_HOME}/init.vim ${HOME}/.config/nvim/init.vim \
        && nvim +PlugInstall +qall

WORKDIR ${HOME}/rose_island

CMD [ "zsh" ]
