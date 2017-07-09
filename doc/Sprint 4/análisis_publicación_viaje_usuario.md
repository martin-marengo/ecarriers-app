# Análisis Publicacion de viaje #

Es el proceso por el cual un cliente (usuario web) publica un viaje ocacional que va a realizar y en el cual espera
realizar uno o mas envíos a otros usuarios.

Cada publicación debe indicar las ciudades de origen y destino, fecha y hora de partida, fecha y hora estimadas de llegada y
una descripción del tipo de vehículo que va a utilizar para realizar el viaje.

Cada usuario será capaz de dar de alta, editar, eliminar, ocultar a otros usuarios y volver a mostrar una publicación.

# Análisis preliminar del resto del proceso (Pedido de Envío, Sprint 5)#

Cuando un usuario ve una publicación de viaje de otro usuario, puede hacer un Pedido de Envío, el cual consta de una
descripción en donde deberá explicar el o los artículos que desea enviar (esta acción genera una notificación via email
al usuario que hizo la publicación).

A partir de este momento, cualquiera de los dos puede iniciar una conversación, dejando un comentario en el pedido de envío.
Esto se hace con el propósito de aclarar cualquier duda que exista.

A su vez, una vez hecho el pedido de envío, el usuario que va a realizar el viaje puede darle un presupuesto, que consta
únicamente del precio que le va a cobrar por realizar el servicio de envío. En caso de no estar interesado,
puede rechazar el pedido de envío, o bien, ignorarlo.

Por otro lado, cuando el usuario que realizó el pedido de envío recibe un presupuesto, puede aceptarlo, rechazarlo o ignorarlo.
En caso de aceptar el presupuesto, queda pactado el envío entre las dos partes.

Cabe aclarar que cualquiera de las acciones anteriores va a notificar por email a la otra parte.


