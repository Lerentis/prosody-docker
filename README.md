
# Prosody Docker

This is a Prosody Docker image building repository.

## Running

Docker images are built off an __Ubuntu 16.04 LTS__ base.
You have to Build this Image locally, as I don't have it on the Docker Hub at the moment!
```bash
docker built -t lerentis/prosody . && docker run -d --name prosody -p 5222:5222 prosody/prosody
```

A user can be created by using environment variables `LOCAL`, `DOMAIN`, and `PASSWORD`. This performs the following action on startup:

  prosodyctl register *local* *domain* *password*

Any error from this script is ignored. Prosody will not check the user exists before running the command (i.e. existing users will be overwritten). It is expected that [mod_admin_adhoc](http://prosody.im/doc/modules/mod_admin_adhoc) will then be in place for managing users (and the server).

### Ports

The image exposes the following ports to the docker host:

* __80__: HTTP port
* __5222__: c2s port
* __5269__: s2s port
* __5347__: XMPP component port
* __5280__: Admin Interface
* __5281__: Secure Admin Interface

Note: These default ports can be changed in your configuration file. Therefore if you change these ports will not be exposed.

### Volumes

Volumes can be mounted at the following locations for adding in files:

* __/etc/prosody__:
  * Prosody configuration file(s)
  * SSL certificates
* __/var/log/prosody__:
  * Log files for prosody - if not mounted these will be stored on the system
  * Note: This location can be changed in the configuration, update to match
  * Also note: The log directory on the host (/logs/prosody in the example below) must be writeable by the prosody user
* __/usr/lib/prosody-modules__ (suggested):
  * Location for including additional modules
  * Note: This needs to be included in your config file, see http://prosody.im/doc/installing_modules#paths

### Example

```bash
docker built -t lerentis/prosody . && docker run -d -p 5222:5222 -p 5269:5269 -p 5347:5347 -p 5280:5280 -v /opt/docker/jabber_data/config/:/etc/prosody -v /opt/docker/jabber_data/logs/:/var/log/prosody -v /opt/docker/jabber_data/modules/:/usr/lib/prosody-modules --name jabber-server lerentis/prosody
```

## Building

```bash
docker built -t <TAG_NAME> .
```
