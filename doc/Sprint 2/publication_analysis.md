# Tabla de Contenidos #

* [Introducción](#introduction)
* [Diagrama BPMN](#bpmn_diagram)
* [1 - Selección de categoría](#category_selection)
    * [1.1 - Estructura](#category_selection)
* [2 - Ingreso de información de los artículos a transportar](#information_input)
* [3 - Ingreso de información de retiro/entrega](#service_condition)
* [4 - Logueo o registro del usuario](#user_login)
* [4.1 - Publicación sin logueo o registro](#user_sign_up)
* [5 - Envío de mail al usuario](#mailing)
* [6 - Cancelación o eliminación de la publicación](#publication_cancel_delete)

# Introducción #

Debido a que el proceso de publicación es una de las partes
más críticas del sistema (Por no decir que es la más crítica),
se ha planteado realizar un profundo análisis del mismo.

A continuación, se realizará un análisis a dicho proceso, que
ayudará en la hora de la implementación del mismo.

# Diagrama BPMN #

El siguiente diagrama BPMN muestra de forma gráfica los pasos
y condiciones del proceso.

*Diagrama BPMN del proceso de publicación.*

Se pensó en un proceso sencillo para permitir que el usuario posea
una facilidad en la ejecución del mismo, aunque tomando precauciones
en no dejar ninguna actividad o punto importante fuera del mismo.

# 1. Selección de categoría #

Para facilitar una categorización y filtrado en la búsquedas de
publicaciones de viaje por parte de los transportistas, se ha 
decidido bridar una categorización a lo que se desea transportar.
Además, ayudará a los usuarios a especificar mejor lo que
quieren trasladar.

En el momento que el usuario desee dar de alta una publicación
de un viaje, se le presentará en pantalla las diferentes categorías
disponibles para caracterizar a su viaje.

## 1.1 - Estructura ##

Luego de un intenso análisis, se ha concluido que las categoría y
subcategorías deberían ser las siguientes:

* Vehículos y barcos: Automóviles, Motos, Remolques, Partes de Vehículos.
    * Automóviles y Camiones ligeros.
    * Motocicletas y Ciclomotores.
    * Botes de motor.
    * Veleros.
    * Motos acuáticas y otros botes.
    * Casa rodante.
    * Vehículos todo terreno.
    * Camiones comerciales.
    * Maquinaria agrícola.
    * Maquinaria de construcción.
    * Remolques.
    * Otro tipo de vehículos.
* Artículos domésticos: Muebles, Electrodomésticos.
    * Muebles.
    * Electrodomésticos.
    * Aparatos electrónicos.
    * Equipamiento de aire libre.
    * Equipamiento deportivo.
    * Antigüedades.
    * Artes y vidrios.
    * Pianos.
    * Mesa de billar.
* Mudanzas: Departamento, casa, oficina.
    * Estudio pequeño.
    * Departamento en planta baja.
    * Departamento en piso superior (Piso 1 y superiores).
    * Casa.
* Maquinaria pesada: Construcción, Agricultura.
* Flete: Tarima con artículos, Carga completa.
    * Tarimas de artículos nuevos.
    * Tarimas de artículos usados.
    * Carga completa: se denomina así a cargas que completan todo 
    el espacio brindado por el vehículo que transporta. Tiende a 
    ser más barato, aunque son contratados exclusivamente por 
    empresas grandes, con grandes necesidades de transporte.
* Animales:Perros, Gatos, Ganado.
    * Perros.
    * Gatos.
    * Caballos.
    * Ganado.
    * Otros tipos de animales.
* Otro tipo de envío: artículo que no coincide en ninguna
 de las categorías mencionadas anteriormente, o un envío
 con artículos de varias categorías.
 
Un punto aparte merece el apartado de mudanzas en departamentos.
Se diferencia de si se encuentra en planta baja o piso superior
debido a que, en algunas circunstancias, se requieren equipamiento
especializado como poleas para el descenso de objetos de gran
tamaña a través de los pisos.

# 2 - Ingreso de información de los artículos a transportar #

A continuación se deberá ingresar la información que ayudará a indicar
lo que se desea transportar en sí.

Con respecto al viaje en general, se deberá indicar:

* Título de la publicación: descripción breve de lo que se quiere 
transportar.
* Cantidad de artículos: número de artículos a transportar.
* ¿Cuidado especial?: si se debe tener cuidados especiales en el
transporte de los artículos.
* ¿Envoltura con mantas?: si se deben envolver con mantas los artículos
transportados.

Con respecto a cada artículo introducido, se deberá indicar:

* Medidas y peso: dimensiones que indican el tamaño y peso. En 
algunas categorías es  obligatorio la introducción de las mismas, 
aunque en otros no. Ésto se debe a que en ciertos tipos de 
artículos es sensato que se deba indicar dichas propiedades (Como 
por ejemplo un *Mueble*: es necesario saber que tan grande y pesado es),
aunque en otras no tendría sentido (Como por ejemplo un *Perro*).
* ¿Artículo paletizado?: se indica si el artículo ingresado está en
palets de madera o plástico y se puede movilizar con montacargas.
* ¿Artículo en caja?: se indica si el artículo ingresado está 
guardado en caja de madera o de plástico.
* ¿Artículo apilable?: se indica si el artículo tiene superficies 
planas y puede sostener el peso de otro objeto.
* Detalles adicionales: información adicional que el usuario 
pueda proveer y que ayude a una mayor descripción del artículo 
a transportar.

Dichos datos servirán a los transportistas a saber que se necesita
transportar, para así poder dar el presupuesto correcto.

*Ver diagrama de clases de análisis para más información*

# 3 - Ingreso de información de retiro/entrega #

El tercer paso se refiere a la introducción de información referida
al retiro y a la entrega, y a las condiciones del mismo. Básicamente
se pueden analizar cuatro atributos principales:

* Dirección de retiro: domicilio de donde se recogerá los artículos
a transportar.
* Dirección de entrega: domicilio en donde se entregarán los artículos.
* Condición de retiro: indicaciones de que días y horarios se deben
pasar a recoger los artículos a transportar.
* Condición de entrega: indicaciones de que días y horarios se deben
entregar los artículos transportados.

Las condiciones de servicio (Condición de retiro/entrega) se refieren
a las condiciones que el cliente establece en lo que respecta al
horario y días en los que los artículos deben ser retirados y
entregados. Existen 4 tipos:

* Condición *"Antes de"*: sirve para indicar que los artículo se debe
retirar/entregar antes de la fecha indicada.
* Condición *"Después de"*: sirve para indicar que los artículos se deben
retirar/entregar después de la fecha indicada.
* Condición *"En"*: sirve para indicar que los artículos se deben
retirar/entregar en la fecha indicada.
* Condición *"Entre"*: sirve para indicar que los artículos se deben
retirar/entregar entre las fechas indicadas.

En los 4 tipos de condiciones además se pueden indicar los horarios
entre los cuales se podrá retirar los artículos, y los horarios en
los que se deberá entregar el artículo.

**Puede darse el caso de que no se indiquen condiciones de servicio,
en lo que significará que no hay ninguna necesidad u obligación en
cumplir requisitros de retiro y/o entrega**. Por lo tanto, además de
las 4 opciones de servicio, se debe dar una extra en la cual brinde
la posibilidad de no exigir ninguna, tanto en los horarios como en las
fechas, ya que puede ser que se necesita que se retire en una fecha,
aunque no importe el horario de retiro (O viceversa).


# 4 - Logueo o registro del usuario #

Una vez que se introdujeron los datos necesarios para realizar el envío,
en el caso de que el usuario no este logueado, se procederá a pedirle
que ingrese sus credenciales para loguearse o, si no posee una cuenta 
previa, registrarse en la plataforma.

Gracias al paso anterior se podrá saber que usuario ha realizado
el pedido.

## 4.1 - Publicación sin logueo o registro ##

Muchas páginas web (Principalmente las de reserva de hoteles, como 
[Booking.com](https://www.booking.com/) u [Hotels.com](https://www.hotels.com/))
no obligan al usuario a registrarse o loguearse para confirmar 
sus reservas, para así evitar el incordio que ésto puede generar
y permitir el uso de la plataforma a clientes más casuales (Algo
muy común en ese tipo de páginas).

Se pensó lo mismo para eCarriers, aunque se descartó la posibilidad
de aplicar dicho proceso debido principalmente a dos causas:
1. Es necesario tener un usuario registrado, para los casos problemáticos
o que surja la necesidad de una mediación. Además se pensó la plataforma
para un uso sostenido en el tiempo por parte de los mismos.
2. eCarriers fue pensada como una versión MVP (Minimum Viable Product),
por lo que no tiene sentido complejizar el proceso.

# 5 - Envío de mail al usuario #

El sistema automáticamente enviará un mail al usuario confirmándole
que se ha registrado exitosamente e indicándole los datos ingresados.

# 6 - Cancelación o eliminación de la publicación #

Debido a que la publicación podría contener un error, o que ya no se
desee más el servicio de un transportista, se podrá cancelarla o 
eliminarla, **siempre y cuando el usuario no haya aceptado previamente 
la oferta de un transportista**.

La diferencia entre ambas acciones se basa en:
* *Cancelar una publicación* se refiere a que se deja de mostrar en la
plataforma y, por lo tanto, los transportistas no podrán verla. Sin
embargo, el usuario podrá seguir viéndola, editarla y volverla a
publicar.
* *Eliminar una publicación* se refriere a que no sólo que no se mostrará
más en la plataforma, sino que el usuario tampoco la verá más, ni se
podrá volver a publicarla nuevamente.