# Tabla de Contenidos #

* [Introducción](#introduction)
* [Pantalla por defecto](#default_screen)
* [Opciones de filtro](#filter_options)
* [Opciones de orden](#order_options)

# Introducción #

El proceso de **Búsqueda de publicaciones de envío** consiste en
aquel que se desarrolla cuando un transportista procede a buscar
publicaciones de viajes hechas por usuarios para poder ofertar.
 
Existe la posiblidad de aplicar filtros, para lograr una mayor 
posibilidad de encontrar una publicación que el transportista
esté en condición de  satisfacer.

# Pantalla por defecto #

Cuando se ingrese a la pantalla de búsqueda, se mostrará por defecto
todos los viajes publicados, en forma páginada, ordenandolos de más
recientes a menos recientes, y teniendo en cuenta que:

* Su fecha de retiro no debe estar establecida, o sea igual o mayor al día
actual.
* El usuario no haya aceptado ya la oferta de algún transportista.

La estructura de la tabla será la siguiente:

| Envío | Precio | Origen | Destino | Kilómetros |
|---|---|---|---|---|
| <ul><li>Título.</li><li>Fecha de publicación.</li><li>Ícono de la categoría.</li><li>Medidas.</li><li>Descripción adicional.</li></ul> | <ul><li>Cantidad de ofertas.</li><li>Oferta más baja.</li></ul> | Nombre ciudad de origen. | Nombre ciudad de destino. | Cantidad de kilómetros del viaje. |

# Opciones de filtro #

Para lograr encontrar publicaciones que sean de interés al transportista,
se podrá indicar uno o más de los siguientes campos, el cual la
publicación debe cumplirlos a todos (Condición **AND**). Se dividen en 3
tipos de condiciones:

*Condiciones propias del envío:*
* Coincidencia en el título: se permitirá el ingreso de una o
más palabras, y se mostrará todas las publicaciones que posean dicho
texto en el título.
* Categoría: se permitirá ingresar las categorías o sus subcategorías.
Se mostrarán todas las publicaciones que fueron clasificadas en dichas
categorías o subcategorías.
* ¿Necesita cuidado especial?: tendrá 3 opciones: **Sí**-**No**-
**No establecido**. Las dos primeras mostrarán los envío que necesiten 
(o no) un cuidado especial. Si no está establecido, no filtrará por 
dicho atributo.
* ¿Necesita ser envuelto con mantas?: tendrá 3 opciones: **Sí**-**No**-
**No establecido**. Las dos primeras mostrarán los envío que necesiten 
(o no) ser envuelto en mantas. Si no está establecido, no filtrará por 
dicho atributo.

*Condiciones geográficas:*
* Ciudad de retiro.
* Ciudad de entrega.
* Región de retiro.
* Región de entrega.
* País de retiro.
* País de entrega.

*Condiciones temporales:*
* Fecha de retiro: **Antes**-**En**-**Después** de una fecha indicada.
* Fecha de entrega: **Antes**-**En**-**Después** de una fecha indicada.

# Opciones de orden #

En lo que respecta al orden, se puede realizarlo teniendo en cuenta
los siguientes aspectos:

* Fecha de publicación.
* Cantidad de kilómetros.
* Cantidad de ofertas.
* Oferta más baja.
