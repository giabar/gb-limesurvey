# LimeSurvey Docker image
_Docker base image: php:7.2.12-apache-stretch_

[![DockerPulls](https://img.shields.io/docker/pulls/giabar/gb-limesurvey.svg)](https://registry.hub.docker.com/u/giabar/gb-limesurvey/)
[![DockerStars](https://img.shields.io/docker/stars/giabar/gb-limesurvey.svg)](https://registry.hub.docker.com/u/giabar/gb-limesurvey/)

Limesurvey is the number one open-source survey software.

Advanced features like branching and multiple question types make it a valuable partner for survey-creation.

Official web site: https://www.limesurvey.org

## Try online

You can try it online! Click the below button:

[![Try in PWD](https://raw.githubusercontent.com/play-with-docker/stacks/master/assets/images/button.png)](https://labs.play-with-docker.com/?stack=https://raw.githubusercontent.com/giabar/gb-limesurvey/master/docker-compose.yml)

## Requirements

* Docker CE >= 17.06.* ( [Ubuntu installation script](https://gist.github.com/giabar/9c04cea19746c036ba5d9357eb47751a) / [CentOS installation script](https://gist.github.com/giabar/ac77abc295c0fb8ddcd646533207fe80) )
* Docker Compose >= 1.22.* ( [installation script](https://gist.github.com/giabar/f966aaecd84cbbce363214065c90ae0b) )
* MariaDB/MySQL server


## Quick start locally
```
git clone https://github.com/giabar/gb-limesurvey
cd gb-limesurvey
docker-compose up -d
```

More details in [https://github.com/giabar/gb-limesurvey/blob/master/docker-compose.yml](docker-compose.yml)


## External database

You have to specify your sql hostname and credentials using specific variables:

```
docker run \
  -d \
  -p 8080:80 \
  -v /tmp/lime/upload:/var/www/html/upload \
  --name=limesurvey \
  --link=mydb \
  -e LIMESURVEY_DB_HOST=sql-server-hostname \
  -e LIMESURVEY_DB_USER=sql-username \
  -e LIMESURVEY_DB_PASSWORD=sql-password \
  -e LIMESURVEY_DB_NAME=sql-database-name \
  giabar/gb-limesurvey
```

## LimeSurvey with SSL

Change ServerName in default-ssl.conf with your host FQDN, then change cert and key file name:

```
                SSLCertificateFile      /etc/ssl/certs/server.crt
                SSLCertificateKeyFile /etc/ssl/private/server.key
```

Put your server.crt and server.key in the same folder of docker-compose-ssl.yml and then:

```
docker-compose -f docker-compose-ssl.yml up -d
```


## Environment variables

```
-e LIMESURVEY_DB_HOST=... (defaults to the IP and port of the linked mysql container)
-e LIMESURVEY_DB_USER=... (defaults to "root")
-e LIMESURVEY_DB_PASSWORD=... (defaults to the value of the MYSQL_ROOT_PASSWORD environment variable from the linked mysql container)
-e LIMESURVEY_DB_NAME=... (defaults to "limesurvey")
-e LIMESURVEY_TABLE_PREFIX=... (defaults to "" - set this to "lime_" for example if your database has a prefix)
-e LIMESURVEY_ADMIN_USER=... (defaults to "" - the username of the Limesurvey administrator)
-e LIMESURVEY_ADMIN_PASSWORD=... (defaults to "" - the password of the Limesurvey administrator)
-e LIMESURVEY_ADMIN_NAME=... (defaults to "Lime Administrator" - The full name of the Limesurvey administrator)
-e LIMESURVEY_ADMIN_EMAIL=... (defaults to "lime@lime.lime" - The email address of the Limesurvey administrator)
-e LIMESURVEY_DEBUG=... (defaults to 0 - Debug level of Limesurvey, 0 is off, 1 for errors, 2 for strict PHP and to be able to edit standard templates)
-e LIMESURVEY_SQL_DEBUG=... (defaults to 0 - Debug level of Limesurvey for SQL, 0 is off, 1 is on - note requires LIMESURVEY_DEBUG set to 2)
```
