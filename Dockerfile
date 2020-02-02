FROM ubuntu:18.04
MAINTAINER Phaedrus Raznikov <phraznikov@gmail.com>

ENV TERM screen-256color
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
        htop \
        bash \
        curl \
        wget \
        git \
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
        zsh \
        cmake

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install Neovim
RUN add-apt-repository ppa:neovim-ppa/stable
RUN apt-get update && apt-get install -y neovim

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs

# Oh My Zsh
RUN chsh -s $(which zsh)
RUN curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh || true

# Vim Plug
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | bash -

# Get dev config
COPY zshrc /root/.zshrc
COPY init.vim /root/.config/nvim/init.vim
WORKDIR /root/oa
RUN nvim +PlugInstall +qall

CMD [ "zsh" ]
