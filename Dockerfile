FROM ubuntu:trusty
LABEL maintainer="fbelzunc@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

# Install Packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      acl \
      attr \
      build-essential \
      bind9 \
      docbook-xsl \
      dnsutils \
      expect \
      gdb \
      krb5-kdc \
      krb5-user \
      libacl1-dev \
      libattr1-dev \
      libblkid-dev \
      libbsd-dev \
      libcups2-dev \
      libgnutls-dev \
      libldap2-dev \
      libnss-sss \
      libnss-ldap \
      libpam0g-dev \
      libpam-sss \
      libpopt-dev \
      libreadline-dev \
      openssh-server \
      pkg-config \
      pwgen \
      python-dev \
      python-dnspython \
      python-xattr \
      rsyslog \
      samba \
      smbclient \
      sssd \
      sssd-tools \
      supervisor \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy configuration and utilities files
COPY ./named.conf.options /etc/bind/named.conf.options
COPY ./kdb5_util_create.expect kdb5_util_create.expect
COPY ./sssd.conf /etc/sssd/sssd.conf
COPY ./custom.sh /usr/local/bin/custom.sh
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./init.sh /init.sh

# Run Tuning command is a single instruction
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d \
  && mkdir -p /var/run/sshd /var/log/supervisor /var/run/named \
  && sed -ri 's/PermitRootLogin without-password/PermitRootLogin Yes/g' /etc/ssh/sshd_config \
  && chown -R bind:bind /var/run/named \
  && chmod 0600 /etc/sssd/sssd.conf \
  && chmod +x /usr/local/bin/custom.sh \
  && chmod 755 /init.sh

VOLUME ["/var/lib/samba", "/etc/samba"]
EXPOSE 22 53 389 88 135 139 138 445 464 3268 3269
ENTRYPOINT ["/init.sh"]
CMD ["app:start"]
