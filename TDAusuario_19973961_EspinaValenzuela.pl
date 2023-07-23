/*A continuacion.. el TDAusuario*/
/*para su representacion, se hara uso del manejo de listas provenientes del lenguaje*/
:- module(tdausuario,[user/3,get_user_name/2,get_user_state/2,mod_user_state/3]).
/*defino la capa constructora
predicado constructor
DOM--> name (string), state (estado usuario, logueado o no)
Meta--> Una lista que represente a un usuario mediante una unificacion con una variable libre*/
user(Name,State,[Name,State]).

/*---------------------------- Capa Selectora--------------------------*/
/*toda la capa selectora recibira como argumento una lista representativa de un usuario
Meta-> devolver algun componente de un usuario (explicito)*/

get_user_name([Name,_],Name).
get_user_state([_,State],State).

/*--------------------------Capa Modificadora-------------------------------------*/
/*Todos los modificadores reciben a un usuario, un nuevpo valor a modificar 
y una variable que sera unificada con un nuevo usuario modificado*/
mod_user_state(User,NewState,NewUser):-
    get_user_name(User,Name),
    user(Name,NewState,NewUser).
    