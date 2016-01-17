## Dockerfile for creating LaTeX documents.
FROM paullamar3/docker-texlive-full
MAINTAINER Paul LaMar <pal3@outlook.com>

# Add utility scripts: p_addpkgs, p_adduser
COPY clocal/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# Install vim, git, and other packages supporting the IDE.
# Note that we install a GUI compile of Vim. We don't want the GUI;
# we want the "+clientserver" feature which requires a GUI compile.
RUN p_addpkgs vim-gtk git tree evince wget latexmk xzdec

# Copy the default vimrc and plugin manager for root user
COPY /skel/vimrc     /root/.vimrc
COPY /skel/plug.vim  /root/.vim/autoload/

# Add line for the vimtex plugin
RUN sed -i "s/call plug#end()/Plug 'lervag\/vimtex'\n&/" /root/.vimrc

# Add options specific to Vimtex.
RUN printf "%b" "\n\" Use Evince as viewer.\nlet g:vimtex_view_general_viewer=\"evince\"" >> /root/.vimrc && \
    printf "%b" "\n\" Use 'chktex' for my syntax checking.\nlet g:syntastic_tex_checkers=['chktex']" >> /root/.vimrc

# Also copy these default files into /etc/skel so new users will have them.
RUN cp /root/.vimrc /etc/skel/ && cp -r /root/.vim /etc/skel/

# Copy the entrypoint script.
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh


# # Install the plugins for Vim
# RUN vim -c "PlugInstall|q|q"
# 
# RUN mkdir ltx
# RUN chown vim ltx
# 
# # Install the new plugins.
# RUN vim -c "PlugInstall|q|q"
# 
# # Initialize latex user mode
# RUN tlmgr init-usertree

ENTRYPOINT ["/root/entrypoint.sh"]
