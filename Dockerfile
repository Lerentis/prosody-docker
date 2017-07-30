FROM ubuntu:16.04

LABEL maintainer "lerentis@burntbunch.org"

# Add Repository
RUN apt-get update && apt-get install -y wget
RUN echo deb http://packages.prosody.im/debian xenial main | tee -a /etc/apt/sources.list
RUN wget https://prosody.im/files/prosody-debian-packages.key -O- | apt-key add -

# Install dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        openssl \
        ca-certificates \
	prosody \
	tar \
	mercurial \
	lua-sec \
	lua-dbi-mysql \
	&& rm -rf /var/lib/apt/lists/*

# Install and configure prosody
RUN sed -i '1s/^/daemonize = false;\n/' /etc/prosody/prosody.cfg.lua \
    && perl -i -pe 'BEGIN{undef $/;} s/^log = {.*?^}$/log = {\n    {levels = {min = "info"}, to = "console"};\n}/smg' /etc/prosody/prosody.cfg.lua

RUN hg clone https://hg.prosody.im/prosody-modules/ /usr/lib/prosody/modules/prosody-modules
RUN cd /usr/lib/prosody/modules//prosody-modules/mod_admin_web/admin_web/ && ls -alh &&  ./get_deps.sh
COPY prosody.cfg.lua /etc/prosody/prosody.cfg.lua

VOLUME ["/etc/prosody", "/var/log/prosody", "/usr/lib/prosody-modules"]

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80 443 5222 5269 5280 5347 5280 5281
USER prosody
ENV __FLUSH_LOG yes
CMD ["prosody"]
