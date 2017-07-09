# Tabla de contenidos #

* [Introducción](#introduction)
* [Installation](#installation)
* [Configuración](#configuration)
	* [config/secrets.yml](#secrets.yml)
	* [config/database.yml](#database.yml)
* [Entorno](#enviroment)

# Introducción #

eCarriers es un proyecto desarrollado para la cátedra "Proyecto Final" de
la carrera "Ingeniería en Sistemas de Información".

Consta de un mercado virtual de Transportistas y Clientes que poseen
necesidades de traslado de bienes.

# Instalación #

La primera cosa que hay que hacer es obtener y clonar el código
fuente. Para ésto, pararse en la carpeta deseada y ejecutar:

```bash
$ git clone --recursive git@bitbucket.org:proyectofinal_ecarriers/ecarriers.git
```
Una vez instalado, ejecutar:

```bash
$ bundle install
```

Antes de iniciar el servidor, ejecutar las migraciones:
```bash
$ rake db:migrate
```

Por último, poblar la Base de Datos:
```bash
$ rake db:seed
```

# Configuración #

Para lograr un correcto funcionamiento de la máquina virtual, se
deben editar los siguientes archivos.

## config/secrets.yml ##

Se debe agregar el archivo secrets.yml dentro de la carpeta config, 
con la siguiente estructura (Suponiendo que se usará una cuenta de
gmail para el mailing):

```
development:
  address: smtp.gmail.com
  domain_name: gmail.com
  email_provider_username: example@gmail.com
  email_provider_password: password

  password_pepper: some_password_papper

  secret_key_base: some_secret_key_base

test:
  address: smtp.gmail.com
  domain_name: gmail.com
  email_provider_username: example@gmail.com
  email_provider_password: password
    
  password_pepper: some_password_papper
    
  secret_key_base: some_secret_key_base

production:
  address: smtp.gmail.com
  domain_name: gmail.com
  email_provider_username: example@gmail.com
  email_provider_password: password
  
  password_pepper: some_password_papper
  
  secret_key_base: some_secret_key_base
```

## config/database.yml ##

En caso de ser necesario, se debe editar el archivo `confi/database.yml`
para brindarle la información necesaria y poder conectarse así a la
Base de Datos.

Un ejemplo es:

```
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5
  username: database-username
  password: database-password

development:
  <<: *default
  database: ecarriers_development

test:
  <<: *default
  database: ecarriers_test

production:
  <<: *default
  database: ecarriers_production
  username: <%= ENV['ECARRIERS_DATABASE_USERNAME'] %>
  password: <%= ENV['ECARRIERS_DATABASE_PASSWORD'] %>
```

# Entorno de desarrollo #

Existe un entorno que ayuda en el desarrollo, compuesto por una
máquina virtual que permite y brinda el conjunto de herramientas
necesarias para poder ejecutar eCarriers sin ningún problema. 
De igual forma, se puede instalar y configurar los programas 
localmente, en vez de usar la máquina virtual (Aunque es preferible
usar la máquina virtual). Tener en cuenta que eCarriers usa:
* Ruby >= 2.2
* Rails >= 4.0
* PostgreSQL

En cuanto a la Base de Datos, sus credenciales son:
* Usuario: e-carriers
* Contraseña: ruby

Para iniciar el servidor, ejecutar:
```bash
# Redireccionar todas las peticiones que lleguen al puerto 80 al puerto 3000
$ sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to 3000

# Iniciar servidor
$ rails server -b 0.0.0.0
```

# Generación de documentación #

## Diagramas ERD ##

Para generar un diagrama ERD, ejecutar lo siguiente:
```bash
$ bundle exec erd --filetype=png --direct=true --orientation=vertical
```

Tener en cuenta que eso va a generar un archivo `erd.png` en la raíz del proyecto. Editar el nombre
y guardarlo dentro de la carpeta `/doc`.