# Introducción

Este repositorio alberga un *contenedor Docker* para montar un Servidor Web usando "apache2" y "php5"


## Ficheros

* **docker-apache/Dockerfile**: Para crear un servidor "web" basado en debian
* **docker-apache/sample/index.html**: Ejemplo para poner el site
* **docker-apache/sample/phpinfo.php**: Ejemplo para poner el site y probar php

## Instalación

Este es el comando a ejecutar para clonar el repositorio:

    totobo ~ $ clone https://github.com/LuisPalacios/docker-apache.git


# Ejecución con "Fig"

Es la opción más sencilla, te recomiendo instalar el programa
    [fig](http://www.fig.sh/index.html) y usarlo para crear la imagen, ejecutar el contenedor, ver su estado, etc.

En mi caso utilizo esta imagen como base para otras futuras, así que simplemente ejecuto

    $ fig build
