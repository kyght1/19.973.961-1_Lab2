%Aca defino el TDA system, que luego usara en el main principal de
% funciones

%TDAsystem..., su representacion se hara mediante uso de listas
:-module(tdasystem,[system/2, get_name_system/2, get_users_system/2, get_unidades_system/2, get_creacion_system/2, get_trash_system/2,get_routes_system/2,
mod_users_system/3,mod_unidades_system/3,mod_papelera_system/3,mod_rutas_system/3,concatenarStrings/2,construirRutaCompleta/2,
get_correlativo_system/2,mod_correlativo_system/3,get_trashroute_system/2,mod_papeleraRoute_system/3]).
%capaConstructora
%Predicado que construye un sistema de archivos
%DOM--> name (string) X system (S)
%Meta--> construir un sistema inicial con el el nombre del sistema
/*La lista resultante posee la siguente estructura
[nombre-sistema (name), lista usuarios, lista unidades, fecha, lista papelera, lista rutas]*/
system(Name,[Name, [],[],[26,05,2023],["papelera data: "],["papelera rutas: "],[], 0]).

%capa pertenencia-- recibe un sistema

/* ----------------------------------------------Capa selectora-----------------------------------------*/
% Todos con dominio System.. retorna algun
% componente pedido
%
/*selector del nombre del sistema*/
get_name_system([Name,_,_,_,_,_,_,_],Name).

/*selector de los usuarios del sistema*/
get_users_system([_,UsersList,_,_,_,_,_,_],UsersList).

%selector de las unidades del sistema

get_unidades_system([_,_,Unidades,_,_,_,_,_],Unidades).

%Selector de la fecha del sistema
get_creacion_system([_,_,_,Date,_,_,_,_],Date).

%selector de la papelera del sistema

get_trash_system([_,_,_,_,Papelera,_,_,_],Papelera).
get_trashroute_system([_,_,_,_,_,PapeleraRoute,_,_],PapeleraRoute).


get_routes_system([_,_,_,_,_,_,Rutas,_],Rutas).
%selector del correlativo
get_correlativo_system([_,_,_,_,_,_,_,Correlativo],Correlativo).

/*---------------------------------------------Capa modificadora----------------------------------------*/
/*capa modificadora... todas reciben a system como argumento ademas de el nuevo valor perteneciente
 a algun compontente; el ultimo argu,mento de cada predicado "NewS", es La salida que se unifica con una lista nueva.*/
% meta--> modificar la lista de usuarios del sistema (system), mediante
% conjuncion de objetivos.

mod_users_system(S, NewUsers,NewS):-
    get_name_system(S,Name),
    get_unidades_system(S,Unidades),
    get_creacion_system(S,Date),
    get_trash_system(S,Papelera),
    get_routes_system(S,Rutas),
    get_correlativo_system(S,Correlativo),
    get_trashroute_system(S,PapeleraRoute),

    NewS = [Name,NewUsers,Unidades,Date,Papelera,PapeleraRoute,Rutas,Correlativo].

/*Predicado que modifica la lista de unidades del sistema*/
mod_unidades_system(S, NewUnidades, NewS):-
    get_name_system(S,Name),
    get_users_system(S,Users),
    get_creacion_system(S,Date),
    get_trash_system(S,Papelera),
    get_routes_system(S,Rutas),
    get_correlativo_system(S,Correlativo),
    get_trashroute_system(S,PapeleraRoute),
    NewS = [Name,Users,NewUnidades,Date,Papelera,PapeleraRoute,Rutas,Correlativo].

/*predicado que modifica la papelera del sistema*/
mod_papelera_system(S, NewT, NewS):-
    get_name_system(S,Name),
    get_users_system(S,Users),
    get_unidades_system(S,Unidades),
    get_creacion_system(S,Date),
    get_routes_system(S,Rutas),
    get_correlativo_system(S,Correlativo),
    get_trashroute_system(S,PapeleraRoute),
    NewS = [Name,Users,Unidades,Date,NewT,PapeleraRoute,Rutas,Correlativo].

/*predicado que modifica las rutas del sistema*/
mod_rutas_system(S,NewR,NewS):-
    get_name_system(S,Name),
    get_users_system(S,Users),
    get_unidades_system(S,Unidades),
    get_creacion_system(S,Date),
    get_trash_system(S,Papelera),
    get_correlativo_system(S,Correlativo),
    get_trashroute_system(S,PapeleraRoute),
    NewS = [Name,Users,Unidades,Date,Papelera,PapeleraRoute,NewR,Correlativo].

/*setter del corelativo*/

mod_correlativo_system(S,NewCorr,NewS):-
    get_name_system(S,Name),
    get_users_system(S,Users),
    get_unidades_system(S,Unidades),
    get_creacion_system(S,Date),
    get_trash_system(S,Papelera),
    get_routes_system(S,Routes),
    get_trashroute_system(S,PapeleraRoute),
    NewS =[Name,Users,Unidades,Date,Papelera,PapeleraRoute,Routes,NewCorr].

mod_papeleraRoute_system(S,NewPapeleraRoute,NewS):-
    get_name_system(S,Name),
    get_users_system(S,Users),
    get_unidades_system(S,Unidades),
    get_creacion_system(S,Date),
    get_trash_system(S,Papelera),
    get_routes_system(S,Routes),
    get_correlativo_system(S,Correlativo),
    NewS=[Name,Users,Unidades,Date,Papelera,NewPapeleraRoute,Routes,Correlativo].


/*aca algunos predicados auxiliares.....*/
/*predicado que construye una ruta, para las consultas*/
/*predicado Ruta corresponde a un tda ruta en particular*/
/*string resultante es una concatenacion de nombres de archivos o directorios... asi se representara una ruta para algunos predicados*/
concatenarStrings([],"").
concatenarStrings([X|R],StringResultante):-
    concatenarStrings(R,S2), string_concat(X,S2,StringResultante).
    
construirRutaCompleta(Ruta,StringResultante):-
    get_nameElement_ruta(Ruta,Raiz),
    get_hijos_ruta(Ruta,Hijos),
    concatenarStrings(Hijos,StringAux),
    string_concat(Raiz,StringAux,StringResultante).

/*predicado para saber si algo es substring*/



