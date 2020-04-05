# youtous/rainloop

![](https://i.goopics.net/nI.png)

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
- Postfixadmin-change-password plugin # todo

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
| **LOG_TO_STDOUT** | Enable nginx and php error logs to stdout | *optional* | true
| **MEMORY_LIMIT** | PHP memory limit | *optional* | 128M
| **SECURE_COOKIES** | PHP Cookies Secure Only (HTTPS required) | *optional* | true

### Docker-compose.yml

```yml
rainloop:
  image: registry.gitlab.com/youtous/rainloop
  container_name: rainloop
  volumes:
    - /mnt/docker/rainloop:/rainloop/data
  depends_on:
    - mailserver
```

#### How to setup

https://github.com/hardware/mailserver/wiki/Rainloop-initial-configuration

**/!\\ Important:** Please disable admin interface after configuration is done. 