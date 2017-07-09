# Introducción #

El proceso de **Oferta de publicación de un usuario** ocurre cuando un
transportista selecciona una para realizar su propuesta de servicio,
indicando su servicio y el precio del mismo.

# Proceso #

El proceso consta de lo siguiente:

*Diagrama BPMN*

# Pasos #

Como se muestra en el diagrama BPMN, el proceso consta de los siguientes pasos.

## Selección de una publicación para ofertar ##

El transportista observa la pantalla con todas las publicaciones de usuarios
disponibles. Selecciona una para poder realizarle una oferta

## Ofertar una publicación ##

El tranportista ve una pantalla con la siguiente información de la publicación:
* Mapa que indicar el origen y destino.
* Información sobre el origen, y las condiciones de retiro.
* Información sobre el destino, y las condiciones de entrega
* Información sobre los artículos a enviar:
    * La cantidad de artículos
    * Si necesitan cuidados especiales
    * Si necesitan ser envueltos en mantas
    * Dimensiones y peso de cada artículo
    
El transportista podrá realizar una oferta a dicha publicación indicando:
* Fecha y hora de retiro propuesta.
* Fecha y hora de entrega propuesta.
* Costo del servicio.
    
Observar que se indica que las fechas y horas, tanto de retiro como entrega,
son una propuesta que realiza el transportista. Esto se debe a que el usuario
indica unas condiciones de retiro, pero que puede ser que el transportista
no las pueda cumplir. Entonces él, propone unas para ver si siguen siendo
útiles para el usuario

## Notificación de que se realizó una oferta ##

El sistema se encargará de notificar vía mail al usuario de que un transportista
realizó una oferta a su publicación.