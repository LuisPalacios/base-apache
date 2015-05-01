#
# Web server base by Luispa, Nov 2014
#
# -----------------------------------------------------
#

# Desde donde parto...
#
FROM debian:jessie

#
MAINTAINER Luis Palacios <luis@luispa.com>

# Pido que el frontend de Debian no sea interactivo
ENV DEBIAN_FRONTEND noninteractive

# Actualizo el sistema operativo e instalo paquetes de software
#
RUN apt-get update && \
    apt-get -y install locales \
                       wget \
                       curl 

# Preparo locales
#
RUN locale-gen es_ES.UTF-8
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

# Preparo el timezone para Madrid
#
RUN echo "Europe/Madrid" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata

# Workaround para el Timezone, en vez de montar el fichero en modo read-only:
# 1) En el DOCKERFILE
RUN mkdir -p /config/tz && mv /etc/timezone /config/tz/ && ln -s /config/tz/timezone /etc/
# 2) En el Script entrypoint:
#     if [ -d '/config/tz' ]; then
#         dpkg-reconfigure -f noninteractive tzdata
#         echo "Hora actual: `date`"
#     fi
# 3) Al arrancar el contenedor, montar el volumen, a contiuación un ejemplo:
#     /Apps/data/tz:/config/tz
# 4) Localizar la configuración:
#     echo "Europe/Madrid" > /Apps/data/tz/timezone
 
## Añado soporte de php55 dotdeb
#RUN echo "deb http://packages.dotdeb.org wheezy all" | tee /etc/apt/sources.list.d/dotdeb.list
#RUN echo "deb-src http://packages.dotdeb.org wheezy all" | tee -a /etc/apt/sources.list.d/dotdeb.list
#RUN echo "deb http://packages.dotdeb.org wheezy-php55 all" | tee -a /etc/apt/sources.list.d/dotdeb.list
#RUN echo "deb-src http://packages.dotdeb.org wheezy-php55 all" | tee -a /etc/apt/sources.list.d/dotdeb.list
#RUN curl -s http://www.dotdeb.org/dotdeb.gpg | apt-key add -

# Instalo PHP
RUN apt-get update && \
    apt-get install -y --force-yes 	php5 \
									php5-cli \
									php5-common \
									apache2 \
									libapache2-mod-php5 \
									php5-pgsql \
									php5-json \
									php5-xsl \
									php5-intl \
									php5-mcrypt \
									php5-gd \
									php5-curl \
									php5-memcached \
									php5-mysql

# Limpieza
RUN apt-get clean & rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite ssl headers php5

## Instalo Composer
#RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# PHP 5 
# Let's set the default timezone in both cli and apache configs
RUN sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Europe\/Madrid/g' /etc/php5/cli/php.ini
RUN sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Europe\/Madrid/g' /etc/php5/apache2/php.ini

# Copio el fichero de configuración de Apache
ADD ./000-default.conf /etc/apache2/sites-available/000-default.conf

# Recuerda que deberias copiar un fichero 404.php en /var/www

# Set Apache environment variables (can be changed on docker run with -e)
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_SERVERADMIN admin@localhost
ENV APACHE_SERVERNAME totobo
ENV APACHE_SERVERALIAS totobo.luispa.com
#ENV APACHE_DOCUMENTROOT /var/www

## Script que uso a menudo durante las pruebas. Es como "cat" pero elimina líneas de comentarios
RUN echo "grep -vh '^[[:space:]]*#' \"\$@\" | grep -v '^//' | grep -v '^;' | grep -v '^\$' | grep -v '^\!' | grep -v '^--'" > /usr/bin/confcat
RUN chmod 755 /usr/bin/confcat

#-----------------------------------------------------------------------------------

# Ejecutar siempre al arrancar el contenedor este script
#
ADD do.sh /do.sh
RUN chmod +x /do.sh
ENTRYPOINT ["/do.sh"]
