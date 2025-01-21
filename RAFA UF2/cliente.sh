#!/bin/bash

 PORT="2022"

 echo "Cliente de Dragón Magia Abuelita Miedo 2022"

 echo "1. ENVIO DE CABECERA"
 echo "DMAM" | nc -w 5 localhost $PORT
 DATA=`nc -l -w 5 $PORT`

 echo "3. COMPROBANDO HEADER"
 if [ "$DATA" != "OK_HEADER" ]
 then
   echo "ERROR 1: El header se envió incorrectamente"
      exit 1
   fi

    echo "4. CHECK OK - Enviando FILE_NAME"

        FILE_NAME="dragon.txt"
	echo "CLIENTE Nombre del archivo: $FILE_NAME"
        MD5SUM_FILE_NAME=`echo -n "$FILE_NAME" | md5sum | awk '{print $1}'`
	echo "CLIENTE MD5: $MD5SUM_FILE_NAME"
	
echo "CLIENTE Enviando al servidor el $FILE_NAME $MD5SUM_FILE_NAME"

    echo "FILE_NAME $FILE_NAME $MD5SUM_FILE_NAME" | nc -w 4 localhost $PORT
        DATA=`nc -l -w 4 $PORT`
    if [ "$DATA" != "OK_FILE_NAME" ]
     then
     echo "ERROR 2: El prefijo se envió incorrectamente"
        exit 2
         fi

     echo "7. CHECK OK - Enviando contenido del archivo"
         cat client/$FILE_NAME | nc localhost $PORT
         DATA=`nc -l -w 5 $PORT`

     echo "10. COMPROBANDO RESPUESTA"
         if [ "$DATA" != "OK_DATA" ]
      then
     echo "ERROR 3: Los datos se enviaron incorrectamente"
         exit 3
         fi

     echo "11. ENVIANDO MD5 DEL CONTENIDO DEL ARCHIVO"

         MD5SUM_FILE_CONTENT=`md5sum client/$FILE_NAME | awk '{print $1}'`
     echo "FILE_MD5 $MD5SUM_FILE_CONTENT" | nc -w 54 localhost $PORT
         DATA=`nc -l -w 5 $PORT`

         if [ "$DATA" != "OK_FILE_MD5" ]
         then
     echo "ERROR 4: El MD5 del contenido no coincide"
         exit 4
         fi

 echo "14. FIN - SE HA MANDADO TODO OK"
                                
