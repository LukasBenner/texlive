FROM alpine:latest

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    TEXLIVE_INSTALL_NO_CONTEXT_CACHE=1

RUN  apk add gnupg curl perl-getopt-long perl-digest-md5 unzip make wget py3-pygments fontconfig

ENV NOPERLDOC=1 \
    PATH=/usr/local/texlive/2023/bin/x86_64-linuxmusl:$PATH

ARG scheme=scheme-full

LABEL maintainer="Lukas Benner <lukasbenner@mailbox.org>"

WORKDIR /

RUN wget https://ctan.space-pro.be/tex-archive/systems/texlive/tlnet/install-tl-unx.tar.gz && \ 
  tar xzf install-tl-unx.tar.gz && rm install-tl-unx.tar.gz && \ 
  cd install-tl* && \ 
  echo "selected_scheme ${scheme}" > install.profile && \ 
  echo "tlpdbopt_install_docfiles 0" >> install.profile && \ 
  echo "tlpdbopt_install_srcfiles 0" >> install.profile && \
  echo "tlpdbopt_autobackup 0" >> install.profile && \ 
  echo "tlpdbopt_sys_bin /usr/bin" >> install.profile && \
  ./install-tl -profile install.profile && cd .. && rm -rf install-tl*

RUN tlmgr path add

WORKDIR /home
CMD ["tlmgr", "--version"]