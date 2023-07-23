/*TDA archivo*/
/*Una representacion basada en listas*/
:- module(tdaarchivo,[archivo/8,get_id_archivo/2, get_name_archivo/2, get_format_archivo/2, get_content_archivo/2, get_fmod_archivo/2, get_hash_archivo/2,mod_name_archivo/3,
mod_format_archivo/3, mod_content_archivo/3, mod_fmod_archivo/3,get_id_padreArchivo/2,mod_id_archivo/3,mod_idpadre_archivo/3]).

/*constructor
iD (id de archivo, un numero),Name (string)  X format (string) X content (string) X fmod (string) hash(string) (para el ecrypt y decrypt)*/
archivo(ID,Name,Format,Content,Fmod,Hash,IDpadre,[ID,Name,Format,Content,Fmod,Hash,IDpadre]).

/*----------------------- Capa Selectora ----------------------------------------*/
get_id_archivo([ID,_,_,_,_,_,_],ID).
get_name_archivo([_,Name,_,_,_,_,_],Name).
get_format_archivo([_,_,Format,_,_,_,_],Format).
get_content_archivo([_,_,_,Content,_,_,_],Content).
get_fmod_archivo([_,_,_,_,Fmod,_,_],Fmod).
get_hash_archivo([_,_,_,_,_,Hash,_],Hash).
get_id_padreArchivo([_,_,_,_,_,_,IDpadre],IDpadre).

/*------------------------- Capa modificadora -------------------------------*/
/*todos los modificadores al igual que todos los demas tda reciben:
un archivo, un nuevo atributo y una variable a unificar con el nuevo tda modificado*/
mod_name_archivo(Archivo,NewName,NewArchivo):-
    get_id_archivo(Archivo,ID),
    get_format_archivo(Archivo,Format),
    get_content_archivo(Archivo,Content),
    get_fmod_archivo(Archivo,Fmod),
    get_hash_archivo(Archivo,Hash),
    get_id_padreArchivo(Archivo,IDpadre),
 

    archivo(ID,NewName,Format,Content,Fmod,Hash,IDpadre,NewArchivo).

mod_format_archivo(Archivo,NewFormat,NewArchivo):-
    get_id_archivo(Archivo,ID),
    get_name_archivo(Archivo,Name),
    get_content_archivo(Archivo,Content),
    get_fmod_archivo(Archivo,Fmod),
    get_hash_archivo(Archivo,Hash),
    get_id_padreArchivo(Archivo,IDpadre),
 

    archivo(ID,Name,NewFormat,Content,Fmod,Hash,IDpadre,NewArchivo).

mod_content_archivo(Archivo,NewContent,NewArchivo):-
    get_id_archivo(Archivo,ID),
    get_name_archivo(Archivo,Name),
    get_format_archivo(Archivo,Format),
    get_fmod_archivo(Archivo,Fmod), 
    get_hash_archivo(Archivo,Hash),
     
    get_id_padreArchivo(Archivo,IDpadre),
 


    archivo(ID,Name,Format,NewContent,Fmod,Hash,IDpadre,NewArchivo).

mod_fmod_archivo(Archivo,NewFmod,NewArchivo):-
    get_id_archivo(Archivo,ID),
    get_name_archivo(Archivo,Name),
    get_format_archivo(Archivo,Format),
    get_content_archivo(Archivo,Content),
    get_hash_archivo(Archivo,Hash),
    get_id_padreArchivo(Archivo,IDpadre),
 

    archivo(ID,Name,Format,Content,NewFmod,Hash,IDpadre,NewArchivo).
    
mod_id_archivo(Archivo,NewID,NewArchivo):-
    get_name_archivo(Archivo,Name),
    get_format_archivo(Archivo,Format),
    get_content_archivo(Archivo,Content),
    get_fmod_archivo(Archivo,Fmod), 
    get_hash_archivo(Archivo,Hash),
    get_id_padreArchivo(Archivo,IDpadre),
    archivo(NewID,Name,Format,Content,Fmod,Hash,IDpadre,NewArchivo).

mod_idpadre_archivo(Archivo,NewIDpadre,NewArchivo):-
    get_id_archivo(Archivo,ID),
    get_name_archivo(Archivo,Name),
    get_format_archivo(Archivo,Format),
    get_content_archivo(Archivo,Content),
    get_fmod_archivo(Archivo,Fmod), 
    get_hash_archivo(Archivo,Hash),
    archivo(ID,Name,Format,Content,Fmod,Hash,NewIDpadre,NewArchivo).
