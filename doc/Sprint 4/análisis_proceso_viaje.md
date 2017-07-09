# Introducción #

A continuación, se realizará un análisis del *Proceso de un viaje*, 
que incluye desde que se da de alta una publicación, el retiro
de los artículos, el viaje y la entrega de los artículos.

# Proceso #

El proceso consta de lo siguiente:

*Diagrama BPMN*

# Pasos #

## Transportista da de alta un viaje ##

Se produce cuando el transportista da de alta un viaje. Se deberán 
indicar los siguientes datos:
* Fecha y hora de salida.
* Fecha y hora estimada de llegada.
* Origen y destino.
* Envíos (publicaciones) que serán llevados en ese viaje.

## Asignar publicaciones que serán transportadas en el viaje ##

La asignación de las publicaciones consta de indicar qué publicaciones
serán transportadas en este viaje. Esto servirá para poder indicar la 
ubicación de cada envío en un momento dado.

Solamente pueden asignarse los envíos que el transportista ha 
ofertado, y que su oferta fue aceptada.

## Posibles estados de la publicación ##

Una publicación, puede tener 4 estados
* **Evaluando propuestas:** el cliente está evaluando diferentes 
propuestas para decidir cuál es la más conveniente.
* **Esperando retiro**: el cliente eligió la mejor propuesta, y está
esperando a que retiren sus artículos.
* **Viajando**: los artículos están siendo transportados.
* **Entregada**: los artículos de la publicación fueron entregados.

## Posibles estados del viaje ##

* **Falta retirar artículos**: Estado inicial, cuando el viaje fue dado 
de alta. Los artículos no fueron retirados todavía.
* **Viajando**: Estado que se presenta cuando todas los artíclos fueron
retirados, y están siendo transportados
* **Finalizado**: El viaje ha finalizado debido a que **todos** los 
artículos fueron entregados.

