FROM alpine

RUN apk add --no-cache \
        autoconf \
        automake \
        bash \
        dejagnu \
        make \
        python3 \
        xvfb \
        xz \
    && : no xvfb-run yet, https://bugs.alpinelinux.org/issues/9617 \
    && wget -O /usr/local/bin/xvfb-run https://sources.debian.org/data/main/x/xorg-server/2:1.20.4-1/debian/local/xvfb-run \
    && chmod +x /usr/local/bin/xvfb-run

# Use completions/Makefile.am as cache buster, triggering a fresh
# install of packages whenever it (i.e. the set of possibly tested
# executables) changes.

ADD https://raw.githubusercontent.com/scop/bash-completion/master/completions/Makefile.am \
    https://raw.githubusercontent.com/scop/bash-completion/master/test/requirements.txt \
    install-packages.sh \
    /tmp/

RUN pip3 install --user -Ir /tmp/requirements.txt

RUN /tmp/install-packages.sh \
    && rm -r /tmp/* /root/.cache/pip