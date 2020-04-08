# youtous/rainloop

![](https://i.goopics.net/nI.png)



[![pipeline status](https://gitlab.com/youtous/rainloop/badges/master/pipeline.svg)](https://gitlab.com/youtous/rainloop/-/commits/master)
[![](https://badgen.net/docker/stars/youtous/rainloop?icon=docker&label=stars)](https://hub.docker.com/r/youtous/rainloop "See this project on docker hub registry")
[![](https://images.microbadger.com/badges/version/youtous/rainloop.svg)](https://hub.docker.com/r/youtous/rainloop "See this project on docker hub registry")
[![](https://badgen.net/docker/pulls/youtous/rainloop)](https://hub.docker.com/r/youtous/rainloop "See this project on docker hub registry")

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

**/!\\ Important:** Please disable admin interface after configuration is done. It's possible to restrict 