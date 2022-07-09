FROM jarischaefer/baseimage-ubuntu:4.0

ARG COMPOSER_VERSION
ARG NET_IPV4_VERSION
ARG NET_IPV6_VERSION

ADD pre_install /

RUN chmod +x /build/install && /build/install && rm -r /build

ADD post_install /

RUN chmod -R +x /etc/my_init.d
