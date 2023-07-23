/*TDA unidad*/
/*Este TDA representa lo que es una unidad*/
/*representacion, al igual que los demas, sera una lista de elementos*/
/*Letter (string or char), Name (string), Data (list), Capacity (int)*/
:-module(tdaunidad, [unidad/6,get_id_unidad/2, get_letter_unidad/2,get_name_unidad/2,get_data_unidad/2,get_capacity_unidad/2,mod_letter_unidad/3,mod_name_unidad/3,mod_data_unidad/3,mod_capacity_unidad/3,borrarUnidad/3,
obtenerUnidadActual/2]).
/*constructor*/
unidad(ID,Letter,Name,Data,Capacity,[ID,Letter,Name,Data,Capacity]).

/*...................................Capa selectora-----------------------------*/

/*todos los selectores reciben a un TDAunidad como argumento,y devolveran
un atributo pedido.
--> Meta: explicita para cada selector*/
get_id_unidad([ID,_,_,_,_],ID).
get_letter_unidad([_,Letter,_,_,_],Letter).
get_name_unidad([_,_,Name,_,_],Name).
get_data_unidad([_,_,_,Data,_],Data).
get_capacity_unidad([_,_,_,_,Capacity],Capacity).

/*--------------------------------- Capa modificadora --------------------------------*/
/*Todos los modificdores reciben a una unidad como argumento, el valor nuevo a modificar y una variable que se unificara
con la nueva unidad (modificada) usando el constructor*/
/*metas:-> modificar atributos, (explicito)*/
mod_letter_unidad(Unidad,NewLetter,NewUnidad):-
    get_id_unidad(Unidad,ID),
    get_name_unidad(Unidad,Name),
    get_data_unidad(Unidad,Data),
    get_capacity_unidad(Unidad,Capacity),

    unidad(ID,NewLetter,Name,Data,Capacity,NewUnidad).



mod_name_unidad(Unidad,NewName,NewUnidad):-
    get_id_unidad(Unidad,ID),
    get_letter_unidad(Unidad,Letter),
    get_data_unidad(Unidad,Data),
    get_capacity_unidad(Unidad,Capacity),

    unidad(ID,Letter,NewName,Data,Capacity,NewUnidad).

mod_data_unidad(Unidad,NewData,NewUnidad):-
    get_id_unidad(Unidad,ID),
    get_name_unidad(Unidad,Name),
    get_letter_unidad(Unidad,Letter),
    get_capacity_unidad(Unidad,Capacity),

    unidad(ID,Letter,Name,NewData,Capacity,NewUnidad).

mod_capacity_unidad(Unidad,NewCapacity,NewUnidad):-
    get_id_unidad(Unidad,ID),
    get_letter_unidad(Unidad,Letter),
    get_name_unidad(Unidad,Name),
    get_data_unidad(Unidad,Data),

    unidad(ID,Letter,Name,Data,NewCapacity,NewUnidad).

/*predicado para borrar una unidad desde una lisra de unidades*/
borrarUnidad([X|R],Letter,R):-
    get_letter_unidad(X,L), L = Letter, !.
borrarUnidad([X|R],Letter,[X|R2]):-
    borrarUnidad(R,Letter,R2).

obtenerUnidadActual([X|_],X):-!.
