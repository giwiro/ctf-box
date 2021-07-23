# Download base image ubuntu 16.04
FROM ubuntu:16.04
# Base dir set up
WORKDIR /root/
# Configure i386 arch
RUN dpkg --add-architecture i386
# Update Ubuntu Software repository
RUN apt-get update
# Install package management essential
RUN apt-get install -y --fix-missing \
        build-essential\
        software-properties-common
# Add neovim ppa
RUN add-apt-repository ppa:neovim-ppa/unstable
# Add python3.7 repo
RUN add-apt-repository ppa:deadsnakes/ppa
# Update Ubuntu Software repository to read new added repositories
RUN apt-get update
# Install essential packages
RUN apt-get install -y --fix-missing \
        libc6:i386\
        libncurses5:i386\
        libstdc++6:i386\
        gcc-multilib \
        g++-multilib \
        bsdmainutils\
        man-db\
        wget\
        curl\
        libcurl4-openssl-dev\
        locales\
        python\
        python3.7\
        git\
        openvpn\
        zip\
        unzip\
        gawk

# Update python3 
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1
# Install pip
RUN apt-get install -y --fix-missing \
        python-pip\
        python3-pip\
        git
# Update pip
RUN python3 -m pip install --upgrade pip setuptools
# Install common pip3 packages
RUN python3 -m pip install requests capstone filebytes keystone-engine ropper
# Install common pip packages
RUN python -m pip install requests
# Generate UTF-8
RUN locale-gen en_US.UTF-8
# Update Ubuntu Software repository to read new added repositories
# RUN apt-get update
# Install packages
RUN apt-get install -y \
        sudo\
        neovim \
        zsh\
        tmux\
        gdb\
        radare2\
        strace\
        ltrace\
        binwalk \
        netcat \
        nasm
# Install postgresql
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get -y install postgresql-12
# Install GEF
RUN wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh
# Add user
#RUN adduser --gecos "" --shell /bin/zsh giwiro
# Add to sudoers
#RUN echo "giwiro ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/giwiro && \
#    chmod 0440 /etc/sudoers.d/giwiro
# Install sqlmap
RUN (cd /opt; git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev)
# Install vim plug
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# Change shell for user root
RUN chsh -s /bin/zsh
# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# Copy zshrc from github repo
RUN wget https://raw.githubusercontent.com/giwiro/dotfiles/master/.zshrc -O ->> .zshrc

# Copy tmux.conf from github repo
RUN wget https://raw.githubusercontent.com/giwiro/dotfiles/master/.tmux.conf
# Create config and nvim folders
RUN mkdir -p ~/.config/nvim
# Copy vim config from github repo
RUN wget https://raw.githubusercontent.com/giwiro/dotfiles/master/.config/nvim/init.vim -O ~/.config/nvim/init.vim
# Install metasploit
RUN (cd /tmp; curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall)
# Install exploitdb
RUN git clone https://github.com/offensive-security/exploitdb.git /opt/exploit-database
RUN ln -sf /opt/exploit-database/searchsploit /usr/local/bin/searchsploit
RUN cp -n /opt/exploit-database/.searchsploit_rc ~/
# Install dirb (by the great The Dark Raver)
RUN (cd /tmp; wget https://razaoinfo.dl.sourceforge.net/project/dirb/dirb/2.22/dirb222.tar.gz; tar -xvf dirb222.tar.gz; cd dirb222; chmod +x ./configure; ./configure; make; make install; mkdir /usr/share/dirb/; mv ./wordlists /usr/share/dirb/; chown -R root:root /usr/share/dirb/)
# Install jwt_tool for forging jwt tokens
RUN pip3 install pycryptodomex termcolor
RUN (cd /opt; git clone https://github.com/ticarpi/jwt_tool;)
# Install commonly used scripts
COPY ./bin/* /usr/local/bin/

CMD ["/sbin/init", "--log-target=journal"]
