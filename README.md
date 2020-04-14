# youtous/rainloop

![](https://i.goopics.net/nI.png)

[![pipeline status](https://gitlab.com/youtous/rainloop/badges/master/pipeline.svg)](https://gitlab.com/youtous/rainloop/-/commits/master) 
[![Docker image size](https://img.shields.io/docker/image-size/youtous/rainloop)](https://hub.docker.com/r/youtous/rainloop/) 
[![Docker hub](https://img.shields.io/badge/hub-youtous%2Frainloop-099cec?logo=docker)](https://hub.docker.com/r/youtous/rainloop/) 
[![Licence](https://img.shields.io/github/license/youtous/rainloop)](https://github.com/youtous/rainloop/blob/master/LICENSE) 

- docker hub: https://hub.docker.com/r/youtous/rainloop
- github repo: https://github.com/youtous/rainloop

### Docker-compose.yml

```yml
rainloop:
  image: youtous/rainloop:latest
  container_name: rainloop
  ports:
    - "80:8888"
  volumes:
    - /mnt/docker/rainloop:/rainloop/data
  depends_on:
    - mailserver
```

### What is this ?

Rainloop is a simple, modern & fast web-based client. 
More details on the [official website](http://www.rainloop.net/).

This fork  https://github.com/hardware/rainloop maintains a docker image for the latest version of rainloop using **debian stretch** image as base.
It also provides some security enhancements, see below.

### Features
- Lightweight & secure image (no root process)
- Based on **Debian-stretch**
- Latest Rainloop **Community Edition** (stable)
- Contacts (DB) : sqlite, mysql or pgsql (server not built-in)
- With Nginx and PHP7
- Postfixadmin-change-password plugin
- Redirects Rainloop log files to docker logs, allowing fail2ban processing
- Periodically rotates rainloop log files (errors, auth)

### Build-time variables
- **GPG_FINGERPRINT** : fingerprint of signing key

### Ports
- **8888**

### Environment variables
| Variable | Description | Type | Default value |
| -------- | ----------- | ---- | ------------- |
| **UID** | rainloop user id | *optional* | 991
| **GID** | rainloop group id | *optional* | 991
| **UPLOAD_MAX_SIZE** | Attachment size limit | *optional* | 25M
| **LOG_TO_STDERR** | Enable nginx and php error logs to stderr | *optional* | true
| **MEMORY_LIMIT** | PHP memory limit | *optional* | 128M
| **SECURE_COOKIES** | PHP Cookies Secure Only (HTTPS required) | *optional* | true

#### How to setup

https://github.com/hardware/mailserver/wiki/Rainloop-initial-configuration

**/!\\ Security:** Restrict admin interface after configuration is done.

#### Fail2ban pattern

Authentication failures are logged using the following pattern:
```
[{date:Y-m-d H:i:s}] Auth failed: ip={request:ip} user={imap:login} host={imap:host} port={imap:port}
```

You can configure fail2ban jails and filter as it follows:

_/etc/fail2ban/filter.d/rainloop.conf_
```
[Definition]
failregex = Auth failed: ip=<HOST> user=.* host=.* port=.*$
ignoreregex =
```

_/etc/fail2ban/jail.local_
```
[rainloop]
enabled = true
port = http,https
backend = systemd # systemd is used as a source of logs, docker logs are redirected to systemd
```