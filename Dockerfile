# Download base image ubuntu 16.04
FROM ubuntu:16.04
# Base dir set up
WORKDIR /root/
# Update Ubuntu Software repository
RUN apt-get update
# Install essential packages
RUN apt-get install build-essential software-properties-common wget curl software-properties-common -y
# Add neovim ppa
RUN add-apt-repository ppa:neovim-ppa/unstable
# Update Ubuntu Software repository to read new added repositories
RUN apt-get update
# Install packages
RUN apt-get install neovim zsh tmux gdb git -y
# Add user
#RUN adduser --gecos "" --shell /bin/zsh giwiro
# Add to sudoers
#RUN echo "giwiro ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/giwiro && \
#    chmod 0440 /etc/sudoers.d/giwiro
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

