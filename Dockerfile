FROM centos:7

MAINTAINER "Amakasu Ryoma"

RUN yum update -y && yum clean all

RUN yum install -y gcc gcc-c++ make git curl-devel openssl-devel \
    bzip2-devel zlib-devel readline-devel libffi-devel libxslt-devel \
    python-devel patch sqlite sqlite-devel mariadb mariadb-server


# Python
## pyenv と virtualenv を install
RUN git clone https://github.com/yyuu/pyenv.git /usr/local/pyenv && \
    git clone https://github.com/yyuu/pyenv-virtualenv.git /usr/local/pyenv/plugins/pyenv-virtualenv
ENV PYENV_ROOT /usr/local/pyenv
ENV PATH ${PYENV_ROOT}/bin:${PATH}
ENV eval "$(pyenv init -)"
ENV PYTHON_VERSION 3.5.2
## pyenv で Python 3.5.2 を install
RUN pyenv install $PYTHON_VERSION && \
    pyenv global $PYTHON_VERSION && pyenv rehash
## pip を install
RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python
## ansible
RUN pip install ansible
# RUN ansible --version


# Node.js
ENV NVM_DIR /usr/local/nvm
ENV NVM_PROFILE /etc/bashrc
ENV NODE_VERSION 4.5.0
## NVM を install
RUN git clone https://github.com/creationix/nvm.git $NVM_DIR && \
    cd $NVM_DIR && \
    git checkout -b `git describe --abbrev=0 --tags --match "v[0-9]*" origin`
## Node.js を install
RUN source $NVM_DIR/nvm.sh && \
    nvm install v$NODE_VERSION && \
    nvm alias default v$NODE_VERSION && \
    nvm use default
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN echo 'export NVM_DIR='$NVM_DIR >> $NVM_PROFILE && \
    echo 'source $NVM_DIR/nvm.sh' >> $NVM_PROFILE && \
    echo 'nvm alias default v'$NODE_VERSION' > /dev/null' >> $NVM_PROFILE && \
    echo 'nvm use default > /dev/null' >> $NVM_PROFILE


# Ruby
## rbenv を install
# RUN git clone git://github.com/sstephenson/rbenv.git /usr/local/rbenv && \
#     git clone git://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
