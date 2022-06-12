FROM php:8.1-fpm

LABEL org.label-schema.description="Rainloop (webmail client) image using nginx, php-fpm based on debian." \
 maintainer="youtous <contact@youtous.me>" \
 org.label-schema.build-date=$BUILD_DATE \
 org.label-schema.name="youtous/rainloop" \
 org.label-schema.url="https://github.com/youtous/rainloop" \
 org.label-schema.vcs-url="https://github.com/youtous/rainloop" \
 org.label-schema.vcs-ref=$VCS_REF \
 org.label-schema.version=$VCS_VERSION

ARG GPG_FINGERPRINT="3B79 7ECE 694F 3B7B 70F3  11A4 ED7C 49D9 87DA 4591"

ENV UID=991 GID=991 UPLOAD_MAX_SIZE=25M LOG_TO_STDERR=true MEMORY_LIMIT=128M SECURE_COOKIES=true

# allow fpm to retrieve our .env
ENV fpm.pool.clear_env=false

# Install dependancies
#fix https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
RUN	mkdir -p /usr/share/man/man1/ /usr/share/man/man3/ /usr/share/man/man7/ && \
    apt-get update -q --fix-missing && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y \
    apt-transport-https \
    gnupg \
    openssl \
    wget \
    curl \
    ca-certificates \
    nginx \
    supervisor \
    sudo \
    unzip \
    libzip-dev \
	# dependencies of XML
    libxml2-dev \
    libldb-dev \
    # ldap
    libldap2-dev \
    # db clients
    sqlite3 \
    libsqlite3-dev \
    libsqlite3-0 \
    libpq-dev \
    postgresql-client \
    mariadb-client \
    # Install logrotate for Rainloop log files
    logrotate \
 && rm -rf /var/lib/apt/lists/*

# Install missing php extensions
RUN php -m && \
    docker-php-ext-install pdo_pgsql && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap && \
    php -m

 # Install rainloop
RUN cd /tmp \
 && wget -q https://www.rainloop.net/repository/webmail/rainloop-community-latest.zip \
 && wget -q https://www.rainloop.net/repository/webmail/rainloop-community-latest.zip.asc \
 && wget -q https://www.rainloop.net/repository/RainLoop.asc \
 && gpg --import RainLoop.asc \
 && FINGERPRINT="$(LANG=C gpg --verify rainloop-community-latest.zip.asc rainloop-community-latest.zip 2>&1 \
  | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && if [ -z "${FINGERPRINT}" ]; then echo "ERROR: Invalid GPG signature!" && exit 1; fi \
 && if [ "${FINGERPRINT}" != "${GPG_FINGERPRINT}" ]; then echo "ERROR: Wrong GPG fingerprint!" && exit 1; fi \
 && mkdir /rainloop && unzip -q /tmp/rainloop-community-latest.zip -d /rainloop \
 && find /rainloop -type d -exec chmod 755 {} \; \
 && find /rainloop -type f -exec chmod 644 {} \; \
 && rm -rf /tmp/* /root/.gnupg

COPY rootfs /
RUN chmod +x /entrypoint.sh
RUN chmod +x /logrotate-loop.sh
VOLUME /rainloop/data
EXPOSE 8888
CMD ["/entrypoint.sh"]
