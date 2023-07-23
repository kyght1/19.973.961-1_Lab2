/*aca creo un TDA que representa una ruta cada vez que se crea, borra, actualiza, o modifica un directorio o archivo*/
/*una ruta sera representada con una lista que consistira en
Dom--> Id elemento  (NUM), nombreElemento(string), IDpadre(num), Hijos(LIST)
Meta-->Lista por unificacion de los elementos del dominio*/
:-module(tdaruta,[ruta/6,get_IDelement_ruta/2,get_nameElement_ruta/2,get_IDpadre_ruta/2,get_hijos_ruta/2,mod_nameElement_ruta/3,mod_hijos_ruta/3,borrarRuta/4,
obtenerRutaActual/2,get_ruta/3,get_ruta_DadoIDPadre/4,get_StringForm_ruta/2,mod_id_ruta/3,mod_idpadre_ruta/3,mod_stringForm_ruta/3]).
/*constructor*/

ruta(IDElement,NameElement,IDPadre,Hijos,StringForm,[IDElement,NameElement,IDPadre,Hijos,StringForm]).

/*selectores*/
get_IDelement_ruta([ID,_,_,_,_],ID).
get_nameElement_ruta([_,Name,_,_,_],Name).
get_IDpadre_ruta([_,_,IDP,_,_],IDP).
get_hijos_ruta([_,_,_,Hijos,_],Hijos).
get_StringForm_ruta([_,_,_,_,StringForm],StringForm).
/*capa modificadora*/
/*Todas las capas reciben una ruta determinada para modificar algun aspecto en especifico (insercion de elementos o borrado de estos)*/
mod_nameElement_ruta(Ruta,NewnameElement,NewRoute):-
    get_IDelement_ruta(Ruta,ID),
    get_IDpadre_ruta(Ruta,IDP),
    get_hijos_ruta(Ruta,Hijos),
    get_StringForm_ruta(Ruta,StringForm),
    ruta(ID,NewnameElement,IDP,Hijos,StringForm,NewRoute).

/*modificar hijos*/
mod_hijos_ruta(Ruta,NewHijos,NewRoute):-
    get_IDelement_ruta(Ruta,ID),
    get_nameElement_ruta(Ruta,Name),
    get_IDpadre_ruta(Ruta,IDP),
    get_StringForm_ruta(Ruta,StringForm),
    ruta(ID,Name,IDP,NewHijos,StringForm,NewRoute).

mod_id_ruta(Ruta,NewId,NewRoute):-
    get_nameElement_ruta(Ruta,Name),
    get_IDpadre_ruta(Ruta,IDP),
    get_StringForm_ruta(Ruta,StringForm),
    get_hijos_ruta(Ruta,Hijos),
    ruta(NewId,Name,IDP,Hijos,StringForm,NewRoute).

mod_idpadre_ruta(Ruta,NewID,NewRoute):-
    get_IDelement_ruta(Ruta,ID),
    get_nameElement_ruta(Ruta,Name),
    get_StringForm_ruta(Ruta,StringForm),
    get_hijos_ruta(Ruta,Hijos),
    ruta(ID,Name,NewID,Hijos,StringForm,NewRoute).

mod_stringForm_ruta(Ruta,NewStr,NewRoute):-
    get_IDelement_ruta(Ruta,ID),
    get_nameElement_ruta(Ruta,Name),
    get_hijos_ruta(Ruta,Hijos),
    get_IDpadre_ruta(Ruta,IDP),
    ruta(ID,Name,IDP,Hijos,NewStr,NewRoute).


/*predicado que borra una ruta desde una lista de rutas, con un ID padre*/
borrarRuta([X|R],Name,IDPadre,R):-
    get_nameElement_ruta(X,NE), get_IDpadre_ruta(X,IDaux), NE == Name,IDPadre == IDaux, !.
borrarRuta([X|R],Name,IDPadre,[X|R2]):-
    borrarRuta(R,Name,IDPadre,R2).
/*------------------------*/
obtenerRutaActual([X|_],X):-!.
/*predicado que obtiene una ruta determinada, en particular, la raiz*/

get_ruta([X|_],Letter,X):-
    get_nameElement_ruta(X,L1), L1 == Letter, !.
get_ruta([_|R],Letter,E):-
    get_ruta(R,Letter,E).

/*predicado que obtiene una ruta dada un ID padre y nombre*/
get_ruta_DadoIDPadre([X|_],IDpadre,Nombre,X):-
    get_IDpadre_ruta(X,ID),get_nameElement_ruta(X,Name),IDpadre == ID, Nombre == Name,!.
get_ruta_DadoIDPadre([_|R],IDpadre,Nombre,X):-
    get_ruta_DadoIDPadre(R,IDpadre,Nombre,X).