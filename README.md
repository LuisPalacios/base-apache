# Introducción

Este repositorio alberga un *contenedor Docker* para montar un Servidor Web usando "apache2" y "php5", está automatizado en el Registry Hub de Docker [luispa/base-apache](https://registry.hub.docker.com/u/luispa/base-apache/) conectado con el el proyecto en [GitHub base-apache](https://github.com/LuisPalacios/base-apache)


## Ficheros

* **Dockerfile**: Para crear un servidor "web" basado en debian
* **fig.yml**: Para poder usar el comando [fig](http://www.fig.sh/index.html)
* **sample**: Directorio con index.html y phpinfo.php para hacer pruebas

## Instalación de la imagen

Para usar la imagen desde el registry de docker hub

    totobo ~ $ docker pull luipa/base-apache


## Clonar el repositorio

Este es el comando a ejecutar para clonar el repositorio y poder trabajar con él directametne

    totobo ~ $ clone https://github.com/LuisPalacios/docker-apache.git

Luego puedes usar el programa [fig](http://www.fig.sh/index.html) para crear la imagen, etc.

En mi caso utilizo esta imagen como base para otras futuras, así que simplemente ejecuto

    $ fig build
