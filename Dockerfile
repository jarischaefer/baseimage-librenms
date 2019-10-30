FROM jarischaefer/baseimage-ubuntu:2.3

ARG COMPOSER_VERSION=ba13e3fc70f1c66250d1ea7ea4911d593aa1dba5

RUN	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C C300EE8C && \
	echo 'deb http://ppa.launchpad.net/ondrej/php/ubuntu bionic main' > /etc/apt/sources.list.d/ondrej-php7.list && \
	echo 'deb http://ppa.launchpad.net/nginx/development/ubuntu bionic main' > /etc/apt/sources.list.d/nginx.list && \
	apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq install --no-install-recommends \
		dnsutils \
		nginx \
		php7.3-cli \
		php7.3-fpm \
		php7.3-mysql \
		php7.3-gd \
		php7.3-curl \
		php7.3-opcache \
		php7.3-ldap \
		php7.3-mbstring \
		php7.3-memcached \
		php7.3-snmp \
		php7.3-xml \
		php7.3-zip \
		php-imagick \
		php-pear \
		snmp \
		graphviz \
		fping \
		imagemagick \
		whois \
		mtr-tiny \
		nagios-plugins \
		nmap \
		python-mysqldb \
		rrdcached \
		rrdtool \
		sendmail \
		smbclient \
		git \
		python-ipaddress \
		python-memcache \
		sudo \
		curl \
		ipmitool \
		acl \
		vim-tiny \
		unzip && \
	curl -sSL -o - https://github.com/pear/Net_IPv4/archive/v1.3.5.tar.gz | tar -xz -C /tmp && \
	cd /tmp/Net_IPv4-1.3.5 && \
	pear install package.xml && \
	curl -sSL -o - https://github.com/pear/Net_IPv6/archive/174b5756d87627590a3c1624657bd32905addc4f.tar.gz | tar -xz -C /tmp && \
	cd /tmp/Net_IPv6-174b5756d87627590a3c1624657bd32905addc4f && \
	pear install package.xml && \
	curl -sSL -o - https://raw.githubusercontent.com/composer/getcomposer.org/${COMPOSER_VERSION}/web/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
	rm -rf /etc/nginx/sites-available/* /etc/nginx/sites-enabled/* && \
	useradd librenms --home-dir /opt/librenms --system --shell /bin/bash && \
	usermod -a -G librenms www-data && \
	chmod u+s /usr/bin/fping /usr/bin/fping6 /usr/lib/nagios/plugins/check_dhcp /usr/lib/nagios/plugins/check_icmp && \
	sed -i 's/session.*required.*pam_loginuid.so//g' /etc/pam.d/cron && \
	apt-get -yq autoremove --purge && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/* && \
	rm -f /var/log/dpkg.log /var/log/alternatives.log /var/log/bootstrap.log && \
	rm -f /var/log/apt/history.log /var/log/apt/term.log && \
	rm -rf /usr/share/man/* /usr/share/groff/* /usr/share/info/* && \
	rm -rf /usr/share/lintian/* /usr/share/linda/* && \
	find /usr/share/doc -not -type d -not -name 'copyright' -delete && \
	find /usr/share/doc -type d -empty -delete
