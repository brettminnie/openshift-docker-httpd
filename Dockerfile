ARG BUILD_IMAGE="almalinux:8-minimal"
ARG USER_GID="1000"
ARG USER_PID="1000"

### Install httpd
FROM ${BUILD_IMAGE}

COPY container_resources/httpd-foreground /usr/local/bin/

RUN microdnf update -y && \
    microdnf install -y sudo httpd && \
    microdnf clean all && \
    rm -rf /usr/local/share/man/* && \
    mkdir -p /var/www/html/{ignition,rhcos} && \
    ln -sf /proc/self/fd/1 /var/log/httpd/access.log && \
    ln -sf /proc/self/fd/1 /var/log/httpd/error.log && \
    chmod +x /usr/local/bin/httpd-foreground

COPY container_resources/etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf

VOLUME ["/var/www/html/rhcos", "/var/www/html/ignition"]

EXPOSE 8080/tcp
STOPSIGNAL SIGWINCH

CMD ["httpd-foreground"]
