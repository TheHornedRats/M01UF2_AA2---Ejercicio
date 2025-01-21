#!/bin/bash

PORT="2022"

echo "Servidor de Dragón Magia Abuelita Miedo 2022"

echo "0. ESCUCHAMOS"
DATA=`nc -l -w 5 $PORT`

if [ "$DATA" != "DMAM" ]
then
  echo "ERROR 1: Cabecera incorrecta"
  echo "KO_HEADER" | nc localhost $PORT
      exit 1
      fi

   echo "2. CHECK OK - Enviando OK_HEADER"
   echo "OK_HEADER" | nc localhost $PORT

   echo "5. COMPROBANDO PREFIJO"
  DATA=`nc -l -w 5 $PORT`
echo "SERVIDOR Datos recibidos correctamente: $DATA"

   PREFIX=`echo "$DATA" | cut -d " " -f 1`
      NOMBRE_ARCHIVO=`echo "$DATA" | cut -d " " -f 2`
echo "SERVIDOR Nombre extraido: $NOMBRE_ARCHIVO"

      MD5SUM_RECIBIDO=`echo "$DATA" | cut -d " " -f 3 | tr -d '\r\n'`
echo "SERVIDOR MD5 RECIBIDO CORRECTAMENTE: $MD5SUM_RECIBIDO"

   if [ "$PREFIX" != "FILE_NAME" ]
   then
   echo "ERROR 2: Prefijo incorrecto"
   echo "KO_FILE_NAME" | nc localhost $PORT
   exit 2
       fi
	MD5SUM_PROCESADO=`echo -n "$NOMBRE_ARCHIVO" | md5sum | awk '{print $1}'`
echo "SERVIDOR MD5 Calculado apartir del nombre: $MD5SUM_PROCESADO"

	if [ "$MD5SUM_RECIBIDO" != "$MD5SUM_PROCESADO" ]
	then
		echo "ERROR 2.1: MD5 Incorrecto"
		echo "Ko_FILE_NAME_MD5" | nc localhost $PORT
		exit 2
	else 
		echo "SERVIDOR MD5 COINCIDE"

	fi

           echo "6. ENVIANDO OK_FILE_NAME"
       echo "OK_FILE_NAME" | nc localhost $PORT
      

       echo "8. RECIBIENDO Y ALMACENANDO DATOS"
     DATA=`nc -l -w 5 $PORT`

       if [ "$DATA" == "" ]
        then
       echo "ERROR 3: Datos incorrectos"
       echo "KO_DATA" | nc localhost $PORT
    exit 3
        fi

       echo "$DATA" > server/dragon.txt
       echo "9. CHECK Y RESPUESTA"
       echo "OK_DATA" | nc localhost $PORT

   echo "12. RECIBIENDO MD5"
  DATA=`nc -l -w 5 $PORT`   
   PREFIX=`echo "$DATA" | cut -d " " -f 1`
      MD5SUM_RECIBIDO=`echo "$DATA" | cut -d " " -f 2`

  if [ "$PREFIX" != "FILE_MD5" ]
       then
       echo "ERROR 4: Prefijo MD5 incorrecto"
       echo "KO_FILE_MD5" | nc localhost $PORT
  exit 4
        fi

     MD5SUM_PROCESADO=`md5sum server/dragon.txt | awk '{print $1}'`

       if [ "$MD5SUM_RECIBIDO" != "$MD5SUM_PROCESADO" ]
       then
       echo "ERROR 5: MD5 del contenido incorrecto"
       echo "KO_FILE_MD5" | nc localhost $PORT
  exit 5
        fi

       echo "13. CHECK MD5 - ENVIANDO FIN"
       echo "OK_FILE_MD5" | nc localhost $PORT
       
