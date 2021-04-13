#!/bin/bash

MSISDN=$1
IMSI=$2
ICCID=$3
PERFIL=$4
MYSQL="/usr/bin/mysql"
FECHA()
{
        CURRENT_DATE_LOG=`date '+%Y-%m-%d %T.%3N'`
}
DIR_TMP="/home/prepago/fvergara/PORTABILIDAD/tmp"


LOGINFO(){
  FECHA
  echo -e "[$CURRENT_DATE_LOG] ======> \e[1;33m[INFO]\e[0m "$1
}

function CREA_PCSFILE()
{
    MSISDN="\"$1\""
    IMSI="\"$2\""
    ICCID="\"$3\""
    PERFIL="$4"

    LOGINFO "Validando existencia de PCSFILE"
    RESP_PCSFILE=`${MYSQL} -hxxxxxxxx -uxxxxxxxxx -pxxxxxxxxxxxxx SIP -N -e "select count(*) from TBL_PCSFILE where msisdn =${MSISDN} and IMSI=${IMSI} and ICCID=${ICCID}"`

    if [ ${RESP_PCSFILE} -eq 1 ];then
        LOGOK "Existe PCSFILE"
        LOGINFO "Updateando status para reproceso de instalacion"
        ${MYSQL} -hxxxxxxxx -uxxxxxxxxx -pxxxxxxxxxxxxx SIP -e "update TBL_PCSFILE set status='0' where msisdn =${MSISDN}"
    else
        LOGINFO "No existe PCSFILE. Se crea registro con datos de Archivo TPD_A_PP_${FECHA}.txt"
    ##OBTENER DATOS PERFIL
    ${MYSQL} -hxxxxxxxx -uxxxxxxxxx -pxxxxxxxxxxxxx ANR -e "select * from TBL_PERFILES where idPerfil='${PERFIL}'\G" | grep -v "row" > ${DIR_TMP}/datos_perfil.txt
    idPerfil=${PERFIL}
    nombre=`cat ${DIR_TMP}/datos_perfil.txt | grep "nombre:" | awk -F": " '{print $2}'`
    credit=`cat ${DIR_TMP}/datos_perfil.txt | grep "credit:" | awk -F": " '{print "\""$2"\""}'`
    category=`cat ${DIR_TMP}/datos_perfil.txt | grep "category:" | awk -F": " '{print "\""$2"\""}'`
    sp_id=`cat ${DIR_TMP}/datos_perfil.txt | grep "sp_id:" | awk -F": " '{print "\""$2"\""}'`
    tariff_id=`cat ${DIR_TMP}/datos_perfil.txt | grep "tariff_id:" | awk -F": " '{print "\""$2"\""}'`
    lang_id=`cat ${DIR_TMP}/datos_perfil.txt | grep "lang_id:" | awk -F": " '{print "\""$2"\""}'`
    services=`cat ${DIR_TMP}/datos_perfil.txt | grep "services:" | awk -F": " '{print "\""$2"\""}'`
    codigo_sms=`cat ${DIR_TMP}/datos_perfil.txt | grep "codigo_sms:" | awk -F": " '{print $2}'`
    bolsas_flexibles=`cat ${DIR_TMP}/datos_perfil.txt | grep "bolsas_flexibles:" | awk -F": " '{print "\""$2"\""}'`
    recargas_flexibles=`cat ${DIR_TMP}/datos_perfil.txt | grep "recargas_flexibles:" | awk -F": " '{print "\""$2"\""}'`
    recargas_agendadas=`cat ${DIR_TMP}/datos_perfil.txt | grep "recargas_agendadas:" | awk -F": " '{print "\""$2"\""}'`
    voicemail=`cat ${DIR_TMP}/datos_perfil.txt | grep "voicemail:" | awk -F": " '{print $2}' | awk '$1 == "N"{print "\"\""};$1=="S"{print "1"}'`
    cdr=`cat ${DIR_TMP}/datos_perfil.txt | grep "cdr:" | awk -F": " '{print $2}' | awk '$1 == "N"{print ""};$1=="S"{print "\"1\""}'`
    perfil_sap=`cat ${DIR_TMP}/datos_perfil.txt | grep "perfil_sap:" | awk -F": " '{print "\""$2"\""}'`
    perfil_hlr=`cat ${DIR_TMP}/datos_perfil.txt | grep "perfil_hlr:" | awk -F": " '{print "\""$2"\""}'`
    comandos_hlr=`cat ${DIR_TMP}/datos_perfil.txt | grep "comandos_hlr:" | awk -F": " '{print "\""$2"\""}'`
    activacion_vas=`cat ${DIR_TMP}/datos_perfil.txt | grep "activacion_vas:" | awk -F": " '{print "\""$2"\""}'`
    perfil_coresim=`cat ${DIR_TMP}/datos_perfil.txt | grep "perfil_coresim:" | awk -F": " '{print "\""$2"\""}'`
    perfil_sapc=`cat ${DIR_TMP}/datos_perfil.txt | grep "perfil_sapc:" | awk -F": " '{print "\""$2"\""}'`

    INSERT_FINAL="insert into TBL_PCSFILE (msisdn,imsi,iccid,pin,pin2,puk,puk2,category,sp_id,credit,tariff_id,lang_id,services,code_sms,bolsas_flexibles,recargas_flexibles,recargas_agendadas,casilla,cdr,origen,
    status,hlr_prov_code,idOT,comandos_hlr,activacion_vas,imsi_gemela,perfil_coresim,flag_virtual,tipo,profile_hlr,perfil_sapc)
    values (${MSISDN},${IMSI},${ICCID},\"1234\",\"1234\",\"1234\",\"1234\",${category},${sp_id},${credit},${tariff_id},${lang_id},${services},${codigo_sms},${bolsas_flexibles},${recargas_flexibles},${recargas_agendadas},${voicemail},
    ${cdr},'Reporcesando',0,0,0,${comandos_hlr},${activacion_vas},${IMSI},${perfil_coresim},0,\"PORT-IN\",${perfil_hlr},${perfil_sapc});"

    echo ${INSERT_FINAL}
    #${MYSQL} -h${HOST_BD} -u${USER_BD} -p${PASS_BD} SIP -e "${INSERT_FINAL}"
    #LOGOK "PCSFILE CREADO"
    fi
}

CREA_PCSFILE ${MSISDN} ${IMSI} ${ICCID} ${PERFIL}
