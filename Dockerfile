## Dockerfile for creating LaTeX documents.
FROM paullamar3/docker-texlive-full
MAINTAINER Paul LaMar <pal3@outlook.com>

# Add utility scripts: p_addpkgs, p_adduser
COPY p_* /usr/local/bin/
RUN chmod 755 /usr/local/bin/p_*

# Install vim, git, and other packages supporting the IDE.
# Note that we install a GUI compile of Vim. We don't want the GUI;
# we want the "+clientserver" feature which requires a GUI compile.
RUN p_addpkgs vim-gtk git tree evince wget latexmk xzdec

# Copy the default vimrc and plugin manager for root user
COPY vimrc     /root/.vimrc
COPY plug.vim  /root/.vim/autoload/

# Add the vim user
RUN p_adduser vim Vim

# Copy the default vimrc and plugin manager for vim user
COPY vimrc /home/vim/.vimrc
COPY plug.vim  /home/vim/.vim/autoload/
COPY entrypoint.sh /home/vim/

# Put us in the vim user home folder
WORKDIR /home/vim/
# Change the owner from 'root' to 'vim' for the copied files
RUN chown -R vim .vim .vimrc entrypoint.sh

# Switch to vim user
USER vim

# Specify default git user and email
RUN git config --global user.name "Vim" && git config --global user.email "vim@dummy.aaa"

# Install the plugins for Vim
RUN vim -c "PlugInstall|q|q"

# Add line for the vimtex plugin
RUN sed -i "s/call plug#end()/Plug 'lervag\/vimtex'\n&/" /home/vim/.vimrc

RUN mkdir ltx
RUN chown vim ltx

# Install the new plugins.
RUN vim -c "PlugInstall|q|q"

# Initialize latex user mode
RUN tlmgr init-usertree

ENTRYPOINT ["/home/vim/entrypoint.sh"]
