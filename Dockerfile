FROM quay.io/jupyter/datascience-notebook:latest
LABEL maintainer="Mahmood Shafeie Zargar <mahmood@gmail.com>"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

WORKDIR /home/${NB_USER}/work

RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
        apt-utils \
        bc \
        cmake \
        coreutils \
        cowsay \
        csvkit \
        g++ \
        gawk \
        gh \
        gron \
        gzip \
        htop \
        jq \
        locales \
        make \
        man-db \
        mc \
        moreutils \
        nano \
        p7zip-full \
        parallel \
        ripgrep \
        sed \
        software-properties-common \
        tar \
        tree \
        unrar-free \
        unzip \
        wget \
        xmlstarlet \
        zsh

RUN npm install -g \ 
        bash-language-server \
        yaml-language-server \
        sql-language-server \
        javascript-typescript-langserver \
        tldr \
        xml2json-command \
        fx \
        vscode-json-languageserver

RUN mamba install --yes \
        r-docopt \
        r-janitor \
        r-remotes \
        r-keras \
        r-arrow \
        r-languageserver \
        jedi \
        ipython \
        virtualenv \
        pysqlite3 \
        psycopg2 \
        pymssql \
        pyarrow \
        fastparquet \
        python-lsp-server \
        pyright \
        cssselect \
        cmake \
        ollama
        
RUN wget -q -O /tmp/tidy-viewer.deb https://github.com/alexhallam/tv/releases/download/1.5.2/tidy-viewer_1.5.2_amd64.deb \
 && dpkg -i /tmp/tidy-viewer.deb \
 && rm /tmp/tidy-viewer.deb

RUN wget -q -O /tmp/fd.deb https://github.com/sharkdp/fd/releases/download/v9.0.0/fd_9.0.0_amd64.deb \
 && dpkg -i /tmp/fd.deb \
 && rm /tmp/fd.deb

RUN wget -q -O /tmp/bat.deb https://github.com/sharkdp/bat/releases/download/v0.24.0/bat_0.24.0_amd64.deb \
 && dpkg -i /tmp/bat.deb \
 && rm /tmp/bat.deb

RUN curl -fsSL https://github.com/BurntSushi/xsv/releases/download/0.13.0/xsv-0.13.0-x86_64-unknown-linux-musl.tar.gz | tar -xzC /usr/bin
RUN curl -fsSL https://github.com/ericchiang/pup/releases/download/v0.4.0/pup_v0.4.0_linux_amd64.zip | bsdtar -xC /usr/bin
RUN curl -fsSL https://github.com/jehiah/json2csv/releases/download/v1.2.1/json2csv-1.2.1.linux-amd64.go1.13.5.tar.gz | tar -xzC /usr/bin --strip-components=1
RUN curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz | tar -xzC /opt \
 && ln -fs /opt/nvim-linux64/bin/nvim /usr/bin/nvim \
 && ln -fs /opt/nvim-linux64/bin/nvim /usr/bin/vim
RUN curl -fsSL https://ollama.com/install.sh | sh
 
RUN curl -fsSL https://raw.githubusercontent.com/databricks/setup-cli/main/install.sh | sh
RUN curl -fsSL https://aka.ms/InstallAzureCLIDeb | bash
RUN curl -fsSL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip | bsdtar -xC /tmp \
 && chmod +x /tmp/aws/install \
 && /tmp/aws/install \
 && rm -rf /tmp/aws

RUN git clone https://github.com/dbro/csvquote.git /tmp/csvquote \
 && cd /tmp/csvquote \
 && make \
 && make install \
 && rm -rf /tmp/csvquote

RUN git clone https://github.com/jeroenjanssens/dsutils.git /opt/dsutils \
 && rm -rf /opt/dsutils/.git /opt/dsutils/.gitignore /opt/dsutils/LICENSE /opt/dsutils/README.md \
 && ln -s /opt/dsutils/* /usr/bin

RUN echo export PAGER="less" >> /home/${NB_USER}/.bashrc \
 && echo alias l=\"ls -lhF --group-directories-first\" >> /home/${NB_USER}/.bash_aliases \
 && echo alias parallel=\"parallel --will-cite\" >> /home/${NB_USER}/.bash_aliases \
 && echo set editing-mode vi >> /home/${NB_USER}/.inputrc \
 && echo set show-mode-in-prompt On >> /home/${NB_USER}/.inputrc \
 && echo set vi-cmd-mode-string : >> /home/${NB_USER}/.inputrc \
 && echo set vi-ins-mode-string + >> /home/${NB_USER}/.inputrc \
 && echo set keyseq-timeout 25 >> /home/${NB_USER}/.inputrc \
 && echo "\e[1;5A:history-search-backward" >> /home/${NB_USER}/.inputrc \
 && echo "\e[1;5B:history-search-forward" >> /home/${NB_USER}/.inputrc \
 && git clone https://github.com/LazyVim/starter /home/${NB_USER}/.config/nvim \
 && rm -rf /home/${NB_USER}/.config/nvim/.git

RUN mamba install --yes \
        pytorch \
        torchvision \
        torchaudio \
        cpuonly \
        -c pytorch

RUN mamba install --yes \
        keras \
        datasketches \
        gensim \
        nltk \
        scikit-learn

RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && fix-permissions "/usr/bin" \
 && mamba clean --all -f -y \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

VOLUME ["/home/${NB_USER}/work"]

ENV HOSTNAME="datb"