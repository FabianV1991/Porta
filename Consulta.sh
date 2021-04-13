#!/bin/bash

USER="tashuawei"
HOST="xxxxxxxx"
NP1A="xxxxxxxx"
NP1B="xxxxxxxxxxx"
NP2A="xxxxxxxxxxx"
NP2B="xxxxxxxxxxx"

MSISDN=$1

(expect -c "
spawn ssh -o StrictHostKeyChecking=no ${USER}@${HOST}
match_max 100000
expect \"*?tas_huawei*\"
send -- \"ssh root@np1a\r\"
expect \"*?np1a*\"
send -- \"echo "consulta_porta";echo "NP1A";ssh root@10.251.27.193 '/var/www/portabilidad/consulta_porta.sh ${NP1A} ${MSISDN}\r\'\r\"
send -- \"echo "NP1B";ssh root@10.251.27.193 '/var/www/portabilidad/consulta_porta.sh ${NP1B} ${MSISDN}\r\'\r\"
send -- \"echo "NP2A";ssh root@10.251.27.193 '/var/www/portabilidad/consulta_porta.sh ${NP2A} ${MSISDN}\r\'\r\"
send -- \"echo "NP2B";ssh root@10.251.27.193 '/var/www/portabilidad/consulta_porta.sh ${NP2B} ${MSISDN}\r\'\r\"
send -- \"echo "consulta_sscc";echo "NP1A";ssh root@10.251.27.193 '/var/www/html/portabilidad/consulta_sscc.sh ${NP1A} ${MSISDN}\r\'\r\"
send -- \"echo "NP1B";ssh root@10.251.27.193 '/var/www/html/portabilidad/consulta_sscc.sh ${NP1B} ${MSISDN}\r\'\r\"
send -- \"echo "NP2A";ssh root@10.251.27.193 '/var/www/html/portabilidad/consulta_sscc.sh ${NP2A} ${MSISDN}\r\'\r\"
send -- \"echo "NP2B";ssh root@10.251.27.193 '/var/www/html/portabilidad/consulta_sscc.sh ${NP2B} ${MSISDN}\r\'\r\"
send -- \"echo "consulta_numberPlan";echo "NP1A";ssh root@10.251.27.193 '/var/www/html/portabilidad/consulta_numberplan.sh ${NP1A} ${MSISDN}\r\'\r\"
send -- \"echo "NP1B";ssh root@10.251.27.193 '/var/www/html/portabilidad/consulta_numberplan.sh ${NP1B} ${MSISDN}\r\'\r\"
send -- \"echo "NP2A";ssh root@10.251.27.193 '/var/www/html/portabilidad/consulta_numberplan.sh ${NP2A} ${MSISDN}\r\'\r\"
send -- \"echo "NP2B";ssh root@10.251.27.193 '/var/www/html/portabilidad/consulta_numberplan.sh ${NP2B} ${MSISDN}\r\'\r\"
expect eof")
