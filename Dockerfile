FROM debian:sid

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    TEXLIVE_INSTALL_NO_CONTEXT_CACHE=1

RUN apt-get update && \ 
  apt-get install -y gnupg curl libgetopt-long-descriptive-perl unzip make libdigest-perl-md5-perl wget python3-pygments fontconfig && \ 
  rm -rf /var/lib/apt/lists/*

ENV NOPERLDOC=1 \
    PATH=/usr/local/texlive/2022/bin/x86_64-linux:$PATH

ARG scheme=scheme-full

LABEL maintainer="Lukas Benner <lukasbenner@hl-benner.de>"

WORKDIR /

RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \ 
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