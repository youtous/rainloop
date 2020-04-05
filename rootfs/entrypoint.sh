#!/bin/sh

# Set attachment size limit
sed -i "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /usr/local/etc/php-fpm.d/php-fpm.conf /etc/nginx/nginx.conf
sed -i "s/<MEMORY_LIMIT>/$MEMORY_LIMIT/g" /usr/local/etc/php-fpm.d/php-fpm.conf

# Remove postfixadmin-change-password plugin if exist
if [ -d "/rainloop/data/_data_/_default_/plugins/postfixadmin-change-password" ]; then
  rm -rf /rainloop/data/_data_/_default_/plugins/postfixadmin-change-password
fi

# Set log output to STDOUT if wanted (LOG_TO_STDOUT=true)
if [ "$LOG_TO_STDOUT" = true ]; then
  echo "[INFO] Logging to stdout activated"
  chmod o+w /dev/stdout
  sed -i "s/.*error_log.*$/error_log \/dev\/stdout warn;/" /etc/nginx/nginx.conf
  sed -i "s/.*error_log.*$/error_log = \/dev\/stdout/" /usr/local/etc/php-fpm.d/php-fpm.conf
fi

# Secure cookies
if [ "${SECURE_COOKIES}" = true ]; then
        {
        	echo 'session.cookie_httponly = On';
        	echo 'session.cookie_secure = On';
        	echo 'session.use_only_cookies = On';
        } > /usr/local/etc/php/conf.d/cookies.ini;
fi

# Add postfixadmin-change-password plugin
mkdir -p /rainloop/data/_data_/_default_/plugins/
cp -r /usr/local/include/postfixadmin-change-password /rainloop/data/_data_/_default_/plugins/

# create not root user
groupadd --gid "$GID" php-cli -f
adduser --uid "$UID" --disabled-password --gid "$GID" --shell /bin/bash --home /home/php-cli php-cli --force

# Fix permissions
chown -R $UID:$GID /rainloop/data /var/log /var/lib/nginx

# RUN !
exec sudo -u php-cli -g php-cli /usr/bin/supervisord -c '/supervisor.conf'
