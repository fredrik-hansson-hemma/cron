# Namn   :      checkServerStatus.sh
# Purpose:      Script for printing sas server status.
# Created:      2016-04-21  Mattias Moliis
# Changes:      
#
# Print sasserver status to temporary file.

# Kollar status enbart på huvudnoden
# /opt/sas/config/Lev1/sas.servers status > /tmp/SASServerStatus.txt

# Kollar status på huvudnoden och workernoderna
# To do: Kolla även Office Analytics-servern
echo "Filen skapades:" > /tmp/SASServerStatus.txt
date >> /tmp/SASServerStatus.txt
echo " " >> /tmp/SASServerStatus.txt
/opt/sas/config/Lev1/status_nodes.sh >> /tmp/SASServerStatus.txt