FROM jarischaefer/baseimage-ubuntu:2.4-1

ARG COMPOSER_VERSION=1.10.17
ARG NET_IPV4_VERSION=1.3.5
ARG NET_IPV6_VERSION=174b5756d87627590a3c1624657bd32905addc4f

RUN	echo 'LANG=C.UTF-8' > /etc/default/locale && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C C300EE8C && \
	echo 'deb http://ppa.launchpad.net/ondrej/php/ubuntu bionic main' > /etc/apt/sources.list.d/ondrej-php7.list && \
	echo 'deb http://ppa.launchpad.net/nginx/development/ubuntu bionic main' > /etc/apt/sources.list.d/nginx.list && \
	apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq install --no-install-recommends \
		dnsutils \
		nginx \
		php7.4-cli \
		php7.4-fpm \
		php7.4-mysql \
		php7.4-gd \
		php7.4-curl \
		php7.4-opcache \
		php7.4-ldap \
		php7.4-mbstring \
		php7.4-memcached \
		php7.4-snmp \
		php7.4-xml \
		php7.4-zip \
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
		rrdcached \
		rrdtool \
		sendmail \
		smbclient \
		git \
		sudo \
		curl \
		ipmitool \
		acl \
		vim-tiny \
		unzip \
		python-mysqldb \
		python-ipaddress \
        python-memcache \
		python3-mysqldb \
		python3-memcache \
		python3-pip \
		python3-setuptools \
		python3-psutil \
		libodbc1 \
		odbcinst \
		snmptrapd && \
	curl -sSL -o - https://github.com/microsoft/msphpsql/releases/download/v5.8.1/Ubuntu1804-7.4.tar | tar -x -C /tmp && \
    mv /tmp/Ubuntu1804-7.4/php_sqlsrv_74_nts.so /usr/lib/php/20190902/mssql.so && \
    echo 'extension=mssql.so' > /etc/php/7.4/mods-available/mssql.ini && \
    ln -s /etc/php/7.4/mods-available/mssql.ini /etc/php/7.4/cli/conf.d/30-mssql.ini && \
    ln -s /etc/php/7.4/mods-available/mssql.ini /etc/php/7.4/fpm/conf.d/30-mssql.ini && \
    \
	curl -sSL -o - https://github.com/pear/Net_IPv4/archive/v${NET_IPV4_VERSION}.tar.gz | tar -xz -C /tmp && \
	cd "/tmp/Net_IPv4-${NET_IPV4_VERSION}" && \
	pear install package.xml && \
	curl -sSL -o - https://github.com/pear/Net_IPv6/archive/${NET_IPV6_VERSION}.tar.gz | tar -xz -C /tmp && \
	cd "/tmp/Net_IPv6-${NET_IPV6_VERSION}" && \
	pear install package.xml && \
	\
	curl -sSL -o /usr/local/bin/composer "https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar" && \
	chmod +x /usr/local/bin/composer && \
	\
	rm -rf /etc/nginx/sites-available/* /etc/nginx/sites-enabled/* && \
	useradd librenms --home-dir /opt/librenms --system --shell /bin/bash && \
	usermod -a -G librenms www-data && \
	chmod u+s /usr/bin/fping /usr/bin/fping6 /usr/lib/nagios/plugins/check_dhcp /usr/lib/nagios/plugins/check_icmp && \
	sed -i 's/session.*required.*pam_loginuid.so//g' /etc/pam.d/cron && \
	\
	apt-get -yq autoremove --purge && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/* && \
	rm -f /var/log/dpkg.log /var/log/alternatives.log /var/log/bootstrap.log && \
	rm -f /var/log/apt/history.log /var/log/apt/term.log && \
	rm -rf /usr/share/man/* /usr/share/groff/* /usr/share/info/* && \
	rm -rf /usr/share/lintian/* /usr/share/linda/* && \
	find /usr/share/doc -not -type d -not -name 'copyright' -delete && \
	find /usr/share/doc -type d -empty -delete
