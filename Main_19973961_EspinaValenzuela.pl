:-use_module(tdaunidad_19973961_EspinaValenzuela).
:-use_module(tdausuario_19973961_EspinaValenzuela).
:-use_module(tdaarchivo_19973961_EspinaValenzuela).
:-use_module(tdasystem_19973961_EspinaValenzuela).
:-use_module(tdaruta_19973961_EspinaValenzuela).
:-use_module(tdadirectorio_19973961_EspinaValenzuela).
:-use_module(library(date)).
/*predicado para la fecha*/


obtener_fecha_actual(Fecha) :-
    get_time(Timestamp),
    stamp_date_time(Timestamp, FechaCompleta, local),
    date_time_value(year, FechaCompleta, Y),
    date_time_value(month, FechaCompleta, Mes),
    date_time_value(day, FechaCompleta, Dia),
    Fecha = [Dia, Mes, Y].


reversar_lista([], []).
reversar_lista([X|Xs], Reversa) :-
    reversar_lista(Xs, Resto),
    append(Resto, [X], Reversa).

/*predicado para imprimir una lista*/
imprimir_lista([]).
imprimir_lista([X|Xs]) :-
    format("~w~n", [X]), % Imprime cada elemento de la lista seguido de un espacio
    imprimir_lista(Xs).

/*Aca, en main, iran los requerimientos funcionales pedidos*/

/*Comienzo a definir los predicados*/
/*algunos predicados generales.*/
/*predicado Member para conocer la existencia de un elemento*/
member([X|_],X):-!.
member([_|R],X):-
    member(R,X).


/*predicado que obtiene un elemento de una lisa*/
getElementFromList([X|_],E,E):-
    E == X, !.
getElementFromList([_|R],E,E):-
    getElementFromList(R,E,E).




/*predicado que modifica un elemento de una lista por su modificador*/
modElementOfList([X|R],X,NewElement, [NewElement|R]):-!.
modElementOfList([X|R1],E,NewElement,[X|R2]):-
    modElementOfList(R1,E,NewElement,R2).




/*predicado que elimina un elemento de la lista, asumiendo que los elementos son unicos*/
deleteElement([],_,[]):-!.
deleteElement([X|R],X,R):-!.
deleteElement([X|R],E,[X|R1]):-
    deleteElement(R,E,R1).


/*predicado auxiliar que anade elemento a lista al inicio*/
appendElementToList([],E,[E]):-!.
appendElementToList(L,E,[E|L]).

/*llo mismo de arriba, pero anade al final*/
appendElementToFinal([],E,[E]).
appendElementToFinal([X|R],E,[X|R2]):-
 appendElementToFinal(R,E,R2).





/*TDA_system addrive --> prdicado que permite anadir una unidad a un sistema... la letra de la unidad ha de ser unica*/
/*DOM --> system x letter x name x capacity x System (meta, unificar un nuevo system con la nueva unidad agregada)*/

/*predicado auxiliar*/
/*DOm--> Lista Unidades, letter*/
existUnityinSystem([U|_],X):-
    get_letter_unidad(U,Letter), Letter == X, !.
existUnityinSystem([_|R],Letter):-
    existUnityinSystem(R,Letter).


/*-----add-drive-------*/
/*si la unidad ya existe*/
systemAddDrive(System,Letter,_,_,System):-
    get_unidades_system(System,Unidades),
    existUnityinSystem(Unidades,Letter),!.

/*si es la primera unidad*/
systemAddDrive(System,Letter,Name,Capacity,NewS):-
    get_unidades_system(System,Unidades),
    get_routes_system(System,Routes),
    Unidades = [],
    %correlativo
    get_correlativo_system(System,Correlativo),
    ID is Correlativo +1,
    unidad(ID,Letter,Name,[],Capacity,U),
    appendElementToList(Unidades,U,ListaUnidadesFinal),
    string_concat(Letter,":/",L1),
    ruta(1,Letter,0,[],L1,Ruta),
    appendElementToList(Routes,Ruta,ListaRutasFinal),
    mod_unidades_system(System,ListaUnidadesFinal,NS2),
    mod_rutas_system(NS2,ListaRutasFinal,NS3),
    mod_correlativo_system(NS3,ID,NewS),
    !.

/*else*/


systemAddDrive(System,Letter,Name,Capacity,NewSystem):-
    get_unidades_system(System,Unidades),
    get_routes_system(System,Routes),
    \+ existUnityinSystem(Unidades,Letter),

    %incorporo la unidad
    get_correlativo_system(System,Correlativo),
  
    ID is Correlativo + 1,
    unidad(ID,Letter, Name, [], Capacity,U),
    appendElementToFinal(Unidades,U, ListaUnidadesFinal),
    mod_unidades_system(System,ListaUnidadesFinal,NewSystemAux),
    string_concat(Letter,":/",L1),
    ruta(ID,Letter,0,[],L1,Ruta),
    appendElementToFinal(Routes,Ruta,NewRoutesList),
    mod_rutas_system(NewSystemAux,NewRoutesList,NewS2),
    mod_correlativo_system(NewS2,ID,NewSystem),!.
    
/*--------Register-----------------*/
/*
 Predicado que permite registrar un nuevo usuario al sistema. El nombre de usuario es unico y no puede ser duplicado.
 DOM---> System X Username 
 Meta--> System con nuevo usuario registrado, sino .. S original en caso de que el user ya exista*/

 /*predicado que determina la existencia de algun usuario*/
 existUserinSystem([X|_],Username):-
 get_user_name(X,UsN), Username == UsN, !.
 existUserinSystem([_|R],Username):-
    existUserinSystem(R,Username).

systemRegister(System,Username,System):-
    get_users_system(System,UsersSystem),existUserinSystem(UsersSystem,Username), !.
/*----------------------------------------------------------*/
 systemRegister(System,Username,NewSystem):-
    get_users_system(System,UsersSystem),
    \+ existUserinSystem(UsersSystem,Username), user(Username,0,NewUser), appendElementToList(UsersSystem,NewUser, NewUserSystemList), mod_users_system(System,NewUserSystemList, NewSystem).
    
    
/*--------------Login----------------------------*/
/*Funcion que permite iniciar sesion con un usuario del sistema, solo si este existe.
DOM---->System X Username (string)
Meta---> Loguear usuario con nombre Username en system si este existe.*/

/*Predicado que determina si un usuario esta logueadoespecificamente el que se quiere loguear*/
isUserLogged([X|_],Username):-
    get_user_name(X,U), U=Username,get_user_state(X,State), State = 1,!.

isUserLogged([_|R],Username):-
    isUserLogged(R,Username).

/*predicado para ver si hay un usuario logueado*/
existUserLogged([X|_]):-
    get_user_state(X,State), State = 1, !.
existUserLogged([_|R]):-
    existUserLogged(R).
/*---------------------------------------------------------*/    
/*caso de que el usuario este logueado*/
systemLogin(System,Username,System):-
    get_users_system(System,UsersSystem),existUserinSystem(UsersSystem,Username),isUserLogged(UsersSystem,Username),!.

systemLogin(System,Username,System):-
    get_users_system(System,UsersSystem),existUserinSystem(UsersSystem,Username),existUserLogged(UsersSystem),!.
/*en caso de que no este logueado*/
systemLogin(System,Username,NewSystem):-
    get_users_system(System,UsersSystem),
    existUserinSystem(UsersSystem,Username),\+ existUserLogged(UsersSystem) ,\+ isUserLogged(UsersSystem,Username), /*logueo*/ user(Username,0,U1),user(Username,1,U2),
    modElementOfList(UsersSystem,U1,U2,NewUserList),
    mod_users_system(System,NewUserList,NewSystem).

/*------------------------------------------Logout--------------------------------------------*/
/*predicado que permite cerrar la sesion de un usuario en el sistema*/
/*DOM---> System X System*/

/*predicado para desloguear un usuario de una lista*/
logoutUser(User,State,NewUser):-
    mod_user_state(User,State,NewUser),!.

logoutUserFromList([X],State,[NewUser]):-
    logoutUser(X,State,NewUser),!.
logoutUserFromList([X|R1],State,[NewUser|R2]):-
    logoutUser(X,State,NewUser),logoutUserFromList(R1,State,R2).

systemLogout(System,System):-
    %Si no hay user logueado
    get_users_system(System,UsersList),\+ existUserLogged(UsersList).

systemLogout(System,NewSystem):-

    get_users_system(System,UsersList),logoutUserFromList(UsersList,0,NewUserList),mod_users_system(System,NewUserList,NewSystem).



/*------------------------------    Switch-Drive  -------------------------------------------------------------------*/

/*TDA system - switch-drive: Permite fijar la unidad en la que el usuario realizara acciones. El predicado solo debe funcionar cuando hay un usuario
 con sesion iniciada en el sistema a partir del predicado SystemLogin.
*/
/*predicado que obtiene la unidad seleccionada para switchdrive*/
getUnityFromList([X|_],Letter,Unity):-
    get_letter_unidad(X,L1),L1==Letter,Unity = X, !.
getUnityFromList([_|R],Letter,Unity):-
    getUnityFromList(R,Letter,Unity).

/*DOM--> System x Letter*/
/*si no hay usuario loguado ni exsite unidad*/
systemSwitchDrive(System, Letter, System):-
    get_users_system(System,UsersSystem),
    \+ existUserLogged(UsersSystem) ; 
    get_unidades_system(System,Unidades), \+ existUnityinSystem(Unidades,Letter),!.
/*o, bien*/
systemSwitchDrive(System,Letter,NewSystem):-
    get_unidades_system(System,Unidades), existUnityinSystem(Unidades,Letter), getUnityFromList(Unidades,Letter,Unity), deleteElement(Unidades,Unity,U2),
    appendElementToList(U2,Unity,NewUserList),get_routes_system(System,RoutesList),get_ruta(RoutesList,Letter,RutasUnidad),get_IDpadre_ruta(RutasUnidad,IDPadre),
    borrarRuta(RoutesList,Letter,IDPadre,Aux1),appendElementToList(Aux1,RutasUnidad,RutasFinales),

    mod_unidades_system(System,NewUserList,NewSAux), mod_rutas_system(NewSAux,RutasFinales,NewSystem),!.


/*---------------------------------------- mk dir---------------------------------*/
/*Predicado que permite crear directorio dentro de una unidad a partir del nombre especificado. Internamente el predicado 
anade datos relativos a usuario creador, fecha de creacion, fecha de ultima modificacion, como los senalados en el enunciado general
*/

/*defino un pequeno predicado para determinar si a existe un directorio con el mismo nombre en la ruta actual*/
existeDirectorio([X|_],X):-!.
existeDirectorio([_|R],D):-
    existeDirectorio(R,D),!. %la lista y D son una lista de strings hijos y un string de nonmbre de directorio



/*DOM---> System X name(string)*/
/*Meta---> System con directorio creado*/
systemMkdir(System,Name,System):-
    /*directorio actual*/
    get_routes_system(System,Rutas),
    obtenerRutaActual(Rutas,RutaActual),  
    get_hijos_ruta(RutaActual,HijosRutaActual),
    
    existeDirectorio(HijosRutaActual,Name),!.
    
%caso cuando no existe el directorio en la unidad actual


systemMkdir(System,Name,NewSystem):-

    get_routes_system(System, ListaRutas),
    obtenerRutaActual(ListaRutas,RutaActual),
    get_IDpadre_ruta(RutaActual,IDpadreRutaActual),
    
    get_hijos_ruta(RutaActual,HijosRutaActual),
    get_nameElement_ruta(RutaActual,NameRuta),
    obtener_fecha_actual(Fecha),
 

    \+ existeDirectorio(HijosRutaActual,Name), % entonces
        get_unidades_system(System,Unidades),
        obtenerUnidadActual(Unidades,UnidadActual),
        /*modifico el data de  unidad*/
        get_data_unidad(UnidadActual,DataUnidadActual),
        get_correlativo_system(System,Correlativo),
        get_IDelement_ruta(RutaActual,IDpadre),
        NewID is Correlativo + 1,
        directorio(NewID,Name,Fecha,Fecha,[],[],IDpadre,NewDirectory),
        appendElementToList(DataUnidadActual,NewDirectory,NewData),
        mod_data_unidad(UnidadActual,NewData,NewUnidad),

        /*modifico las rutas*/
        /*determino el stringForm*/
        get_StringForm_ruta(RutaActual,StringForm1),
        string_concat(StringForm1,Name,StrAux),
        string_concat(StrAux,"/",StringFormFinal),
        
     
        ruta(NewID,Name,IDpadre,[],StringFormFinal,NewRuta),

        /*modifico hijos de ruta actual*/

        borrarRuta(ListaRutas,NameRuta,IDpadreRutaActual,ListRutasAux),
        appendElementToList(HijosRutaActual,Name,NewHijosRuta),
        mod_hijos_ruta(RutaActual,NewHijosRuta,NewRutaActual),
        appendElementToFinal(ListRutasAux,NewRuta,NewRutas), /*ruta del nuevo directorio*/
        appendElementToList(NewRutas,NewRutaActual,NewRutasD), /*ruta acutal con hijos nuevos*/
        mod_rutas_system(System,NewRutasD,SystemAux),

        /*modifico las listas*/
        get_letter_unidad(UnidadActual,Letter),
        borrarUnidad(Unidades,Letter,ListUnidadesAux),
        appendElementToList(ListUnidadesAux,NewUnidad,NewUnidades),
        mod_unidades_system(SystemAux,NewUnidades,NewSAux),
        mod_correlativo_system(NewSAux,NewID,NewSystem),!.

/*TDA system- cd (change directory): Predicado que permite cambiar la ruta (path) donde se 
realizaran las proximas operaciones. cd permite cambiarse a un directorio especificado a partir de la ruta 
senalada en un String. Ademas, contara con los comodines especiales: ''.'', ''..'' y '/'' (se usa slash en lugar de backslash) que permitiran 
referirse a la carpeta actual, regresar a la carpeta del nivel anterior siguiendo la ruta actual del usuario y volver a la raiz de la unidad respectivamente.
*/
/*predicado que obtiene una uta actual con un padre determinado.... para el predicado CD*/
getSelectRoute([X|_],IDpadre,Path,E):-
    get_IDpadre_ruta(X,ID), IDpadre == ID,
    get_nameElement_ruta(X,Name), Name == Path,
    E = X, !.
getSelectRoute([_|R],IDpadre,Path,E):-
    getSelectRoute(R,IDpadre,Path,E),!.
/*predicado similar al anterior que recibe solo id padre... para buscar la ruta*/

getPadreRoute([X|_],IDpadre,E):-
    get_IDelement_ruta(X,ID), IDpadre == ID,
    E = X, !.
getPadreRoute([_|R],IDpadre,E):-
    getPadreRoute(R,IDpadre,E),!.




/*-----------------------------------------------------------------------------*/
systemCd(System, "/", NewSystem):- %Path o nombre de carpeta.... separare los comandos con varios predicados
    /*vuelvo a la raiz*/
    
    get_users_system(System,UsersList),
    existUserLogged(UsersList),
    %si haay un usuario logueado...
    get_routes_system(System,RoutesOfSystem),
    get_unidades_system(System,Unidades),
    obtenerUnidadActual(Unidades,UnidadActual),
    get_letter_unidad(UnidadActual,Letter), get_ruta(RoutesOfSystem,Letter,RutaRaiz),get_IDpadre_ruta(RutaRaiz,IDpadre),
    
    borrarRuta(RoutesOfSystem,Letter,IDpadre,Aux1),appendElementToList(Aux1,RutaRaiz,RutasFinales),
    mod_rutas_system(System,RutasFinales,NewSystem),!.

%ahora el caso de djar explicitamente el nombre de un directorio.
%caso donde me devuelvo un directorio... con el comando ".."



systemCd(System,Path,NewSystem):-
    %existe en la ruta actual
    split_string(Path,"/","",P),
    length(P,L), L ==1,
    get_users_system(System,UsersList),
    existUserLogged(UsersList),

    %si haay un usuario logueado...
    get_routes_system(System,RoutesOfSystem),
    obtenerRutaActual(RoutesOfSystem,RutaActual),
    get_hijos_ruta(RutaActual,HijosRutaActual),

    
    member(HijosRutaActual,Path), %si existe como hijo de ruta actual

    get_IDelement_ruta(RutaActual,IDpadre),
    getSelectRoute(RoutesOfSystem,IDpadre,Path,RouteSelected),
    deleteElement(RoutesOfSystem,RouteSelected, RoutesAux),
    appendElementToList(RoutesAux,RouteSelected,NewRoutes),
    mod_rutas_system(System,NewRoutes,NewSystem),!.



%caso para volver al directorio anterior


systemCd(System,"..",System):-


    %si estoy en raiz
    get_users_system(System,UsersList),
    existUserLogged(UsersList),
    %si haay un usuario logueado...



    get_routes_system(System,RoutesOfSystem),
    obtenerRutaActual(RoutesOfSystem,RutaActual),
    get_unidades_system(System,Unidades),
    obtenerUnidadActual(Unidades,UnidadActual),
    get_letter_unidad(UnidadActual,Letter),

    get_nameElement_ruta(RutaActual,NameRuta),
    NameRuta == Letter,!.


%caso de ver carpeta dentro de carpeta
systemCd(System,"..",NewSystem):-
    %si estoy en raiz
    get_users_system(System,UsersList),
    existUserLogged(UsersList),
    %si haay un usuario logueado...
    get_routes_system(System,RoutesOfSystem),
    obtenerRutaActual(RoutesOfSystem,RutaActual),
    get_IDpadre_ruta(RutaActual,IDPADRE),
    %busco al padre
    getPadreRoute(RoutesOfSystem,IDPADRE,Padre),
    deleteElement(RoutesOfSystem,Padre,Aux),
    appendElementToList(Aux,Padre,RutasFinales),
    mod_rutas_system(System,RutasFinales,NewSystem),!.

/*caso ej folder1/folder2--> folder 2 visible desde ruta actual*/

systemCd(System, Path, NewSystem):-
    split_string(Path,"/","",[X,Y]), %para poder trabajarlo
    get_users_system(System,UsersList),
    existUserLogged(UsersList),

    %si haay un usuario logueado...
    get_routes_system(System,RoutesOfSystem),
    obtenerRutaActual(RoutesOfSystem,RutaActual),

    get_hijos_ruta(RutaActual,HijosRutaActual),
    get_IDelement_ruta(RutaActual,IDPadre),

    member(HijosRutaActual,X),
    getSelectRoute(RoutesOfSystem,IDPadre,X,PrimerFolder),
    deleteElement(RoutesOfSystem,PrimerFolder,AUX),
    appendElementToList(AUX,PrimerFolder,RutasAux),
    /*hijos de la nueva ruta*/
    get_hijos_ruta(PrimerFolder,HijosPrimerFolder),
    /*id primer folder*/
    get_IDelement_ruta(PrimerFolder,IDPrimerFolder),

    %busco la subcarpeta en los hijos
    member(HijosPrimerFolder,Y),
    getSelectRoute(RutasAux,IDPrimerFolder,Y,Subcarpeta),
   
    deleteElement(RutasAux,Subcarpeta,AUX2),
    appendElementToList(AUX2,Subcarpeta,RutasFinales),
    mod_rutas_system(System,RutasFinales,NewSystem),!.








    /* TDA system - add-file: Predicado que permite añadir un archivo en la ruta actual.
*/

/*aca el predicado ADD-file--> crea un archivo y lo añade a la ruta actual
si ya existe un archivo con el mismo nombre--> se reemplaza su contenido y tipo*/
/*DOM--->System X File 
Meta---> NewSystem*/
/*file ya entra como archivo*/

/*para ello defino predicado para el borrado dee archivo desde una data de unidad*/
deleteArchivoFromUnityData([],_,[]):-!.
deleteArchivoFromUnityData([X|R],NameArchivo,R):-
    get_name_archivo(X,Name),NameArchivo == Name,!.
deleteArchivoFromUnityData([X|R1],NameArchivo,[X|R2]):-
    deleteArchivoFromUnityData(R1,NameArchivo,R2),!.

/*POSIBLE MOD---------------*/

/*predicado para borrarlo de las rutas*/
deleteArchivoFromRoutes([],_,_,[]):-!.
deleteArchivoFromRoutes([X|R],NameArchivo,IDPadre,R):-
    get_nameElement_ruta(X,Name),NameArchivo == Name,
    get_IDpadre_ruta(X,Id), Id == IDPadre,!.
deleteArchivoFromRoutes([X|R1],NameArchivo,IDPadre,[X|R2]):-
    deleteArchivoFromRoutes(R1,NameArchivo,IDPadre,R2),!.

/*si el archivo ya existia y lo modifico, conservo su id*/
idArchivoAModificar([X],NameArchivo,IDPadre,ID):-
    get_IDpadre_ruta(X,AUX), get_nameElement_ruta(X,Name),
    IDPadre == AUX, Name == NameArchivo,
    get_IDelement_ruta(X,ID),!.
idArchivoAModificar([_|R],NameArchivo,IDPadre,ID):-
    idArchivoAModificar(R,NameArchivo,IDPadre,ID),!.
    




/*primer caso, el archivo no existe en la ruta actual. */

systemAddFile(System,File,NewSystem):-

    %fecha de modificacion.
    obtener_fecha_actual(Fecha),

    %-------------------

    get_name_archivo(File,NameArchivo),
    get_format_archivo(File,FormatArchivo),
    get_content_archivo(File,ContentArchivo),
    %comprobacion de usuario

    get_users_system(System,UsersList),
    existUserLogged(UsersList),

    %le asigno id, lo agrego a unidad

    get_unidades_system(System,Unidades),
    obtenerUnidadActual(Unidades,UnidadActual),
    get_letter_unidad(UnidadActual,LetterUnidadActual),
    get_routes_system(System,RoutesList),
    obtenerRutaActual(RoutesList,RutaActual),
    get_IDpadre_ruta(RutaActual,IDpadreRutaActual),

    %modifico los hijos de la ruta actual


    get_nameElement_ruta(RutaActual,NombreRuta),
    get_hijos_ruta(RutaActual,HijosRutaActual),
    
    %dependiendo si existe o no el archivo en la ruta, se ejecutaran las siguientes conjunciones
    \+member(HijosRutaActual,NameArchivo),

    appendElementToFinal(HijosRutaActual,NameArchivo,NewHijosRuta),
    mod_hijos_ruta(RutaActual,NewHijosRuta,NewRutaActual),
    borrarRuta(RoutesList,NombreRuta,IDpadreRutaActual,R2),
    appendElementToList(R2,NewRutaActual,R3),

    %nuevo id para archivo, creo ruta

    get_correlativo_system(System,Correlativo),
    NewID is Correlativo + 1,
    get_IDelement_ruta(RutaActual,IDpadre),
    /*formo el string de la ruta..*/
    get_StringForm_ruta(RutaActual,StringForm1),
    string_concat(NameArchivo,".",NameArchivoAux),
    string_concat(NameArchivoAux,FormatArchivo,StringForm2),
    /*formo el string de la ruta*/
    string_concat(StringForm1,StringForm2,StringFormFinal),
    ruta(NewID,NameArchivo,IDpadre,-1,StringFormFinal,RutaArchivo), %los hijos lllevan un -1, asi se que es archivo y no directorio
    appendElementToFinal(R3,RutaArchivo,NewRoutesList),
   
    %modifico data unidad.. debido al formato de TDA archivo, y para evitar errores en la asignacion de ID, lo recreo en el predicado antes de añadirlo
   
    archivo(NewID,NameArchivo,FormatArchivo,ContentArchivo,Fecha,[],IDpadre,Archivo),
    get_data_unidad(UnidadActual,DataUnidadActual),
    appendElementToList(DataUnidadActual,Archivo,NewDataUnidad),
    mod_data_unidad(UnidadActual,NewDataUnidad,UnidadFinal),
   
    %modifico las unidades
   
    borrarUnidad(Unidades,LetterUnidadActual,Aux),
    appendElementToList(Aux,UnidadFinal,NewListUnidades),
    mod_unidades_system(System,NewListUnidades,Saux),
    mod_rutas_system(Saux,NewRoutesList,Saux2),
    mod_correlativo_system(Saux2,NewID,NewSystem),!.
    



/*Segundo caso... en caso de que el archivo ya exista*/

systemAddFile(System,File1,NewSystem):-

    obtener_fecha_actual(Fecha),

    %-------------------

    get_name_archivo(File1,NameArchivo),
    get_format_archivo(File1,FormatArchivo),
    get_content_archivo(File1,ContentArchivo),
    %comprobacion de usuario

    get_users_system(System,UsersList),
    existUserLogged(UsersList),

    %le asigno id, lo agrego a unidad

    get_unidades_system(System,Unidades),
    obtenerUnidadActual(Unidades,UnidadActual),
    get_letter_unidad(UnidadActual,LetterUnidadActual),
    get_routes_system(System,RoutesList),
    obtenerRutaActual(RoutesList,RutaActual),
    get_IDelement_ruta(RutaActual,IDPadre),
    get_data_unidad(UnidadActual,DataUnidadActual),
    get_IDpadre_ruta(RutaActual,IDpadreRutaActual),
    %modifico los hijos de la ruta actual


    get_nameElement_ruta(RutaActual,NombreRuta),
    get_hijos_ruta(RutaActual,HijosRutaActual),
    
    %dependiendo si existe o no el archivo en la ruta, se ejecutaran las siguientes conjunciones
    member(HijosRutaActual,NameArchivo),

    idArchivoAModificar(RoutesList,NameArchivo,IDPadre,NewID),

    %%elimino el archivo de la data, de las rutas, y de los hijos de la ruta actual
    deleteArchivoFromUnityData(DataUnidadActual,NameArchivo,DataAux),
    deleteArchivoFromRoutes(RoutesList,NameArchivo,IDPadre,RoutesAux),
    deleteElement(HijosRutaActual,NameElement,HijosAux),

    %ahora modifico todo, agregando el nuevo archivo que reemplaza al exsitente
    get_IDelement_ruta(RutaActual,IDpadre),

    /*fabrico el nuevo string*/
    get_StringForm_ruta(RutaActual,StringForm1),
    string_concat(NameArchivo,".",NameArchivoAux),
    string_concat(NameArchivoAux,FormatArchivo,StringForm2),
    string_concat(StringForm1,StringForm2,StringFormFinal),


    ruta(NewID,NameArchivo,IDpadre,-1,StringFormFinal,RutaArchivo), %los hijos lllevan un -1, asi se que es archivo y no directorio
    appendElementToFinal(RoutesAux,RutaArchivo,NewRoutesList),
    %data
    archivo(NewID,NameArchivo,FormatArchivo,ContentArchivo,Fecha,[],IDpadre,Archivo),
    appendElementToFinal(DataAux,Archivo,NewData),
    mod_data_unidad(UnidadActual,NewData,UnidadFinal),
    %hijos
    appendElementToFinal(HijosAux,NameElement,NewHijos),
    mod_hijos_ruta(RutaActual,NewHijos,NewRutaActual),
    %modifico
    borrarUnidad(Unidades,LetterUnidadActual,UAux),
    appendElementToList(UAux,UnidadFinal,UnidadesFinales),
    mod_unidades_system(System,UnidadesFinales,S1),

    borrarRuta(NewRoutesList,NombreRuta,IDpadreRutaActual,R1),
    appendElementToList(R1,NewRutaActual,RoutesFinal),
    mod_rutas_system(S1,RoutesFinal,NewSystem),!.






/*TDA system - del: Predicado para eliminar un archivo o varios archivos en base a un patrón determinado. 
Esta versión también puede eliminar una carpeta completa con todos sus subdirectorios. El contenido eliminado se va a la papelera.
*/
/*DOM--->
System X fileName or fileNamePattern (string) X System

*/
/*cuando borro un archivo, lo borro de la ruta actual., además de la data de la unidad donde está ubicado*/
/*predicado para obtener y borrar todos los archivos del directorio actual*/

/*predicado para saber si una cadena es subcadena de otra*/
/*DOM--> la cadena que representa la raiz original del sistema, el target, y un inicio y fin*/
/*meta--> comprobar que una substring es subcadena de String*/
isSubString(String,Substring,Inicio,Fin):-
    atom_chars(String,StringLista),
    atom_chars(Substring,SubstringList),
    isSubStringAux(StringLista,SubstringList,Inicio,Fin,0),!.

isSubStringAux(_,[],Inicio,Fin,Aux):-
    Aux=<Fin, Aux>=Inicio,!.
/*el predicado de a continuacion recorre los strings convertidos en listas, comparandolos*/

isSubStringAux([X|Sr],[X|Sbr],Inicio,Fin,Aux):-
    Aux =< Fin,
    Inicio=<Aux,
    Siguiente is Aux + 1,
    isSubStringAux(Sr,Sbr,Inicio,Fin,Siguiente),!.
isSubStringAux([_|Sr],Sbr,Inicio,Fin,Aux):-
    Aux <Fin,
    Siguiente is Aux + 1,
    isSubStringAux(Sr,Sbr,Inicio,Fin,Siguiente),!.


/*regla para obtener todos las rutas donde aparece un folder determinado con un id padre*/
/*filter con condicion*/
/*condicion*/
/*todas las rutas*/
/*un filtro generico*/
filterRoutes([],_,_,[]):-!.
filterRoutes([X|R],Path,IDPadre,[X|F]):-
    get_StringForm_ruta(X,Sf), string_length(Sf,L),isSubString(Sf,Path,0,L),
    filterRoutes(R,Path,IDPadre,F),!.
filterRoutes([_|R],Path,IDPadre, F) :-
    filterRoutes(R,Path, IDPadre,F),!.




/*filtrar archivos en la ruta actual*/
/*entrada lista rutas*/

filterArchivesRoutes([],_,_,[]):-!.
filterArchivesRoutes([X|R],IDFather,SonsList,[X|F]):-
  get_IDpadre_ruta(X,IDroute),IDroute == IDFather, get_hijos_ruta(X,H), H == -1, filterRoutes(R,IDFather,SonsList,F).
filterArchivesRoutes([_|R],IDFather,SonsList,F):-
    filterArchivesRoutes(R,IDFather,SonsList,F).


/*Eliminar rutas de archivos de la lista de rutas*/
deleteArchivesRoutes([], Routes, Routes):-!.
deleteArchivesRoutes([X|R], Routes, NewRoutes) :-
    deleteArchive(X, Routes, RoutesAux),!,
    deleteArchivesRoutes(R, RoutesAux, NewRoutes),!.

/*borro una ruta individual e la lsita rutas*/
deleteArchive(_, [], []):-!.
deleteArchive(X, [X|R], NewRoutes) :-
    deleteArchive(X, R, NewRoutes),!.
deleteArchive(X, [Y|R], [Y|NewRoutes]) :-
    X \= Y,
    deleteArchive(X, R, NewRoutes),!.
/*obtengo la data de los archivos a borrar con el siguiente predicado*/
filterArchivesData([],_,[]).
filterArchivesData([X|R],IDFather,[X|F]):-
    get_id_padreArchivo(X,IDarch), get_format_archivo(X,Format), string(Format),IDFather == IDarch, filterArchivesData(R,IDFather,F),!.
filterArchivesData([_|R],IDFather,F):- filterArchivesData(R,IDFather,F).    

/*ahora reglas similares a la anterior para el borrado de archivos de la data*/


deleteElementsListToList([], Data, Data):-!.
deleteElementsListToList([X|R], Data, NewData) :-
    deleteArchive(X, Data, DataAux),
    deleteElementsListToList(R, DataAux, NewData),!.

/*ahora el caso de que FileNamePatter sea un archivo con nombre determinado...*/
/*una regla para encontrar un archivo en especifico con nombre y formato determinado*/
 /*lo filtro de la data de la unidad*/
filterEspecificArchive([],_,_,_,[]):-!.
filterEspecificArchive([X|_],IDFather,NameArch,FormatArch,X):-
    get_id_padreArchivo(X,IDPadreArchivo),
    get_name_archivo(X,NameArchivo),
    get_format_archivo(X,FormatArchivo),
    IDFather == IDPadreArchivo, NameArchivo == NameArch, FormatArch == FormatArchivo,!.   
filterEspecificArchive([_|R],IDFather,NameArch,FormatArch,F):-
    filterEspecificArchive(R,IDFather,NameArch,FormatArch,F),!.

/*predicado para obtener la ruta especifica de un archivo*/
filterEspecificArchiveRoute([],_,_,_,[]):-!.
filterEspecificArchiveRoute([X|_],IDFather,NameArch,X):-
    get_IDpadre_ruta(X,IDPadreArchivo),
    get_nameElement_ruta(X,NameArchivo),
    get_hijos_ruta(X,HijosRuta),
    HijosRuta == -1,
    
    IDFather == IDPadreArchivo, NameArchivo == NameArch,!.   
filterEspecificArchiveRoute([_|R],IDFather,NameArch,F):-
    filterEspecificArchiveRoute(R,IDFather,NameArch,F),!.

/*predicado ObtainID*/
obtainID([X|_],X).

/*predicado para filtrar los elementos de data x id usando include/3 */

filterID(ListaIDs,ElementofData):- obtainID(ElementofData,ID),member(ListaIDs,ID),!.

obtainDataFromDataByID(ListaIDs,DataUnidad,DataWithSelectID):-
    include(filterID(ListaIDs),DataUnidad,DataWithSelectID),!.

    
/*para borrar todos los archivos presentes en el directorio actual*/

systemDel(System,FileNamePattern,NewSystem):-
    FileNamePattern == "*.*",
    get_unidades_system(System,Unidades),
    get_routes_system(System,RoutesList),
    get_trash_system(System,Papelera),
    get_trashroute_system(System,PapeleraRoute),
    obtenerRutaActual(RoutesList,RutaActual),
    obtenerUnidadActual(Unidades,UnidadActual),
    get_data_unidad(UnidadActual,DataUnidad),
    get_IDelement_ruta(RutaActual,IDpadre),
    get_IDpadre_ruta(RutaActual, IDpadreRutaActual),
    get_nameElement_ruta(RutaActual,NameRutaActual),
    get_letter_unidad(UnidadActual,LetterUnidadActual),

    /*hijos ruta actual*/
    get_hijos_ruta(RutaActual,HijosRutaActual),

    /*hijos ruta actual*/
    filterArchivesRoutes(RoutesList,IDpadre,HijosRutaActual,ArchivosFiltradosRoutes),

    /*borro las rutas*/
    deleteArchivesRoutes(ArchivosFiltradosRoutes,RoutesList,RoutesWithoutArchives),


    filterArchivesData(DataUnidad,IDpadre, ArchivosFiltradosData),
    deleteElementsListToList(ArchivosFiltradosData,DataUnidad,DataWithoutArchives),


   /*obtengo los hijos y borro los hijos*/
   maplist(get_nameElement_ruta,ArchivosFiltradosRoutes,NamesArchivos),
   deleteElementsListToList(HijosRutaActual,NamesArchivos,HijosSinArchivos),


   /*los borro de los hijos actuales*/
   /*lo seteo*/
   mod_hijos_ruta(RutaActual,HijosSinArchivos,RutaHijosSinArchivos), %---> ruta sin archivos de hijo


   /*ahora establezco las modificaciones en las listas*/
   borrarRuta(RoutesWithoutArchives,NameRutaActual,IDpadreRutaActual,RoutesListWithoutRouteActual),
   appendElementToList(RoutesListWithoutRouteActual,RutaHijosSinArchivos,RutasFinales),
   mod_rutas_system(System,RutasFinales,SystemAux),

   /*data de la unidad
   */
   mod_data_unidad(UnidadActual,DataWithoutArchives,UnidadSinArchivosRutaActual),
   borrarUnidad(Unidades,LetterUnidadActual,DataWithoutActual),
   appendElementToList(DataWithoutActual,UnidadSinArchivosRutaActual,UnidadesFinales),

   /*Modifico todo*/
   /*añado los elementos a la papelera*/
    append(Papelera,ArchivosFiltradosData,NewPapelera),
    mod_papelera_system(SystemAux,NewPapelera,SystemAux2),
    append(PapeleraRoute,ArchivosFiltradosRoutes,NewPapeleraRoute),
    mod_papeleraRoute_system(SystemAux2,NewPapeleraRoute,SystemAux3),



   mod_unidades_system(SystemAux3,UnidadesFinales,NewSystem),!.


/*el comando */
systemDel(System,FileNamePattern,NewSystem):-
    FileNamePattern == "*",
    get_unidades_system(System,Unidades),
    get_routes_system(System,RoutesList),
    get_trash_system(System,Papelera),
    get_trashroute_system(System,PapeleraRoute),
    obtenerRutaActual(RoutesList,RutaActual),
    obtenerUnidadActual(Unidades,UnidadActual),
    get_data_unidad(UnidadActual,DataUnidad),
    get_IDelement_ruta(RutaActual,IDpadre),
    get_IDpadre_ruta(RutaActual, IDpadreRutaActual),
    get_nameElement_ruta(RutaActual,NameRutaActual),
    get_letter_unidad(UnidadActual,LetterUnidadActual),

    /*hijos ruta actual*/
    get_hijos_ruta(RutaActual,HijosRutaActual),

    /*hijos ruta actual*/
    filterArchivesRoutes(RoutesList,IDpadre,HijosRutaActual,ArchivosFiltradosRoutes),

    /*borro las rutas*/
    deleteArchivesRoutes(ArchivosFiltradosRoutes,RoutesList,RoutesWithoutArchives),


    filterArchivesData(DataUnidad,IDpadre, ArchivosFiltradosData),
    deleteElementsListToList(ArchivosFiltradosData,DataUnidad,DataWithoutArchives),


   /*obtengo los hijos y borro los hijos*/
   maplist(get_name_archivo,ArchivosFiltradosData,NamesArchivos),
   deleteElementsListToList(HijosRutaActual,NamesArchivos,HijosSinArchivos),


   /*los borro de los hijos actuales*/
   /*lo seteo*/
   mod_hijos_ruta(RutaActual,HijosSinArchivos,RutaHijosSinArchivos), %---> ruta sin archivos de hijo


   /*ahora establezco las modificaciones en las listas*/
   borrarRuta(RoutesWithoutArchives,NameRutaActual,IDpadreRutaActual,RoutesListWithoutRouteActual),
   appendElementToList(RoutesListWithoutRouteActual,RutaHijosSinArchivos,RutasFinales),
   mod_rutas_system(System,RutasFinales,SystemAux),

   /*data de la unidad
   */
   mod_data_unidad(UnidadActual,DataWithoutArchives,UnidadSinArchivosRutaActual),
   borrarUnidad(Unidades,LetterUnidadActual,DataWithoutActual),
   appendElementToList(DataWithoutActual,UnidadSinArchivosRutaActual,UnidadesFinales),

   /*Modifico todo*/
   /*añado los elementos a la papelera*/
    append(Papelera,ArchivosFiltradosData,NewPapelera),
    mod_papelera_system(SystemAux,NewPapelera,SystemAux2),
    append(PapeleraRoute,ArchivosFiltradosRoutes,NewPapeleraRoute),
    mod_papeleraRoute_system(SystemAux2,NewPapeleraRoute,SystemAux3),



   mod_unidades_system(SystemAux3,UnidadesFinales,NewSystem),!.


systemDel(System,FileNamePattern,NewSystem):-
    /*verifico que sea visible desde la ruta actual*/
    %debe ser visible desde la ruta actual
    split_string(FileNamePattern, ".","",[Nombre,Formato]),
    split_string(FileNamePattern,".","",P), %aca tengo el nombre del archivo separado de su formato
    length(P,Length), Length > 1, 
    %debo buscarlo en los hijos visibles desde la ruta actual
    get_unidades_system(System,Unidades),
    get_routes_system(System,RoutesList),
    get_trash_system(System,Papelera),
    get_trashroute_system(System,PapeleraRoute),

    obtenerRutaActual(RoutesList,RutaActual),
    get_IDelement_ruta(RutaActual,IDpadre),
    get_IDpadre_ruta(RutaActual,IDpadreRutaActual),
    get_nameElement_ruta(RutaActual,NameRutaActual),

    get_hijos_ruta(RutaActual,HijosRutaActual),
    /**/
    member(HijosRutaActual,Nombre),

    /*si existe como hijo*/
    obtenerUnidadActual(Unidades,UnidadActual),
    get_letter_unidad(UnidadActual,LetterUnidadActual),
    get_data_unidad(UnidadActual,DataUnidadActual),    
    filterEspecificArchive(DataUnidadActual,IDpadre,Nombre,Formato,ArchiveSearched),
    /*modifico el data de la unidad*/
    deleteArchive(ArchiveSearched,DataUnidadActual,NewDataUnidad),
    mod_data_unidad(UnidadActual,NewDataUnidad,NewUnidadActual),

    /*reemplazo la unidad por la que tiene nuevo data*/
    borrarUnidad(Unidades,LetterUnidadActual,UnidadesWithoutActual),
    %agrego la nueva
    appendElementToList(UnidadesWithoutActual,NewUnidadActual,NewUnidades),
    /*modifcio las unidades en system*/
    mod_unidades_system(System,NewUnidades,SystemAux1),

    /*---------------------ahora veo las rutas--------------*/
    deleteArchivoFromRoutes(RoutesList,Nombre,IDpadre,NewRoutes),
    mod_rutas_system(SystemAux1,NewRoutes,SystemAux2),

    /*modifico los hijos de la ruta actual*/
    get_hijos_ruta(RutaActual,HijosRutaActual),
    deleteElement(HijosRutaActual,Nombre,HijosRutaActualSinArchivo),

    /*modifiico la ruta actual*/
    mod_hijos_ruta(RutaActual,HijosRutaActualSinArchivo,NewRutaActual),
    get_routes_system(SystemAux2,RoutesAux),
    /*la borro*/
    borrarRuta(RoutesAux,NameRutaActual,IDpadreRutaActual,RutasSinActual),
    appendElementToList(RutasSinActual,NewRutaActual,RoutesFinales),
    mod_rutas_system(SystemAux2,RoutesFinales,SystemAux3),

    /*ahora modifico las papeleras*/
    appendElementToFinal(Papelera,ArchiveSearched,NewPapelera),
    filterEspecificArchiveRoute(RoutesList,IDpadre,Nombre,RouteArchivo),
    appendElementToFinal(PapeleraRoute,RouteArchivo,NewPapeleraRoute),

    /*modifico todo*/
    mod_papelera_system(SystemAux3,NewPapelera,SystemAux4),
    mod_papeleraRoute_system(SystemAux4,NewPapeleraRoute,NewSystem),!.




/*Ahora el caso de que el FIlenamePattern sea un directorio....*/
systemDel(System,FileNamePattern,NewSystem):-
    /*tiene que ser visible desde la ruta actual*/
    /*caso del direactorio*/
    split_string(FileNamePattern,".","",D),
    length(D,Length), Length == 1, %es directorio

    get_routes_system(System,RoutesList),
    get_unidades_system(System,Unidades),
    get_trash_system(System,Papelera),
    get_trashroute_system(System,PapeleraRoute),
    obtenerRutaActual(RoutesList,RutaActual),
    obtenerUnidadActual(Unidades,UnidadActual),
    /*datos ruta actual*/
   
    get_IDpadre_ruta(RutaActual,IDpadreRutaActual),
    get_hijos_ruta(RutaActual,HijosRutaActual),
    get_nameElement_ruta(RutaActual,NameElementRutaActual),
    member(HijosRutaActual,FileNamePattern), 

    /*datos unidad actual*/
    get_data_unidad(UnidadActual,DataUnidadActual),
    get_letter_unidad(UnidadActual,LetterUnidadActual),

    /*obtengo todas las apariciones del directorio con id de padreRutaActual*/
    filterRoutes(RoutesList,FileNamePattern,IDpadreRutaActual,AparitionsFolder),
    /*obtengo, con los id de los elementos, los elemmentos del data a borrar*/
    maplist(obtainID,AparitionsFolder,IDsdataToDelete),
    /*obtengo la data*/
    obtainDataFromDataByID(IDsdataToDelete,DataUnidadActual,DataSearched),

    /*ahora efectuo los borrados y modificaciones*/
    deleteElementsListToList(DataUnidadActual,DataSearched,NewDataUnidadAct),

    mod_data_unidad(UnidadActual,NewDataUnidadAct,NewUnidadActual),
    borrarUnidad(Unidades,LetterUnidadActual,UnidadesWithoutUnidadActual),
    appendElementToList(UnidadesWithoutUnidadActual,NewUnidadActual,UnidadesFinales),

    /*borro las rutas*/
    deleteElementsListToList(AparitionsFolder,RoutesList,NewRoutesList),

    /*modifico los hijos de la ruta actual*/
    deleteElement(HijosRutaActual,FileNamePattern,NewHijosRutaActual),
    mod_hijos_ruta(RutaActual,NewHijosRutaActual,NewRutaActual),

    /*MODIFICO*/
    borrarRuta(NewRoutesList,NameElementRutaActual,IDpadreRutaActual,RoutesListWithoutRouteActual),
    appendElementToList(RoutesListWithoutRouteActual,NewRutaActual,RutasFinales),


    /*capa modificadora system*/
    mod_unidades_system(System,UnidadesFinales,SystemAux1),
    mod_rutas_system(SystemAux1,RutasFinales,SystemAux2),

    append(PapeleraRoute,AparitionsFolder,NewPapeleraRoute),
    append(Papelera,DataSearched,NewPapelera),
    mod_papeleraRoute_system(SystemAux2,NewPapeleraRoute,SystemAux3),
    mod_papelera_system(SystemAux3,NewPapelera,NewSystem),!.

    


/* TDA system - copy: Predicado para copiar un archivo o carpeta desde una ruta origen a una ruta destino.*/
/*predicado para saber todas las posibles rutas de un directorio o raiz*/

/*regla para encontrar La ruta con el targetPath*/
getTargetPath([X|_],TargetPath,X):-
    get_StringForm_ruta(X,StringForm), StringForm == TargetPath,!.
getTargetPath([_|R],TargetPath,X):-
 getTargetPath(R,TargetPath,X),!.

 /*regla para Incrementar los IDS de los elementos a copiar*/

 /*predicado que suma ID del correlatico a todos los elementos a copiar*/
 incrementarID([],_,[]):-!.
 incrementarID([_|R],Correlativo,[Y|R2]):-
    NewID is Correlativo +1,
    Y is NewID,
    incrementarID(R,NewID,R2),!.
    
/*Una regla que aplique los nuevos ids a los elementos copiados*/
aplicar_nuevosIDs([], _, []):-!.
aplicar_nuevosIDs([X|Xs], [Y|Ys], [R|Result]) :-
    mod_id_archivo(Y,X,R),
    aplicar_nuevosIDs(Xs, Ys, Result),!.

aplicar_nuevosIDs([X|Xs], [Y|Ys], [R|Result]) :-
    mod_id_directorio(Y,X,R),
    aplicar_nuevosIDs(Xs, Ys, Result),!.

aplicar_nuevosIDs([X|Xs], [Y|Ys], [R|Result]) :-
    mod_id_ruta(Y,X,R),
    aplicar_nuevosIDs(Xs, Ys, Result),!.


/*regla para obtener el nombre del elemento junto con su ID nuevo, antiguo, y nombre*/
obtainInfoElements([],_,[]):-!.
obtainInfoElements([ND|NDr], [OD|ODr],[[X,Y,Z]|Result]):-
    get_id_archivo(ND,X),
    get_name_archivo(ND,Y),
    get_id_archivo(OD,Z),
    obtainInfoElements(NDr,ODr,Result),!.

obtainInfoElements([],_,[]):-!.
obtainInfoElements([ND|NDr], [OD|ODr],[[X,Y,Z]|Result]):-
    get_id_directorio(ND,X),
    get_name_directorio(ND,Y),
    get_id_directorio(OD,Z),
    obtainInfoElements(NDr,ODr,Result),!.

/*predicado auciliar para el de abajo para obtener el nuevo id del padre*/
% Regla para buscar el NewID en la primera lista
searchID([], _, 0) :- !.
searchID([[NewID, _, ID] | _], ID, NewID) :- !.
searchID([_ | R], ID, NewID) :- 
    searchID(R, ID, NewID).

% Regla para modificar el ID padre en la segunda lista
modIDpadreDataToCopy([], _, _, []):-!.
modIDpadreDataToCopy([D | Dr], NuevosIDs, Lista1, [ND | Result]) :-
    get_id_padreArchivo(D,OldID),
    searchID(NuevosIDs, OldID, NewParentID),
    mod_idpadre_archivo(D, NewParentID, ND),
    modIDpadreDataToCopy(Dr, NuevosIDs, Lista1, Result),!.

modIDpadreDataToCopy([D | Dr], NuevosIDs, Lista1, [ND | Result]) :-
    get_idPadre_directorio(D,OldID),
    searchID(NuevosIDs, OldID, NewParentID),
    mod_idpadre_directorio(D, NewParentID, ND),
    modIDpadreDataToCopy(Dr, NuevosIDs, Lista1, Result),!.

modIDpadreDataToCopy([D | Dr], NuevosIDs, Lista1, [ND | Result]) :-
    get_IDpadre_ruta(D,OldID),
    searchID(NuevosIDs, OldID, NewParentID),
    mod_idpadre_ruta(D, NewParentID, ND),
    modIDpadreDataToCopy(Dr, NuevosIDs, Lista1, Result),!.

/*Ahora defino una regla que modifique las rutas string de cada ruta final*/
/*Primero necesito realizar un substring de los string-plit*/

buildSubString([],_,_,[]):-!.
buildSubString([_,X|R],Source,[X|R]):-
    X = Source,!.
buildSubString([_|R],Source,R1):-
    buildSubString(R,Source,R1),!.
/*Defino la regla para concatenar*/
concatenar_subcadenas([], "").
concatenar_subcadenas([X], X) :- !.
concatenar_subcadenas([X | R], Resultado) :-
    concatenar_subcadenas(R, Resto),
    string_concat(X, "/", Aux),
    string_concat(Aux, Resto, Resultado).

/*con las dos reglas anteriores defino una regla que actualice los strings de las rutas*/
actualizarStrings([],_,_,[]):-!.
actualizarStrings([R|Rr],TargetPath,Source,[NR|Result]):-
    get_StringForm_ruta(R,StringFormRuta),
    split_string(StringFormRuta,"/","",StringFormList),
    buildSubString(StringFormList,Source,ListToConcat),
    concatenar_subcadenas(ListToConcat,Aux),
    string_concat(TargetPath,Aux,NewRouteStr),
    mod_stringForm_ruta(R,NewRouteStr,NR), actualizarStrings(Rr,TargetPath,Source,Result),!.
/*A la ruta de source le agrego como id padre el ultimo elemento del targetPath*/
modIDsource([],_,_,_,[]):-!.
modIDsource([R|Rr],Source,TargetPath,NewID,[Nr|Result]):-
    string_concat(TargetPath,Source,Saux),
    string_concat(Saux,"/",FinalStrToCompare),
    get_StringForm_ruta(R,Str),
    Str = FinalStrToCompare,
    get_nameElement_ruta(R,NameRuta), NameRuta = Source,
    mod_idpadre_ruta(R,NewID,Nr),
    modIDsource(Rr,Source,TargetPath,NewID,Result),!.
modIDsource([R|Rr],Source,TargetPath,NewID,[R|Result]):-
    modIDsource(Rr,Source,TargetPath,NewID,Result),!.

systemCopy(System,Source,TargetPath,NewSystem):-

    /*primer caso, un archivo*/
    split_string(Source,".","",[Nombre,Formato]),
    split_string(Source,".","",P), %aca tengo el nombre del archivo separado de su formato
    length(P,Length), Length > 1, 

    /*obtengo la info del sistema*/
    get_routes_system(System,RoutesList),
    get_unidades_system(System,Unidades),



    obtenerRutaActual(RoutesList,RutaActual),
    get_IDelement_ruta(RutaActual,IDrutaActual),
    get_hijos_ruta(RutaActual,HijosRutaActual),
    /*si es hijo*/
    member(HijosRutaActual,Nombre),
  /*Info de unidad actual*/
    obtenerUnidadActual(Unidades,UnidadActual),
    get_data_unidad(UnidadActual,DataUnidadActual),
    get_letter_unidad(UnidadActual,LetterUnidadActual),
    /*ubico el targetPath*/
    getTargetPath(RoutesList,TargetPath,RouteWithTargetPath),
    /*datos del targetPath*/
    get_IDelement_ruta(RouteWithTargetPath,IDTargetPath),
    get_hijos_ruta(RouteWithTargetPath,HijosTargetPath),
    get_nameElement_ruta(RouteWithTargetPath,NameRouteTargetPath),
    get_IDpadre_ruta(RouteWithTargetPath,IDpadreTargetPath),
    /*encuentro el archivo a copiar.. debe ser visible desde la ruta actual*/
    filterEspecificArchive(DataUnidadActual,IDrutaActual,Nombre,Formato,ArchivoACopiar),

    /*al crear una copia, creo un archivo con lo mismo variando en el ID padre y su id*/
    get_correlativo_system(System,Correlativo),
    NewID is Correlativo+1,
   
    mod_id_archivo(ArchivoACopiar,NewID,NewArchivoAux),
    /*IDpadre*/
    mod_idpadre_archivo(NewArchivoAux,IDTargetPath,NewArchivoToData),

    /*lo agrego a la data*/
    appendElementToFinal(DataUnidadActual,NewArchivoToData,NewDataUnidad),
    /*seteo la unidad*/
    mod_data_unidad(UnidadActual,NewDataUnidad,NewUnidadWithNewArchive),

    /*aumento el correlativo*/
    mod_correlativo_system(System,NewID,SystemAux1),

    /*construyo la ruta para el archivo*/
    string_concat(Nombre,".",NameArchivoAux),
    string_concat(NameArchivoAux,Formato,StringForm2),
    string_concat(TargetPath,StringForm2,StringFormRuta),

    /*ahora la ruta*/
    ruta(NewID,Nombre,IDTargetPath,StringFormRuta,-1,RutaArchivoCopy),
    /*lo agrego a las rutas*/
    appendElementToList(RoutesList,RutaArchivoCopy,NewRoutesList),

    /*Lo agrego como hijo al targetPath*/
    appendElementToFinal(HijosTargetPath,Nombre,NewHijosTargetPath),
    /*set*/
    mod_hijos_ruta(RouteWithTargetPath,NewHijosTargetPath,NewTargetPath),

    /*modifico todo*/
    borrarUnidad(Unidades,LetterUnidadActual,UnidadesWithoutActual),
    appendElementToList(UnidadesWithoutActual,NewUnidadWithNewArchive,NewUnidades),

    /*rutas*/
    borrarRuta(NewRoutesList,NameRouteTargetPath,IDpadreTargetPath,RoutesWithoutTargetPath),
    appendElementToFinal(RoutesWithoutTargetPath,NewTargetPath,NewRoutesFinals),
    /*modifico unnidades*/
    mod_unidades_system(SystemAux1,NewUnidades,SystemAux2),
    mod_rutas_system(SystemAux2,NewRoutesFinals,NewSystem),!.
    

/*caso de que este copiando un directorio*/


systemCopy(System,Source,TargetPath,NewSystem):-
    
    split_string(Source,".","",P), 
    length(P,Length), Length == 1, %Entonces, es un directorio

    get_routes_system(System,RoutesList),
    get_unidades_system(System,Unidades),
    obtenerRutaActual(RoutesList,RutaActual),
    obtenerUnidadActual(Unidades,UnidadActual),
    get_correlativo_system(System,Correlativo),
    /*datos ruta actual*/
    get_IDpadre_ruta(RutaActual,IDpadreRutaActual),
    get_hijos_ruta(RutaActual,HijosRutaActual),
    member(HijosRutaActual,FileNamePattern), 

     /*datos unidad actual*/
    get_data_unidad(UnidadActual,DataUnidadActual),
    get_letter_unidad(UnidadActual,LetterUnidadActual),
    /*obtengo todas las apariciones del directorio con id de padreRutaActual*/
    filterRoutes(RoutesList,FileNamePattern,IDpadreRutaActual,AparitionsFolder),
     maplist(obtainID,AparitionsFolder,IDsDataToCopy),

      /*obtengo la data*/
    obtainDataFromDataByID(IDsDataToCopy,DataUnidadActual,DataToCopy),

    /*a toda la data debo sumar el correlativo incremental*/
    incrementarID(IDsDataToCopy,Correlativo,IDsNuevos),

    /*a cada ruta le mapeo los nuevos ids*/
    aplicar_nuevosIDs(IDsNuevos,DataToCopy,NewDataWihtNewID),
    obtainInfoElements(NewDataWihtNewID,DataToCopy,InfoElements),
 
    modIDpadreDataToCopy(NewDataWihtNewID,InfoElements,InfoElements,NewDataAux),
    /*Modifico el data de la unidad*/

    /*ahora hago lo mismo con las rutas*/
    reversar_lista(AparitionsFolder,AparitionsFolderReversed),
    aplicar_nuevosIDs(IDsNuevos,AparitionsFolderReversed,RoutesWithNewIDS),
    modIDpadreDataToCopy(RoutesWithNewIDS,InfoElements,InfoElements,NewRoutesAux),

    /*Ahora modifico las rutas anadiendoles el string del targetPath*/
    actualizarStrings(NewRoutesAux,TargetPath,Source,FinalRoutes),
    /*agrego las rutas con los nuevos strings a las rutas*/
    append(RoutesList,FinalRoutes,FinalRoutesForSystem),

    /*edito los hijos de la ruta de targetPath*/
    getTargetPath(FinalRoutesForSystem,TargetPath,RouteWithTargetPath),
    /*lo manipulo para saber el id del padre de source...*/
    get_IDelement_ruta(RouteWithTargetPath,ID),
    get_nameElement_ruta(RouteWithTargetPath,NameRouteWithTargetPath),
    get_IDpadre_ruta(RouteWithTargetPath,IDpadreTargetPath),
    get_hijos_ruta(RouteWithTargetPath,HijosTargetPath),
    appendElementToFinal(HijosTargetPath,Source,NewHijosTargetPath),
    mod_hijos_ruta(RouteWithTargetPath,NewHijosTargetPath,NewRouteWithTargetPath),


    modIDsource(FinalRoutesForSystem,Source,TargetPath,ID,FinalRoutesForSystemAux1),
    borrarRuta(FinalRoutesForSystemAux1,NameRouteWithTargetPath,IDpadreTargetPath,FinalRoutesForSystemAux2),
    appendElementToFinal(FinalRoutesForSystemAux2,NewRouteWithTargetPath,FinalRoutesForSystemAux3),


    


    /*Ahora modifico todo*/
    append(DataUnidadActual,NewDataAux,FinalData),
    mod_data_unidad(UnidadActual,FinalData,UnidadFinal),
    borrarUnidad(Unidades,LetterUnidadActual,UnidadesWithoutActual),
    appendElementToList(UnidadesWithoutActual,UnidadFinal,UnidadesFinales),

    /*Modifico*/
    mod_unidades_system(System,UnidadesFinales,SystemAux),
    mod_rutas_system(SystemAux,FinalRoutesForSystemAux3,NewSystem),!.



/* move .. */
/*Caso 1.. mover un archivo cuando no existe*/
/*Defino una regla auxiliar para poder encontrar la ruta del source dado un Source y un iD padre*/
searchSource([],_,_,[]):-!.
searchSource([R|_],Source,IDpadreSource,R):-
    get_nameElement_ruta(R,Name),
    get_IDpadre_ruta(R,ID),
    Source == Name, ID == IDpadreSource,!.
searchSource([_|R1],Source,IDpadreSource,R):-
    searchSource(R1,Source,IDpadreSource,R),!.
    /*Lo mismo para directorio y data*/

searchSourceD([R|_],Source,IDpadreSource,R):-
    get_name_directorio(R,Name),
    get_idPadre_directorio(R,ID),
    Source == Name, ID == IDpadreSource,!.
searchSourceD([_|R1],Source,IDpadreSource,R):-
    searchSourceD(R1,Source,IDpadreSource,R),!.


systemMove(System,Source,TargetPath,NewSystem):-
/*Para el movimiento de un archivo basta hacer lo siguiente*/
/*buscar la ruta del archivo a mover
  modificar su ruta cambiandolo por el targetpat=nombrearchivo.formato  */
split_string(Source,".","",[Nombre,Formato]),
    split_string(Source,".","",P), %aca tengo el nombre del archivo separado de su formato
    length(P,Length), Length > 1,

get_routes_system(System,RoutesList),
get_unidades_system(System,Unidades),

/*ruta actual*/
obtenerRutaActual(RoutesList,RutaActual),
get_IDelement_ruta(RutaActual,IDRutaActual),
get_nameElement_ruta(RutaActual,NameRutaActual),
get_IDpadre_ruta(RutaActual,IDpadreRutaActual),

/*Unidad Actual*/
obtenerUnidadActual(Unidades,UnidadActual),
get_data_unidad(UnidadActual,DataUnidadActual),
get_letter_unidad(UnidadActual,LetterUnidadActual),

get_hijos_ruta(RutaActual,HijosRutaActual),
 member(HijosRutaActual,Nombre),

/*consigo el targetPath*/
getTargetPath(RoutesList,TargetPath,RouteWithTargetPath),
get_IDelement_ruta(RouteWithTargetPath,IDRouteWithTargetPath),
get_hijos_ruta(RouteWithTargetPath,HijosRutaTargetPath),
get_nameElement_ruta(RouteWithTargetPath,NameRouteTargetPath),
get_IDpadre_ruta(RouteWithTargetPath,IDPadreRouteWithTargetPath),
\+member(HijosRutaTargetPath,Nombre),
/*Busco el archivo a mover */
filterEspecificArchive(DataUnidadActual,IDRutaActual,Nombre,Formato,ArchivoAMover),
filterEspecificArchiveRoute(RoutesList,IDRutaActual,Nombre,RutaArchivoAMover),

/*Modifico las dependencias y el stringForm*/
mod_idpadre_archivo(ArchivoAMover,IDRouteWithTargetPath,NewArchivoAMover),
mod_idpadre_ruta(RutaArchivoAMover,IDRouteWithTargetPath,NewRutaArchivoAMover),

/*modifico el string*/
   string_concat(Nombre,".",NameArchivoAux),
    string_concat(NameArchivoAux,Formato,StringForm2),
    string_concat(TargetPath,StringForm2,StringFormRuta),
mod_stringForm_ruta(NewRutaArchivoAMover,StringFormRuta,NewRutaArchivo),

/*lo agrego como hijo al target path*/
appendElementToFinal(HijosRutaTargetPath,Nombre,NewHijosTargetPath),
mod_hijos_ruta(RouteWithTargetPath,NewHijosTargetPath,NewRouteWithTargetPath),

/*mod todo*/
borrarRuta(RoutesList,NameRouteTargetPath,IDPadreRouteWithTargetPath,RoutesWithoutTargetPath),
appendElementToFinal(RoutesWithoutTargetPath,NewRouteWithTargetPath,RoutesAux1),
borrarRuta(RoutesAux1,Nombre,IDRutaActual,RoutesWithoutArchive),
appendElementToFinal(RoutesWithoutArchive,NewRutaArchivo,RutasFinales),

/*ahora la data*/
    deleteArchive(ArchivoAMover,DataUnidadActual,DataWithoutArchive),
    appendElementToFinal(DataWithoutArchive,NewArchivoAMover,DataUnidadFinal),
    mod_data_unidad(UnidadActual,DataUnidadFinal,NewUnidadFinal),
    /*unity list*/
     borrarUnidad(Unidades,LetterUnidadActual,UnidadesWithoutActual),
     appendElementToList(UnidadesWithoutActual,NewUnidadFinal,UnidadesFinales),
/*Modifico todo*/
mod_rutas_system(System,RutasFinales,Saux),
get_routes_system(Saux,Routes),
deleteElement(HijosRutaActual,Nombre,HijosRutaActualSinArchivo),
mod_hijos_ruta(RutaActual,HijosRutaActualSinArchivo,NewRutaActual),
borrarRuta(Routes,NameRutaActual,IDpadreRutaActual,RoutesFinals),
appendElementToList(RoutesFinals,NewRutaActual,RoutesFinals2),
mod_rutas_system(Saux,RoutesFinals2,Saux2),
mod_unidades_system(Saux2,UnidadesFinales,NewSystem),!.


/*Caso 2.. cuando existe un archivo como hijo en la ruta targetPath con el mismo nombre*/
systemMove(System,Source,TargetPath,NewSystem):-
split_string(Source,".","",[Nombre,Formato]),
    split_string(Source,".","",P), %aca tengo el nombre del archivo separado de su formato
    length(P,Length), Length > 1,

get_routes_system(System,RoutesList),
get_unidades_system(System,Unidades),

/*ruta actual*/
obtenerRutaActual(RoutesList,RutaActual),
get_IDelement_ruta(RutaActual,IDRutaActual),
get_nameElement_ruta(RutaActual,NameRutaActual),
get_IDpadre_ruta(RutaActual,IDpadreRutaActual),

/*Unidad Actual*/
obtenerUnidadActual(Unidades,UnidadActual),
get_data_unidad(UnidadActual,DataUnidadActual),
get_letter_unidad(UnidadActual,LetterUnidadActual),

get_hijos_ruta(RutaActual,HijosRutaActual),
member(HijosRutaActual,Nombre),

/*consigo el targetPath*/
getTargetPath(RoutesList,TargetPath,RouteWithTargetPath),
get_IDelement_ruta(RouteWithTargetPath,IDRouteWithTargetPath),
get_hijos_ruta(RouteWithTargetPath,HijosRutaTargetPath),
member(HijosRutaTargetPath,Nombre),%si existe el archivo lo reemplazo
/*necesito la informacion del archivo ubicado en el targetPath*/
filterEspecificArchive(DataUnidadActual,IDRouteWithTargetPath,Nombre,_,ArchivoEnDestino),


/*Borro el archivo existente apra pode reemplazarlo*/
borrarRuta(RoutesList,Nombre,IDRouteWithTargetPath,RoutesWithoutArchiveDestiny),
deleteArchive(ArchivoEnDestino,DataUnidadActual,DataUnidadActual1),




/**/
get_nameElement_ruta(RouteWithTargetPath,NameRouteTargetPath),
get_IDpadre_ruta(RouteWithTargetPath,IDPadreRouteWithTargetPath),
/*Busco el archivo a mover */
filterEspecificArchive(DataUnidadActual1,IDRutaActual,Nombre,Formato,ArchivoAMover),
filterEspecificArchiveRoute(RoutesWithoutArchiveDestiny,IDRutaActual,Nombre,RutaArchivoAMover),

/*Modifico las dependencias y el stringForm*/
mod_idpadre_archivo(ArchivoAMover,IDRouteWithTargetPath,NewArchivoAMover),
mod_idpadre_ruta(RutaArchivoAMover,IDRouteWithTargetPath,NewRutaArchivoAMover),

/*modifico el string*/
   string_concat(Nombre,".",NameArchivoAux),
    string_concat(NameArchivoAux,Formato,StringForm2),
    string_concat(TargetPath,StringForm2,StringFormRuta),
mod_stringForm_ruta(NewRutaArchivoAMover,StringFormRuta,NewRutaArchivo),

/*lo agrego como hijo al target path*/

/*mod todo*/
borrarRuta(RoutesWithoutArchiveDestiny,NameRouteTargetPath,IDPadreRouteWithTargetPath,RoutesWithoutTargetPath),
appendElementToFinal(RoutesWithoutTargetPath,RouteWithTargetPath,RoutesAux1),
borrarRuta(RoutesAux1,Nombre,IDRutaActual,RoutesWithoutArchive),
appendElementToFinal(RoutesWithoutArchive,NewRutaArchivo,RutasFinales),

/*ahora la data*/
    deleteArchive(ArchivoAMover,DataUnidadActual1,DataWithoutArchive),
    appendElementToFinal(DataWithoutArchive,NewArchivoAMover,DataUnidadFinal),
    mod_data_unidad(UnidadActual,DataUnidadFinal,NewUnidadFinal),
    /*unity list*/
     borrarUnidad(Unidades,LetterUnidadActual,UnidadesWithoutActual),
     appendElementToList(UnidadesWithoutActual,NewUnidadFinal,UnidadesFinales),
/*Modifico todo*/
mod_rutas_system(System,RutasFinales,Saux),
get_routes_system(Saux,Routes),
deleteElement(HijosRutaActual,Nombre,HijosRutaActualSinArchivo),
mod_hijos_ruta(RutaActual,HijosRutaActualSinArchivo,NewRutaActual),
borrarRuta(Routes,NameRutaActual,IDpadreRutaActual,RoutesFinals),
appendElementToList(RoutesFinals,NewRutaActual,RoutesFinals2),
mod_rutas_system(Saux,RoutesFinals2,Saux2),
mod_unidades_system(Saux2,UnidadesFinales,NewSystem),!.




/*Ahora el caso en el que se deba move run directorio completo*/
/*Aqui necesito mover todo slo arcivos del directorio.. haciendo algo similar a la regla copy en
cuanto al manejo de rutas*/
systemMove(System,Source,TargetPath,NewSystem):-
    /*Obtengo toda la info del sistema primero*/
    split_string(Source,".","",P), %aca tengo el nombre del archivo separado de su formato
    length(P,Length), Length == 1, %entonces es un directorio

get_routes_system(System,RoutesList),
get_unidades_system(System,Unidades),

/*ruta actual*/
obtenerRutaActual(RoutesList,RutaActual),
get_IDelement_ruta(RutaActual,IDRutaActual),
get_nameElement_ruta(RutaActual,NameRutaActual),
get_IDpadre_ruta(RutaActual,IDpadreRutaActual),

/*Unidad Actual*/
obtenerUnidadActual(Unidades,UnidadActual),
get_data_unidad(UnidadActual,DataUnidadActual),
get_letter_unidad(UnidadActual,LetterUnidadActual),

get_hijos_ruta(RutaActual,HijosRutaActual),
 member(HijosRutaActual,Nombre),

/*consigo el targetPath*/
getTargetPath(RoutesList,TargetPath,RouteWithTargetPath),
get_IDelement_ruta(RouteWithTargetPath,IDRouteWithTargetPath),
get_hijos_ruta(RouteWithTargetPath,HijosRutaTargetPath),
get_nameElement_ruta(RouteWithTargetPath,NameRouteTargetPath),
get_IDpadre_ruta(RouteWithTargetPath,IDPadreRouteWithTargetPath),
\+member(HijosRutaTargetPath,Nombre),

/*Obtengo als apariciones del directorio*/
filterRoutes(RoutesList,Source,IDpadreRutaActual,AparitionsFolder),
/*teniendo las apariciones deb actuar sobre ellas, realizando un cambio
enla id padre de la ruta source y a las demas modificar sus rutas,*/

/*Busco primero la ruta del Source*/
searchSource(AparitionsFolder,Source,IDRutaActual,RouteOfSource),
/*id de la ruta que contiene a source*/
get_IDelement_ruta(RouteOfSource,IDRouteOfSource),
get_IDpadre_ruta(RouteOfSource,IDpadreRouteOfSource),
/*Modifico el padre de estaruta anadiendo el id del targetPath*/
mod_idpadre_ruta(RouteOfSource,IDRouteWithTargetPath,NewRouteSourceWithIDTargetPath),
/*borro la ruta source y agrego la nueva... asi, agrego la nueva dependencia 
y le modifico los Stringform*/
borrarRuta(AparitionsFolder,Source,IDpadreRouteOfSource,AparitionsFolderWithoutSource),
/*Agrego la ruta seteada*/
appendElementToFinal(AparitionsFolderWithoutSource,NewRouteSourceWithIDTargetPath,AparitionsFolderWithNewSource),
/*Modifico los stringforms de las rutas deonde aparece source.. asi represento el movimiento de la data
similar a lo que ocurre e copy*/
actualizarStrings(AparitionsFolderWithNewSource,TargetPath,Source,AparitionsFolderWithNewRoutes),

/*ahora acualizo la lista orriginal eliminando las apariciones de Source.. todos los elementos que la contengan
de la lsita de rutas principal similar a la regla copy mezclada con del*/
deleteElementsListToList(AparitionsFolder,RoutesList,RoutesWithoutAparitions),
/*agrego als nuevas rutas modificadas a la ultima lista*/
appendElementToFinal(RoutesWithoutAparitions,AparitionsFolderWithNewRoutes,FinalRoutesForSystem),
/*Modifico al sistema*/
mod_rutas_system(System,FinalRoutesForSystem,SystemAux),

/*ahora debo buscar el data que representa al source y modificar su idpadre con el del targetPath*/
searchSourceD(DataUnidadActual,Source,IDRutaActual,DataOfSource),
mod_idpadre_directorio(DataOfSource,IDRouteWithTargetPath,NewDataOfSourceWithNewIDpadre),
deleteArchive(DataOfSource,DataUnidadActual,NewDatUnidadActualWithoutSource),
appendElementToFinal(NewDatUnidadActualWithoutSource,NewDataOfSourceWithNewIDpadre,FinalDataUnidad),
/*Modifico el data de la unidad usando el modificador*/
mod_data_unidad(UnidadActual,FinalDataUnidad,NewUnidadActual),
borrarUnidad(Unidades,LetterUnidadActual,UnidadesWithoutActual),
appendElementToList(UnidadesWithoutActual,NewUnidadActual,NewUnidades),
/*Modifico las unidades del sistema*/
mod_unidades_system(SystemAux,NewUnidades,SystemAux2),

/**/
get_routes_system(SystemAux2,RutasSystemAux2),
/*ahora modifico los hijos de la ruta destino y actual.. borrando en actual y anadiendo en el destino el source*/
deleteElement(HijosRutaActual,Source,HijosRutaActualSinArchivo),
mod_hijos_ruta(RutaActual,HijosRutaActualSinArchivo,NewRutaActual),

borrarRuta(RutasSystemAux2,NameRutaActual,IDpadreRutaActual,RoutesFinals),
appendElementToList(RoutesFinals,NewRutaActual,RoutesFinals2),

appendElementToFinal(HijosRutaTargetPath,Source,NewHijosTargetPath),
mod_hijos_ruta(RouteWithTargetPath,NewHijosTargetPath,NewRouteWithTargetPath),
borrarRuta(RoutesFinals2,NameRouteTargetPath,IDPadreRouteWithTargetPath,RoutesWithoutTargetPath),
appendElementToFinal(RoutesWithoutTargetPath,NewRouteWithTargetPath,RoutesAux1),
mod_rutas_system(SystemAux2,RoutesAux1,NewSystem).



