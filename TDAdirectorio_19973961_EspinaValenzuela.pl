/*TDA Directorio (o carpeta)*/
/*TDA que representa, como tal, una carpeta*/
/*su representacion sera una lista de elementos*/

/*constructor

DOM--> Name (string) X fcreacion (string) X fmod(string) X Atributos*/ /*data?*/
:-module(tdadirectorio,[directorio/8,get_id_directorio/2, get_name_directorio/2, get_fcreacion_directorio/2, get_fmod_directorio/2, get_atributos_directorio/2, get_hash_directorio/2,mod_name_directorio/3, mod_fmod_directorio/3,
get_idPadre_directorio/2,mod_idpadre_directorio/3,mod_id_directorio/3]).

directorio(ID,Name,Fcreacion,Fmod,Atributos,Hash,IDpadre,[ID,Name,Fcreacion,Fmod,Atributos,Hash,IDpadre]).

/*-------------------------------------- Capa Selectora -------------------------------------*/
/*Todos los selectores reciben a un directorio y obtienen un componente particular del TDA
Meta--> obtencion de algun atributo en particular*/
get_id_directorio([ID,_,_,_,_,_,_],ID).
get_name_directorio([_,Name,_,_,_,_,_],Name).
get_fcreacion_directorio([_,_,Fcreacion,_,_,_,_],Fcreacion).
get_fmod_directorio([_,_,_,Fmod,_,_,_],Fmod).
get_atributos_directorio([_,_,_,_,Atributos,_,_],Atributos).
get_hash_directorio([_,_,_,_,_,Hash,_],Hash).
get_idPadre_directorio([_,_,_,_,_,_,IDpadre],IDpadre).

/*------------------------------------- Capa Modificadora --------------------------------------*/
/*Todas los modifciadores reciben un directorio y obtienen un atributo particular*/
/*Metas --> algun atributo (explicito)*/

mod_name_directorio(Directorio,NewName,NewDirectorio):-
    get_id_directorio(Directorio,ID),
    get_fcreacion_directorio(Directorio,Fcreacion),
    get_fmod_directorio(Directorio,Fmod),
    get_atributos_directorio(Directorio,Atributos),
    get_hash_directorio(Directorio,Hash),
    get_idPadre_directorio(Directorio,IDpadre),

    directorio(ID,NewName,Fcreacion,Fmod,Atributos,Hash,IDpadre,NewDirectorio).

mod_fmod_directorio(Directorio,Newfmod,NewDirectorio):-
    get_id_directorio(Directorio,ID),
    get_name_directorio(Directorio,Name),
    get_fcreacion_directorio(Directorio,Fcreacion),
    get_atributos_directorio(Directorio,Atributos),
    get_hash_directorio(Directorio,Hash),
    get_idPadre_directorio(Directorio,IDpadre),

    directorio(ID,Name,Fcreacion,Newfmod,Atributos,Hash,IDpadre,NewDirectorio).

mod_id_directorio(Directorio,NewId,NewDirectorio):-
    get_name_directorio(Directorio,Name),
    get_fcreacion_directorio(Directorio,Fcreacion),
    get_fmod_directorio(Directorio,Fmod),
    get_atributos_directorio(Directorio,Atributos),
    get_hash_directorio(Directorio,Hash),
    get_idPadre_directorio(Directorio,IDpadre),
    directorio(NewId,Name,Fcreacion,Fmod,Atributos,Hash,IDpadre,NewDirectorio).


mod_idpadre_directorio(Directorio,NewIDpadre,NewDirectorio):-
    get_id_directorio(Directorio,ID),
    get_name_directorio(Directorio,Name),
    get_fcreacion_directorio(Directorio,Fcreacion),
    get_fmod_directorio(Directorio,Fmod),
    get_atributos_directorio(Directorio,Atributos),
    get_hash_directorio(Directorio,Hash),
    directorio(ID,Name,Fcreacion,Fmod,Atributos,Hash,NewIDpadre,NewDirectorio).